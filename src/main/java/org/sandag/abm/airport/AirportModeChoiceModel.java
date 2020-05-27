package org.sandag.abm.airport;

import java.util.HashMap;

import org.apache.log4j.Logger;
import org.sandag.abm.accessibilities.BestTransitPathCalculator;
import org.sandag.abm.accessibilities.DriveTransitWalkSkimsCalculator;
import org.sandag.abm.accessibilities.WalkTransitDriveSkimsCalculator;
import org.sandag.abm.accessibilities.WalkTransitWalkSkimsCalculator;
import org.sandag.abm.ctramp.CtrampApplication;
import org.sandag.abm.ctramp.Util;
import org.sandag.abm.modechoice.MgraDataManager;
import org.sandag.abm.modechoice.TazDataManager;

import com.pb.common.calculator.VariableTable;
import com.pb.common.newmodel.ChoiceModelApplication;
import com.pb.common.util.Tracer;

public class AirportModeChoiceModel
{
    private transient Logger                  logger = Logger.getLogger("airportModel");

    private TazDataManager                    tazManager;
    private MgraDataManager                   mgraManager;

    private ChoiceModelApplication[]          driveAloneModel;
    private ChoiceModelApplication[]          shared2Model;
    private ChoiceModelApplication[]          shared3Model;
    private ChoiceModelApplication            transitModel;
    private ChoiceModelApplication            accessModel;
    private ChoiceModelApplication			  mgraModel;

    private Tracer                            tracer;
    private boolean                           trace;
    private int[]                             traceOtaz;
    private int[]                             traceDtaz;
    private boolean                           seek;
    private HashMap<String, String>           rbMap;

    private BestTransitPathCalculator         bestPathUEC;
    protected WalkTransitWalkSkimsCalculator  wtw;
    protected WalkTransitDriveSkimsCalculator wtd;
    protected DriveTransitWalkSkimsCalculator dtw;

    /**
     * Constructor
     * 
     * @param propertyMap
     *            Resource properties file map.
     * @param dmuFactory
     *            Factory object for creation of airport model DMUs
     */
    public AirportModeChoiceModel(HashMap<String, String> rbMap, AirportDmuFactoryIf dmuFactory)
    {

        this.rbMap = rbMap;

        tazManager = TazDataManager.getInstance(rbMap);
        mgraManager = MgraDataManager.getInstance(rbMap);

        String uecFileDirectory = Util.getStringValueFromPropertyMap(rbMap,
                CtrampApplication.PROPERTIES_UEC_PATH);
        String airportModeUecFileName = Util.getStringValueFromPropertyMap(rbMap,
                "airport.mc.uec.file");
        airportModeUecFileName = uecFileDirectory + airportModeUecFileName;

        int dataPage = Integer.parseInt(Util.getStringValueFromPropertyMap(rbMap,
                "airport.mc.data.page"));
        int daPage = Integer.parseInt(Util.getStringValueFromPropertyMap(rbMap,
                "airport.mc.da.page"));
        int s2Page = Integer.parseInt(Util.getStringValueFromPropertyMap(rbMap,
                "airport.mc.s2.page"));
        int s3Page = Integer.parseInt(Util.getStringValueFromPropertyMap(rbMap,
                "airport.mc.s3.page"));
        int transitPage = Integer.parseInt(Util.getStringValueFromPropertyMap(rbMap,
                "airport.mc.transit.page"));
        int accessPage = Integer.parseInt(Util.getStringValueFromPropertyMap(rbMap,
                "airport.mc.accessMode.page"));
        int mgraPage = Integer.parseInt(Util.getStringValueFromPropertyMap(rbMap, 
        		"airport.mc.mgra.page"));

        logger.info("Creating Airport Model Mode Choice Application UECs");

        // create a DMU
        AirportModelDMU dmu = dmuFactory.getAirportModelDMU();
        
        // get MAX mgra to initialize mgra size array in dmu
        int maxMgra = mgraManager.getMaxMgra();
        dmu.setMaxMgra(maxMgra);
        
        // fake choice model to get airport access MGRA input
        mgraModel = new ChoiceModelApplication(airportModeUecFileName, mgraPage, dataPage,
        		rbMap, (VariableTable) dmu);   

        // create ChoiceModelApplication objects for each airport mgra
        driveAloneModel = new ChoiceModelApplication[5];
        shared2Model = new ChoiceModelApplication[5];
        shared3Model = new ChoiceModelApplication[5];
        
        for (int i = 0; i < 5; i++){
        	// create a ChoiceModelApplication object for drive-alone mode choice
        	driveAloneModel[i] = new ChoiceModelApplication(airportModeUecFileName, daPage, dataPage,
                    rbMap, (VariableTable) dmu);
        	// create a ChoiceModelApplication object for shared 2 mode choice
        	shared2Model[i] = new ChoiceModelApplication(airportModeUecFileName, s2Page, dataPage,
                    rbMap, (VariableTable) dmu);
        	// create a ChoiceModelApplication object for shared 3+ mode choice
        	shared3Model[i] = new ChoiceModelApplication(airportModeUecFileName, s3Page, dataPage,
                    rbMap, (VariableTable) dmu);
        }
        
        // create a ChoiceModelApplication object for transit mode choice
        transitModel = new ChoiceModelApplication(airportModeUecFileName, transitPage, dataPage,
                rbMap, (VariableTable) dmu);

        // create a ChoiceModelApplication object for access mode choice
        accessModel = new ChoiceModelApplication(airportModeUecFileName, accessPage, dataPage,
                rbMap, (VariableTable) dmu);

        logger.info("Finished Creating Airport Model Mode Choice Application UECs");

        // set up the tracer object
        trace = Util.getBooleanValueFromPropertyMap(rbMap, "Trace");
        traceOtaz = Util.getIntegerArrayFromPropertyMap(rbMap, "Trace.otaz");
        traceDtaz = Util.getIntegerArrayFromPropertyMap(rbMap, "Trace.dtaz");
        tracer = Tracer.getTracer();
        tracer.setTrace(trace);

        if (trace)
        {
            for (int i = 0; i < traceOtaz.length; i++)
            {
                for (int j = 0; j < traceDtaz.length; j++)
                {
                    tracer.traceZonePair(traceOtaz[i], traceDtaz[j]);
                }
            }
        }
        seek = Util.getBooleanValueFromPropertyMap(rbMap, "Seek");

    }

    /**
     * Create new transit skim calculators.
     */
    public void initializeBestPathCalculators()
    {

        logger.info("Initializing Airport Model Best Path Calculators");

        bestPathUEC = new BestTransitPathCalculator(rbMap);

        wtw = new WalkTransitWalkSkimsCalculator();
        wtw.setup(rbMap, logger, bestPathUEC);
        wtd = new WalkTransitDriveSkimsCalculator();
        wtd.setup(rbMap, logger, bestPathUEC);
        dtw = new DriveTransitWalkSkimsCalculator();
        dtw.setup(rbMap, logger, bestPathUEC);

        logger.info("Finished Initializing Airport Model Best Path Calculators");

    }
    
    /**
     * get access mode MGRA from UEC user input
     */
    public void solveModeMgra(AirportModelDMU dmu){  //question for Jim -- Do I need dmu index for this one?
    	mgraModel.computeUtilities(dmu, dmu.getDmuIndex());

    	int modeCount = mgraModel.getNumberOfAlternatives();
    	double[] mgraValues = mgraModel.getUtilities();
    	
    	HashMap<Integer, Integer> modeMgraMap = new HashMap<Integer, Integer>();
    	
    	for (int m = 0; m < modeCount; m++){
    		int mgraValue = (int)Math.round(mgraValues[m]);
    		modeMgraMap.put(m+1, mgraValue);
    	}
    	
    	dmu.setModeMgraMap(modeMgraMap);
    	dmu.setMgraIndexMap();
    	dmu.setTravelTimeArraySize();
    }

    /**
     * Choose airport arrival mode and trip mode for this party. Store results
     * in the party object passed as argument.
     * 
     * @param party
     *            The travel party
     * @param dmu
     *            An airport model DMU
     */
    public void chooseMode(AirportParty party, AirportModelDMU dmu)
    {

        int origMgra = party.getOriginMGRA();
        int destMgra = party.getDestinationMGRA();
        int direction = party.getDirection();
        int airportMgra = 0;
        int airportMgra_index = 0;
        int nonAirportMgra = 0;
        int accessOrigMgra = 0;
        int accessDestMgra = 0;
        int accessOrigTaz = 0;
        int accessDestTaz = 0;
        if (direction == 0){ //departure
        	nonAirportMgra = origMgra;
        } else { //arrival
        	nonAirportMgra = destMgra;
        }
        dmu.setNonAirportMgra(nonAirportMgra);
        dmu.setDirection(direction);
        int origTaz = mgraManager.getTaz(origMgra);
        int destTaz = mgraManager.getTaz(destMgra);   
        int period = party.getDepartTime();
        int skimPeriod = AirportModelStructure.getSkimPeriodIndex(period) + 1; // The
                                                                               // skims
                                                                               // are
                                                                               // stored
                                                                               // 1-based...don't
                                                                               // ask...
        boolean debug = party.getDebugChoiceModels();

        // calculate best tap pairs for this airport party
        int[][] walkTransitTapPairs = wtw.getBestTapPairs(origMgra, destMgra, skimPeriod, debug,
                logger);
        party.setBestWtwTapPairs(walkTransitTapPairs);

        // drive transit tap pairs depend on direction; departing parties use
        // drive-transit-walk, else walk-transit-drive is used.
        int[][] driveTransitTapPairs;
        if (party.getDirection() == AirportModelStructure.DEPARTURE)
        {
            driveTransitTapPairs = dtw.getBestTapPairs(origMgra, destMgra, skimPeriod, debug,
                    logger);
            party.setBestDtwTapPairs(driveTransitTapPairs);
        } else
        {
            driveTransitTapPairs = wtd.getBestTapPairs(origMgra, destMgra, skimPeriod, debug,
                    logger);
            party.setBestWtdTapPairs(driveTransitTapPairs);
        }

        // set transit skim values in DMU object
        dmu.setDmuSkimCalculators(wtw, wtd, dtw);
        boolean inbound = false;
        if (party.getDirection() == AirportModelStructure.ARRIVAL) inbound = true;

        dmu.setAirportParty(party);
        //dmu.setDmuIndexValues(party.getID(), origTaz, destTaz);  // should this be access point Taz?
        dmu.setDmuSkimAttributes(origMgra, destMgra, period, inbound, debug);

        // Solve trip mode level utilities
        
        for (int mode = 1; mode <= AirportModelStructure.ACCESS_MODES; mode++){
        	airportMgra = dmu.mode_mgra_map.get(mode);
        	//dmu.setAirportMgra(airportMgra);
        	airportMgra_index = dmu.mgra_index_map.get(airportMgra);
        	
        	if (direction == 0){ //departure
            	accessOrigMgra = origMgra;
            	accessDestMgra = airportMgra;
            } else { //arrival
            	accessOrigMgra = airportMgra;
            	accessOrigMgra = destMgra;
            }
        	
        	accessOrigTaz = mgraManager.getTaz(accessOrigMgra);
        	accessDestTaz = mgraManager.getTaz(accessDestMgra);
        	
        	dmu.setDmuIndexValues(party.getID(), accessOrigTaz, accessDestTaz);  // should this be access point Taz?
        	
        	for (int los = 0; los < AirportModelStructure.LOS_TYPE; los++){
        		double travelTime = dmu.getModeTravelTime(nonAirportMgra, airportMgra, direction, los);
        		if (travelTime == 0){
        			if (los == 0){
        				driveAloneModel[airportMgra_index].computeUtilities(dmu, dmu.getDmuIndex());
        				double driveAloneLogsum = driveAloneModel[airportMgra_index].getLogsum();
        				dmu.setModeTravelTime(nonAirportMgra, airportMgra, direction, los, driveAloneLogsum);
        			}
        			else if (los == 1){
        				shared2Model[airportMgra_index].computeUtilities(dmu, dmu.getDmuIndex());
        				double shared2Logsum = shared2Model[airportMgra_index].getLogsum();
        	            dmu.setModeTravelTime(nonAirportMgra, airportMgra, direction, los, shared2Logsum);
        			}
        			else if (los == 2){
        				shared3Model[airportMgra_index].computeUtilities(dmu, dmu.getDmuIndex());
        	            double shared3Logsum = shared3Model[airportMgra_index].getLogsum();
        	            dmu.setModeTravelTime(nonAirportMgra, airportMgra, direction, los, shared3Logsum);
        			}
        			else {
        				transitModel.computeUtilities(dmu, dmu.getDmuIndex());
        		        double transitLogsum = transitModel.getLogsum();
        		        dmu.setModeTravelTime(nonAirportMgra, airportMgra, direction, los, transitLogsum);
        			}
        		}
        	}
        }
        
        // calculate access mode utility and choose access mode
        accessModel.computeUtilities(dmu, dmu.getDmuIndex());
        int accessMode = accessModel.getChoiceResult(party.getRandom());
        party.setArrivalMode((byte) accessMode);

        // add debug
        if (party.getID() == 2)
        {
        	String choiceModelDescription = "";
            String decisionMakerLabel = "";
            String loggingHeader = "";
            String separator = "";
             
        	choiceModelDescription = String.format(
                    "Airport Mode Choice Model for: Purpose=%s, OrigMGRA=%d, DestMGRA=%d",
                    party.getPurpose(), party.getOriginMGRA(), party.getDestinationMGRA());
            decisionMakerLabel = String.format("partyID=%d, partySize=%d, purpose=%s, direction=%d",
                    party.getID(), party.getSize(),
                    party.getPurpose(), party.getDirection());
            loggingHeader = String.format("%s    %s", choiceModelDescription,
                    decisionMakerLabel);
            
            logger.info(loggingHeader);
            accessModel.logUECResults(logger);
        }
 
        // choose trip mode
        int tripMode = 0;
        int occupancy = AirportModelStructure.getOccupancy(accessMode, party.getSize());
        double randomNumber = party.getRandom();

        if (accessMode != AirportModelStructure.TRANSIT)
        {
        	int chosenAirportMgra = dmu.mode_mgra_map.get(accessMode);
        	int chosenAirportMgra_index = dmu.mgra_index_map.get(chosenAirportMgra);
            if (occupancy == 1)
            {
                int choice = driveAloneModel[chosenAirportMgra_index].getChoiceResult(randomNumber);
                tripMode = choice;
            } else if (occupancy == 2)
            {
                int choice = shared2Model[chosenAirportMgra_index].getChoiceResult(randomNumber);
                tripMode = choice + 2;
            } else if (occupancy > 2)
            {
                int choice = shared3Model[chosenAirportMgra_index].getChoiceResult(randomNumber);
                tripMode = choice + 3 + 2;
            }
        } else
        {
            int choice = transitModel.getChoiceResult(randomNumber);
            if (choice <= 5) tripMode = choice + 10;
            else tripMode = choice + 15;
        }
        party.setMode((byte) tripMode);
    }

    /**
     * Choose modes for internal trips.
     * 
     * @param airportParties
     *            An array of travel parties, with destinations already chosen.
     * @param dmuFactory
     *            A DMU Factory.
     */
    public void chooseModes(AirportParty[] airportParties, AirportDmuFactoryIf dmuFactory)
    {

        AirportModelDMU dmu = dmuFactory.getAirportModelDMU();
        solveModeMgra(dmu);
        // iterate through the array, choosing mgras and setting them
        for (AirportParty party : airportParties)
        {

            int ID = party.getID();

            if ((ID <= 5) || (ID % 100) == 0)
                logger.info("Choosing mode for party " + party.getID());

            if (party.getPurpose() < AirportModelStructure.INTERNAL_PURPOSES) chooseMode(party, dmu);
            else
            {
                party.setArrivalMode((byte) -99);
                party.setMode((byte) -99);
            }
        }
    }

    /**
     * @param wtw
     *            the wtw to set
     */
    public void setWtw(WalkTransitWalkSkimsCalculator wtw)
    {
        this.wtw = wtw;
    }

    /**
     * @param wtd
     *            the wtd to set
     */
    public void setWtd(WalkTransitDriveSkimsCalculator wtd)
    {
        this.wtd = wtd;
    }

    /**
     * @param dtw
     *            the dtw to set
     */
    public void setDtw(DriveTransitWalkSkimsCalculator dtw)
    {
        this.dtw = dtw;
    }

}
