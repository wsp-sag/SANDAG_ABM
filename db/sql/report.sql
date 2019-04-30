-- Create report schema
IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name='report')
EXEC ('CREATE SCHEMA [report]')
GO

-- Add metadata for [report]
IF EXISTS(SELECT * FROM [db_meta].[data_dictionary] WHERE [ObjectType] = 'SCHEMA' AND [FullObjectName] = '[report]' AND [PropertyName] = 'MS_Description')
EXECUTE [db_meta].[drop_xp] 'report', 'MS_Description'

EXECUTE [db_meta].[add_xp] 'report', 'MS_Description', 'schema to hold all objects associated with reporting outputs of the abm model'
GO




-- grant read/execute permissions to abm_user role
GRANT EXECUTE ON SCHEMA :: [report] TO [abm_user]
GRANT SELECT ON SCHEMA :: [report] TO [abm_user]
GRANT VIEW DEFINITION ON SCHEMA :: [report] TO [abm_user]




-- Create bike flow report view
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[report].[bike_flow]') AND type in ('V'))
DROP VIEW [report].[bike_flow]
GO

CREATE VIEW [report].[bike_flow] AS
	SELECT
		[bike_flow].[scenario_id]
		,[bike_flow].[bike_link_id]
		,[bike_link].[roadsegid]
		,[bike_link].[nm]
		,[bike_link].[functional_class]
		,[bike_link].[bike2sep]
		,[bike_link].[bike3blvd]
		,[bike_link].[speed]
		,[bike_link].[distance]
		,[bike_link].[scenicldx]
		,[bike_link].[shape]
		,[bike_flow].[bike_link_ab_id]
		,[bike_link_ab].[ab]
		,[bike_link_ab].[from_node]
		,[bike_link_ab].[to_node]
		,[bike_link_ab].[gain]
		,[bike_link_ab].[bike_class]
		,[bike_link_ab].[lanes]
		,[bike_link_ab].[from_signal]
		,[bike_link_ab].[to_signal]
		,[bike_flow].[time_id]
		,[time].[abm_half_hour]
		,[time].[abm_half_hour_period_start]
		,[time].[abm_half_hour_period_end]
		,[time].[abm_5_tod]
		,[time].[abm_5_tod_period_start]
		,[time].[abm_5_tod_period_end]
		,[time].[day]
		,[time].[day_period_start]
		,[time].[day_period_end]
		,[bike_flow].[flow]
	FROM
		[fact].[bike_flow]
	INNER JOIN
		[dimension].[bike_link]
	ON
		[bike_flow].[scenario_id] = [bike_link].[scenario_id]
		AND [bike_flow].[bike_link_id] = [bike_link].[bike_link_id]
	INNER JOIN
		[dimension].[bike_link_ab]
	ON
		[bike_flow].[scenario_id] = [bike_link_ab].[scenario_id]
		AND [bike_flow].[bike_link_ab_id] = [bike_link_ab].[bike_link_ab_id]
	INNER JOIN
		[dimension].[time]
	ON
		[bike_flow].[time_id] = [time].[time_id]
GO

-- Add metadata for [report].[bike_flow]
EXECUTE [db_meta].[add_xp] 'report.bike_flow', 'SUBSYSTEM', 'report'
EXECUTE [db_meta].[add_xp] 'report.bike_flow', 'MS_Description', 'bike flow fact table joined to all dimension tables'
GO




-- Create highway flow report view
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[report].[hwy_flow]') AND type in ('V'))
DROP VIEW [report].[hwy_flow]
GO

CREATE VIEW [report].[hwy_flow] AS
	SELECT
		[hwy_flow].[scenario_id]
		,[hwy_flow].[hwy_flow_id]
		,[hwy_flow].[hwy_link_id]
		,[hwy_link].[hwycov_id]
		,[hwy_link].[length_mile]
		,[hwy_link].[sphere]
		,[hwy_link].[nm]
		,[hwy_link].[cojur]
		,[hwy_link].[costat]
		,[hwy_link].[coloc]
		,[hwy_link].[rloop]
		,[hwy_link].[adtlk]
		,[hwy_link].[adtvl]
		,[hwy_link].[aspd]
		,[hwy_link].[iyr]
		,[hwy_link].[iproj]
		,[hwy_link].[ijur]
		,[hwy_link].[ifc]
		,[hwy_link].[ihov]
		,[hwy_link].[itruck]
		,[hwy_link].[ispd]
		,[hwy_link].[iway]
		,[hwy_link].[imed]
		,[hwy_link].[shape]
		,[hwy_flow].[hwy_link_ab_id]
		,[hwy_link_ab].[ab]
		,[hwy_link_ab].[from_node]
		,[hwy_link_ab].[to_node]
		,[hwy_link_ab].[from_nm]
		,[hwy_link_ab].[to_nm]
		,[hwy_link_ab].[au]
		,[hwy_link_ab].[pct]
		,[hwy_link_ab].[cnt]
		,[hwy_flow].[hwy_link_tod_id]
		,[hwy_link_tod].[itoll]
		,[hwy_link_tod].[itoll2]
		,[hwy_link_tod].[itoll3]
		,[hwy_link_tod].[itoll4]
		,[hwy_link_tod].[itoll5]
		,[hwy_flow].[hwy_link_ab_tod_id]
		,[hwy_link_ab_tod].[cp]
		,[hwy_link_ab_tod].[cx]
		,[hwy_link_ab_tod].[tm]
		,[hwy_link_ab_tod].[tx]
		,[hwy_link_ab_tod].[ln]
		,[hwy_link_ab_tod].[stm]
		,[hwy_link_ab_tod].[htm]
		,[hwy_flow].[time_id]
		,[time].[abm_half_hour]
		,[time].[abm_half_hour_period_start]
		,[time].[abm_half_hour_period_end]
		,[time].[abm_5_tod]
		,[time].[abm_5_tod_period_start]
		,[time].[abm_5_tod_period_end]
		,[time].[day]
		,[time].[day_period_start]
		,[time].[day_period_end]
		,[hwy_flow].[flow_pce]
		,[hwy_flow].[time]
		,[hwy_flow].[voc]
		,[hwy_flow].[v_dist_t]
		,[hwy_flow].[vht]
		,[hwy_flow].[speed]
		,[hwy_flow].[vdf]
		,[hwy_flow].[msa_flow]
		,[hwy_flow].[msa_time]
		,[hwy_flow].[flow]
	FROM
		[fact].[hwy_flow]
	INNER JOIN
		[dimension].[hwy_link]
	ON
		[hwy_flow].[scenario_id] = [hwy_link].[scenario_id]
		AND [hwy_flow].[hwy_link_id] = [hwy_link].[hwy_link_id]
	INNER JOIN
		[dimension].[hwy_link_ab]
	ON
		[hwy_flow].[scenario_id] = [hwy_link_ab].[scenario_id]
		AND [hwy_flow].[hwy_link_ab_id] = [hwy_link_ab].[hwy_link_ab_id]
	INNER JOIN
		[dimension].[hwy_link_tod]
	ON
		[hwy_flow].[scenario_id] = [hwy_link_tod].[scenario_id]
		AND [hwy_flow].[hwy_link_tod_id] = [hwy_link_tod].[hwy_link_tod_id]
	INNER JOIN
		[dimension].[hwy_link_ab_tod]
	ON
		[hwy_flow].[scenario_id] = [hwy_link_ab_tod].[scenario_id]
		AND [hwy_flow].[hwy_link_ab_tod_id] = [hwy_link_ab_tod].[hwy_link_ab_tod_id]
	INNER JOIN
		[dimension].[time]
	ON
		[hwy_flow].[time_id] = [time].[time_id]
GO

-- Add metadata for [report].[hwy_flow]
EXECUTE [db_meta].[add_xp] 'report.hwy_flow', 'SUBSYSTEM', 'report'
EXECUTE [db_meta].[add_xp] 'report.hwy_flow', 'MS_Description', 'highway flow fact table joined to all dimension tables'
GO




-- Create highway flow by mode report view
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[report].[hwy_flow_mode]') AND type in ('V'))
DROP VIEW [report].[hwy_flow_mode]
GO

CREATE VIEW [report].[hwy_flow_mode] AS
	SELECT
		[hwy_flow_mode].[scenario_id]
		,[hwy_flow_mode].[hwy_flow_mode_id]
		,[hwy_flow_mode].[hwy_link_id]
		,[hwy_link].[hwycov_id]
		,[hwy_link].[length_mile]
		,[hwy_link].[sphere]
		,[hwy_link].[nm]
		,[hwy_link].[cojur]
		,[hwy_link].[costat]
		,[hwy_link].[coloc]
		,[hwy_link].[rloop]
		,[hwy_link].[adtlk]
		,[hwy_link].[adtvl]
		,[hwy_link].[aspd]
		,[hwy_link].[iyr]
		,[hwy_link].[iproj]
		,[hwy_link].[ijur]
		,[hwy_link].[ifc]
		,[hwy_link].[ihov]
		,[hwy_link].[itruck]
		,[hwy_link].[ispd]
		,[hwy_link].[iway]
		,[hwy_link].[imed]
		,[hwy_link].[shape]
		,[hwy_flow_mode].[hwy_link_ab_id]
		,[hwy_link_ab].[ab]
		,[hwy_link_ab].[from_node]
		,[hwy_link_ab].[to_node]
		,[hwy_link_ab].[from_nm]
		,[hwy_link_ab].[to_nm]
		,[hwy_link_ab].[au]
		,[hwy_link_ab].[pct]
		,[hwy_link_ab].[cnt]
		,[hwy_flow_mode].[hwy_link_tod_id]
		,[hwy_link_tod].[itoll]
		,[hwy_link_tod].[itoll2]
		,[hwy_link_tod].[itoll3]
		,[hwy_link_tod].[itoll4]
		,[hwy_link_tod].[itoll5]
		,[hwy_flow_mode].[hwy_link_ab_tod_id]
		,[hwy_link_ab_tod].[cp]
		,[hwy_link_ab_tod].[cx]
		,[hwy_link_ab_tod].[tm]
		,[hwy_link_ab_tod].[tx]
		,[hwy_link_ab_tod].[ln]
		,[hwy_link_ab_tod].[stm]
		,[hwy_link_ab_tod].[htm]
		,[hwy_flow_mode].[time_id]
		,[time].[abm_half_hour]
		,[time].[abm_half_hour_period_start]
		,[time].[abm_half_hour_period_end]
		,[time].[abm_5_tod]
		,[time].[abm_5_tod_period_start]
		,[time].[abm_5_tod_period_end]
		,[time].[day]
		,[time].[day_period_start]
		,[time].[day_period_end]
		,[hwy_flow_mode].[mode_id]
		,[mode].[mode_description]
		,[mode].[mode_aggregate_description]
		,[hwy_flow_mode].[flow]
	FROM
		[fact].[hwy_flow_mode]
	INNER JOIN
		[dimension].[hwy_link]
	ON
		[hwy_flow_mode].[scenario_id] = [hwy_link].[scenario_id]
		AND [hwy_flow_mode].[hwy_link_id] = [hwy_link].[hwy_link_id]
	INNER JOIN
		[dimension].[hwy_link_ab]
	ON
		[hwy_flow_mode].[scenario_id] = [hwy_link_ab].[scenario_id]
		AND [hwy_flow_mode].[hwy_link_ab_id] = [hwy_link_ab].[hwy_link_ab_id]
	INNER JOIN
		[dimension].[hwy_link_tod]
	ON
		[hwy_flow_mode].[scenario_id] = [hwy_link_tod].[scenario_id]
		AND [hwy_flow_mode].[hwy_link_tod_id] = [hwy_link_tod].[hwy_link_tod_id]
	INNER JOIN
		[dimension].[hwy_link_ab_tod]
	ON
		[hwy_flow_mode].[scenario_id] = [hwy_link_ab_tod].[scenario_id]
		AND [hwy_flow_mode].[hwy_link_ab_tod_id] = [hwy_link_ab_tod].[hwy_link_ab_tod_id]
	INNER JOIN
		[dimension].[time]
	ON
		[hwy_flow_mode].[time_id] = [time].[time_id]
	INNER JOIN
		[dimension].[mode]
	ON
		[hwy_flow_mode].[mode_id] = [mode].[mode_id]
GO

-- Add metadata for [report].[hwy_flow_mode]
EXECUTE [db_meta].[add_xp] 'report.hwy_flow_mode', 'SUBSYSTEM', 'report'
EXECUTE [db_meta].[add_xp] 'report.hwy_flow_mode', 'MS_Description', 'highway flow by mode fact table joined to all dimension tables'
GO




-- Create mgra based input report view
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[report].[mgra_based_input]') AND type in ('V'))
DROP VIEW [report].[mgra_based_input]
GO

CREATE VIEW [report].[mgra_based_input] AS
	SELECT
		[mgra_based_input].[scenario_id]
		,[mgra_based_input].[mgra_based_input_id]
		,[mgra_based_input].[geography_id]
		,[geography].[mgra_13]
		,[geography].[mgra_13_shape]
		,[geography].[taz_13]
		,[geography].[taz_13_shape]
		,[geography].[luz_13]
		,[geography].[luz_13_shape]
		,[geography].[cicpa_2016]
		,[geography].[cicpa_2016_name]
		,[geography].[cicpa_2016_shape]
		,[geography].[cocpa_2016]
		,[geography].[cocpa_2016_name]
		,[geography].[cocpa_2016_shape]
		,[geography].[jurisdiction_2016]
		,[geography].[jurisdiction_2016_name]
		,[geography].[jurisdiction_2016_shape]
		,[geography].[region_2004]
		,[geography].[region_2004_name]
		,[geography].[region_2004_shape]
		,[geography].[external_zone]
		,[mgra_based_input].[hs]
		,[mgra_based_input].[hs_sf]
		,[mgra_based_input].[hs_mf]
		,[mgra_based_input].[hs_mh]
		,[mgra_based_input].[hh]
		,[mgra_based_input].[hh_sf]
		,[mgra_based_input].[hh_mf]
		,[mgra_based_input].[hh_mh]
		,[mgra_based_input].[gq_civ]
		,[mgra_based_input].[gq_mil]
		,[mgra_based_input].[i1]
		,[mgra_based_input].[i2]
		,[mgra_based_input].[i3]
		,[mgra_based_input].[i4]
		,[mgra_based_input].[i5]
		,[mgra_based_input].[i6]
		,[mgra_based_input].[i7]
		,[mgra_based_input].[i8]
		,[mgra_based_input].[i9]
		,[mgra_based_input].[i10]
		,[mgra_based_input].[hhs]
		,[mgra_based_input].[pop]
		,[mgra_based_input].[hhp]
		,[mgra_based_input].[emp_ag]
		,[mgra_based_input].[emp_const_non_bldg_prod]
		,[mgra_based_input].[emp_const_non_bldg_office]
		,[mgra_based_input].[emp_utilities_prod]
		,[mgra_based_input].[emp_utilities_office]
		,[mgra_based_input].[emp_const_bldg_prod]
		,[mgra_based_input].[emp_const_bldg_office]
		,[mgra_based_input].[emp_mfg_prod]
		,[mgra_based_input].[emp_mfg_office]
		,[mgra_based_input].[emp_whsle_whs]
		,[mgra_based_input].[emp_trans]
		,[mgra_based_input].[emp_retail]
		,[mgra_based_input].[emp_prof_bus_svcs]
		,[mgra_based_input].[emp_prof_bus_svcs_bldg_maint]
		,[mgra_based_input].[emp_pvt_ed_k12]
		,[mgra_based_input].[emp_pvt_ed_post_k12_oth]
		,[mgra_based_input].[emp_health]
		,[mgra_based_input].[emp_personal_svcs_office]
		,[mgra_based_input].[emp_amusement]
		,[mgra_based_input].[emp_hotel]
		,[mgra_based_input].[emp_restaurant_bar]
		,[mgra_based_input].[emp_personal_svcs_retail]
		,[mgra_based_input].[emp_religious]
		,[mgra_based_input].[emp_pvt_hh]
		,[mgra_based_input].[emp_state_local_gov_ent]
		,[mgra_based_input].[emp_fed_non_mil]
		,[mgra_based_input].[emp_fed_mil]
		,[mgra_based_input].[emp_state_local_gov_blue]
		,[mgra_based_input].[emp_state_local_gov_white]
		,[mgra_based_input].[emp_public_ed]
		,[mgra_based_input].[emp_own_occ_dwell_mgmt]
		,[mgra_based_input].[emp_fed_gov_accts]
		,[mgra_based_input].[emp_st_lcl_gov_accts]
		,[mgra_based_input].[emp_cap_accts]
		,[mgra_based_input].[emp_total]
		,[mgra_based_input].[enrollgradekto8]
		,[mgra_based_input].[enrollgrade9to12]
		,[mgra_based_input].[collegeenroll]
		,[mgra_based_input].[othercollegeenroll]
		,[mgra_based_input].[adultschenrl]
		,[mgra_based_input].[ech_dist]
		,[mgra_based_input].[hch_dist]
		,[mgra_based_input].[pseudomsa]
		,[mgra_based_input].[parkarea]
		,[mgra_based_input].[hstallsoth]
		,[mgra_based_input].[hstallssam]
		,[mgra_based_input].[hparkcost]
		,[mgra_based_input].[numfreehrs]
		,[mgra_based_input].[dstallsoth]
		,[mgra_based_input].[dstallssam]
		,[mgra_based_input].[dparkcost]
		,[mgra_based_input].[mstallsoth]
		,[mgra_based_input].[mstallssam]
		,[mgra_based_input].[mparkcost]
		,[mgra_based_input].[totint]
		,[mgra_based_input].[duden]
		,[mgra_based_input].[empden]
		,[mgra_based_input].[popden]
		,[mgra_based_input].[retempden]
		,[mgra_based_input].[totintbin]
		,[mgra_based_input].[empdenbin]
		,[mgra_based_input].[dudenbin]
		,[mgra_based_input].[zip09]
		,[mgra_based_input].[parkactive]
		,[mgra_based_input].[openspaceparkpreserve]
		,[mgra_based_input].[beachactive]
		,[mgra_based_input].[budgetroom]
		,[mgra_based_input].[economyroom]
		,[mgra_based_input].[luxuryroom]
		,[mgra_based_input].[midpriceroom]
		,[mgra_based_input].[upscaleroom]
		,[mgra_based_input].[hotelroomtotal]
		,[mgra_based_input].[truckregiontype]
		,[mgra_based_input].[district27]
		,[mgra_based_input].[milestocoast]
		,[mgra_based_input].[acres]
		,[mgra_based_input].[effective_acres]
		,[mgra_based_input].[land_acres]
	FROM
		[fact].[mgra_based_input]
	INNER JOIN
		[dimension].[geography]
	ON
		[mgra_based_input].[geography_id] = [geography].[geography_id]
GO

-- Add metadata for [report].[mgra_based_input]
EXECUTE [db_meta].[add_xp] 'report.mgra_based_input', 'SUBSYSTEM', 'report'
EXECUTE [db_meta].[add_xp] 'report.mgra_based_input', 'MS_Description', 'mgra based input fact table joined to all dimension tables'
GO




-- Create person trip report view
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[report].[person_trip]') AND type in ('V'))
DROP VIEW [report].[person_trip]
GO

CREATE VIEW [report].[person_trip] AS
	SELECT
		[person_trip].[scenario_id]
		,[person_trip].[person_trip_id]
		,[person_trip].[person_id]
		,[person].[age]
		,[person].[sex]
		,[person].[military_status]
		,[person].[employment_status]
		,[person].[student_status]
		,[person].[abm_person_type]
		,[person].[education]
		,[person].[grade]
		,[person].[weeks]
		,[person].[hours]
		,[person].[race]
		,[person].[hispanic]
		,[person].[version_person]
		,[person].[abm_activity_pattern]
		,[person].[freeparking_choice]
		,[person].[freeparking_reimbpct]
		,[person].[work_segment]
		,[person].[school_segment]
		,[person].[geography_work_location_id]
		,[geography_work_location].[work_location_mgra_13]
		,[geography_work_location].[work_location_mgra_13_shape]
		,[geography_work_location].[work_location_taz_13]
		,[geography_work_location].[work_location_taz_13_shape]
		,[geography_work_location].[work_location_luz_13]
		,[geography_work_location].[work_location_luz_13_shape]
		,[geography_work_location].[work_location_cicpa_2016]
		,[geography_work_location].[work_location_cicpa_2016_name]
		,[geography_work_location].[work_location_cicpa_2016_shape]
		,[geography_work_location].[work_location_cocpa_2016]
		,[geography_work_location].[work_location_cocpa_2016_name]
		,[geography_work_location].[work_location_cocpa_2016_shape]
		,[geography_work_location].[work_location_jurisdiction_2016]
		,[geography_work_location].[work_location_jurisdiction_2016_name]
		,[geography_work_location].[work_location_jurisdiction_2016_shape]
		,[geography_work_location].[work_location_region_2004]
		,[geography_work_location].[work_location_region_2004_name]
		,[geography_work_location].[work_location_region_2004_shape]
		,[geography_work_location].[work_location_external_zone]
		,[person].[geography_school_location_id]
		,[geography_school_location].[school_location_mgra_13]
		,[geography_school_location].[school_location_mgra_13_shape]
		,[geography_school_location].[school_location_taz_13]
		,[geography_school_location].[school_location_taz_13_shape]
		,[geography_school_location].[school_location_luz_13]
		,[geography_school_location].[school_location_luz_13_shape]
		,[geography_school_location].[school_location_cicpa_2016]
		,[geography_school_location].[school_location_cicpa_2016_name]
		,[geography_school_location].[school_location_cicpa_2016_shape]
		,[geography_school_location].[school_location_cocpa_2016]
		,[geography_school_location].[school_location_cocpa_2016_name]
		,[geography_school_location].[school_location_cocpa_2016_shape]
		,[geography_school_location].[school_location_jurisdiction_2016]
		,[geography_school_location].[school_location_jurisdiction_2016_name]
		,[geography_school_location].[school_location_jurisdiction_2016_shape]
		,[geography_school_location].[school_location_region_2004]
		,[geography_school_location].[school_location_region_2004_name]
		,[geography_school_location].[school_location_region_2004_shape]
		,[geography_school_location].[school_location_external_zone]
		,[person].[work_distance]
		,[person].[school_distance]
		,[person].[weight_person]
		,[person_trip].[household_id]
		,[household].[income]
		,[household].[income_category]
		,[household].[household_size]
		,[household].[bldgsz]
		,[household].[unittype]
		,[household].[autos]
		,[household].[transponder]
		,[household].[poverty]
		,[household].[geography_household_location_id]
		,[geography_household_location].[household_location_mgra_13]
		,[geography_household_location].[household_location_mgra_13_shape]
		,[geography_household_location].[household_location_taz_13]
		,[geography_household_location].[household_location_taz_13_shape]
		,[geography_household_location].[household_location_luz_13]
		,[geography_household_location].[household_location_luz_13_shape]
		,[geography_household_location].[household_location_cicpa_2016]
		,[geography_household_location].[household_location_cicpa_2016_name]
		,[geography_household_location].[household_location_cicpa_2016_shape]
		,[geography_household_location].[household_location_cocpa_2016]
		,[geography_household_location].[household_location_cocpa_2016_name]
		,[geography_household_location].[household_location_cocpa_2016_shape]
		,[geography_household_location].[household_location_jurisdiction_2016]
		,[geography_household_location].[household_location_jurisdiction_2016_name]
		,[geography_household_location].[household_location_jurisdiction_2016_shape]
		,[geography_household_location].[household_location_region_2004]
		,[geography_household_location].[household_location_region_2004_name]
		,[geography_household_location].[household_location_region_2004_shape]
		,[geography_household_location].[household_location_external_zone]
		,[household].[version_household]
		,[household].[weight_household]
		,[person_trip].[tour_id]
		,[tour].[model_tour_id]
		,[model_tour].[model_tour_description]
		,[tour].[abm_tour_id]
		,[tour].[time_tour_start_id]
		,[time_tour_start].[tour_start_abm_half_hour]
		,[time_tour_start].[tour_start_abm_half_hour_period_start]
		,[time_tour_start].[tour_start_abm_half_hour_period_end]
		,[time_tour_start].[tour_start_abm_5_tod]
		,[time_tour_start].[tour_start_abm_5_tod_period_start]
		,[time_tour_start].[tour_start_abm_5_tod_period_end]
		,[time_tour_start].[tour_start_day]
		,[time_tour_start].[tour_start_day_period_start]
		,[time_tour_start].[tour_start_day_period_end]
		,[tour].[time_tour_end_id]
		,[time_tour_end].[tour_end_abm_half_hour]
		,[time_tour_end].[tour_end_abm_half_hour_period_start]
		,[time_tour_end].[tour_end_abm_half_hour_period_end]
		,[time_tour_end].[tour_end_abm_5_tod]
		,[time_tour_end].[tour_end_abm_5_tod_period_start]
		,[time_tour_end].[tour_end_abm_5_tod_period_end]
		,[time_tour_end].[tour_end_day]
		,[time_tour_end].[tour_end_day_period_start]
		,[time_tour_end].[tour_end_day_period_end]
		,[tour].[geography_tour_origin_id]
		,[geography_tour_origin].[tour_origin_mgra_13]
		,[geography_tour_origin].[tour_origin_mgra_13_shape]
		,[geography_tour_origin].[tour_origin_taz_13]
		,[geography_tour_origin].[tour_origin_taz_13_shape]
		,[geography_tour_origin].[tour_origin_luz_13]
		,[geography_tour_origin].[tour_origin_luz_13_shape]
		,[geography_tour_origin].[tour_origin_cicpa_2016]
		,[geography_tour_origin].[tour_origin_cicpa_2016_name]
		,[geography_tour_origin].[tour_origin_cicpa_2016_shape]
		,[geography_tour_origin].[tour_origin_cocpa_2016]
		,[geography_tour_origin].[tour_origin_cocpa_2016_name]
		,[geography_tour_origin].[tour_origin_cocpa_2016_shape]
		,[geography_tour_origin].[tour_origin_jurisdiction_2016]
		,[geography_tour_origin].[tour_origin_jurisdiction_2016_name]
		,[geography_tour_origin].[tour_origin_jurisdiction_2016_shape]
		,[geography_tour_origin].[tour_origin_region_2004]
		,[geography_tour_origin].[tour_origin_region_2004_name]
		,[geography_tour_origin].[tour_origin_region_2004_shape]
		,[geography_tour_origin].[tour_origin_external_zone]
		,[tour].[geography_tour_destination_id]
		,[geography_tour_destination].[tour_destination_mgra_13]
		,[geography_tour_destination].[tour_destination_mgra_13_shape]
		,[geography_tour_destination].[tour_destination_taz_13]
		,[geography_tour_destination].[tour_destination_taz_13_shape]
		,[geography_tour_destination].[tour_destination_luz_13]
		,[geography_tour_destination].[tour_destination_luz_13_shape]
		,[geography_tour_destination].[tour_destination_cicpa_2016]
		,[geography_tour_destination].[tour_destination_cicpa_2016_name]
		,[geography_tour_destination].[tour_destination_cicpa_2016_shape]
		,[geography_tour_destination].[tour_destination_cocpa_2016]
		,[geography_tour_destination].[tour_destination_cocpa_2016_name]
		,[geography_tour_destination].[tour_destination_cocpa_2016_shape]
		,[geography_tour_destination].[tour_destination_jurisdiction_2016]
		,[geography_tour_destination].[tour_destination_jurisdiction_2016_name]
		,[geography_tour_destination].[tour_destination_jurisdiction_2016_shape]
		,[geography_tour_destination].[tour_destination_region_2004]
		,[geography_tour_destination].[tour_destination_region_2004_name]
		,[geography_tour_destination].[tour_destination_region_2004_shape]
		,[geography_tour_destination].[tour_destination_external_zone]
		,[tour].[mode_tour_id]
		,[mode_tour].[mode_tour_description]
		,[mode_tour].[mode_aggregate_tour_description]
		,[tour].[purpose_tour_id]
		,[purpose_tour].[purpose_tour_description]
		,[tour].[tour_category]
		,[tour].[tour_crossborder_point_of_entry]
		,[tour].[tour_crossborder_sentri]
		,[tour].[tour_visitor_auto]
		,[tour].[tour_visitor_income]
		,[tour].[weight_person_tour]
		,[tour].[weight_tour]
		,[person_trip].[model_trip_id]
		,[model_trip].[model_trip_description]
		,[person_trip].[mode_trip_id]
		,[mode_trip].[mode_trip_description]
		,[mode_trip].[mode_aggregate_trip_description]
		,[person_trip].[purpose_trip_origin_id]
		,[purpose_trip_origin].[purpose_trip_origin_description]
		,[person_trip].[purpose_trip_destination_id]
		,[purpose_trip_destination].[purpose_trip_destination_description]
		,[person_trip].[inbound_id]
		,[inbound].[inbound_description]
		,[person_trip].[time_trip_start_id]
		,[time_trip_start].[trip_start_abm_half_hour]
		,[time_trip_start].[trip_start_abm_half_hour_period_start]
		,[time_trip_start].[trip_start_abm_half_hour_period_end]
		,[time_trip_start].[trip_start_abm_5_tod]
		,[time_trip_start].[trip_start_abm_5_tod_period_start]
		,[time_trip_start].[trip_start_abm_5_tod_period_end]
		,[time_trip_start].[trip_start_day]
		,[time_trip_start].[trip_start_day_period_start]
		,[time_trip_start].[trip_start_day_period_end]
		,[person_trip].[time_trip_end_id]
		,[time_trip_end].[trip_end_abm_half_hour]
		,[time_trip_end].[trip_end_abm_half_hour_period_start]
		,[time_trip_end].[trip_end_abm_half_hour_period_end]
		,[time_trip_end].[trip_end_abm_5_tod]
		,[time_trip_end].[trip_end_abm_5_tod_period_start]
		,[time_trip_end].[trip_end_abm_5_tod_period_end]
		,[time_trip_end].[trip_end_day]
		,[time_trip_end].[trip_end_day_period_start]
		,[time_trip_end].[trip_end_day_period_end]
		,[person_trip].[geography_trip_origin_id]
		,[geography_trip_origin].[trip_origin_mgra_13]
		,[geography_trip_origin].[trip_origin_mgra_13_shape]
		,[geography_trip_origin].[trip_origin_taz_13]
		,[geography_trip_origin].[trip_origin_taz_13_shape]
		,[geography_trip_origin].[trip_origin_luz_13]
		,[geography_trip_origin].[trip_origin_luz_13_shape]
		,[geography_trip_origin].[trip_origin_cicpa_2016]
		,[geography_trip_origin].[trip_origin_cicpa_2016_name]
		,[geography_trip_origin].[trip_origin_cicpa_2016_shape]
		,[geography_trip_origin].[trip_origin_cocpa_2016]
		,[geography_trip_origin].[trip_origin_cocpa_2016_name]
		,[geography_trip_origin].[trip_origin_cocpa_2016_shape]
		,[geography_trip_origin].[trip_origin_jurisdiction_2016]
		,[geography_trip_origin].[trip_origin_jurisdiction_2016_name]
		,[geography_trip_origin].[trip_origin_jurisdiction_2016_shape]
		,[geography_trip_origin].[trip_origin_region_2004]
		,[geography_trip_origin].[trip_origin_region_2004_name]
		,[geography_trip_origin].[trip_origin_region_2004_shape]
		,[geography_trip_origin].[trip_origin_external_zone]
		,[person_trip].[geography_trip_destination_id]
		,[geography_trip_destination].[trip_destination_mgra_13]
		,[geography_trip_destination].[trip_destination_mgra_13_shape]
		,[geography_trip_destination].[trip_destination_taz_13]
		,[geography_trip_destination].[trip_destination_taz_13_shape]
		,[geography_trip_destination].[trip_destination_luz_13]
		,[geography_trip_destination].[trip_destination_luz_13_shape]
		,[geography_trip_destination].[trip_destination_cicpa_2016]
		,[geography_trip_destination].[trip_destination_cicpa_2016_name]
		,[geography_trip_destination].[trip_destination_cicpa_2016_shape]
		,[geography_trip_destination].[trip_destination_cocpa_2016]
		,[geography_trip_destination].[trip_destination_cocpa_2016_name]
		,[geography_trip_destination].[trip_destination_cocpa_2016_shape]
		,[geography_trip_destination].[trip_destination_jurisdiction_2016]
		,[geography_trip_destination].[trip_destination_jurisdiction_2016_name]
		,[geography_trip_destination].[trip_destination_jurisdiction_2016_shape]
		,[geography_trip_destination].[trip_destination_region_2004]
		,[geography_trip_destination].[trip_destination_region_2004_name]
		,[geography_trip_destination].[trip_destination_region_2004_shape]
		,[geography_trip_destination].[trip_destination_external_zone]
		,[person_trip].[geography_parking_destination_id]
		,[geography_parking_destination].[parking_destination_mgra_13]
		,[geography_parking_destination].[parking_destination_mgra_13_shape]
		,[geography_parking_destination].[parking_destination_taz_13]
		,[geography_parking_destination].[parking_destination_taz_13_shape]
		,[geography_parking_destination].[parking_destination_luz_13]
		,[geography_parking_destination].[parking_destination_luz_13_shape]
		,[geography_parking_destination].[parking_destination_cicpa_2016]
		,[geography_parking_destination].[parking_destination_cicpa_2016_name]
		,[geography_parking_destination].[parking_destination_cicpa_2016_shape]
		,[geography_parking_destination].[parking_destination_cocpa_2016]
		,[geography_parking_destination].[parking_destination_cocpa_2016_name]
		,[geography_parking_destination].[parking_destination_cocpa_2016_shape]
		,[geography_parking_destination].[parking_destination_jurisdiction_2016]
		,[geography_parking_destination].[parking_destination_jurisdiction_2016_name]
		,[geography_parking_destination].[parking_destination_jurisdiction_2016_shape]
		,[geography_parking_destination].[parking_destination_region_2004]
		,[geography_parking_destination].[parking_destination_region_2004_name]
		,[geography_parking_destination].[parking_destination_region_2004_shape]
		,[geography_parking_destination].[parking_destination_external_zone]
		,[person_trip].[transit_tap_boarding_id]
		,[transit_tap_boarding].[tap] AS [boarding_tap]
		,[transit_tap_boarding].[transit_tap_shape] AS [boarding_transit_tap_shape]
		,[person_trip].[transit_tap_alighting_id]
		,[transit_tap_alighting].[tap] AS [alighting_tap]
		,[transit_tap_alighting].[transit_tap_shape] AS [alighting_transit_tap_shape]
		,[person_trip].[person_escort_drive_id] -- leaving this as is for now
		,[person_trip].[escort_stop_type_origin_id]
		,[escort_stop_type_origin].[escort_stop_type_origin_description]
		,[person_trip].[person_escort_origin_id] -- leaving this as is for now
		,[person_trip].[escort_stop_type_destination_id]
		,[escort_stop_type_destination].[escort_stop_type_destination_description]
		,[person_trip].[person_escort_destination_id] -- leaving this as is for now
		,[person_trip].[mode_airport_arrival_id]
		,[mode_airport_arrival].[mode_airport_arrival_description]
		,[mode_airport_arrival].[mode_aggregate_airport_arrival_description]
		,[person_trip].[time_drive]
		,[person_trip].[dist_drive]
		,[person_trip].[toll_cost_drive]
		,[person_trip].[operating_cost_drive]
		,[person_trip].[time_walk]
		,[person_trip].[dist_walk]
		,[person_trip].[time_bike]
		,[person_trip].[dist_bike]
		,[person_trip].[time_transit_in_vehicle_local]
		,[person_trip].[time_transit_in_vehicle_express]
		,[person_trip].[time_transit_in_vehicle_rapid]
		,[person_trip].[time_transit_in_vehicle_light_rail]
		,[person_trip].[time_transit_in_vehicle_commuter_rail]
		,[person_trip].[time_transit_in_vehicle]
		,[person_trip].[dist_transit_in_vehicle]
		,[person_trip].[cost_transit]
		,[person_trip].[time_transit_auxiliary]
		,[person_trip].[time_transit_wait]
		,[person_trip].[transit_transfers]
		,[person_trip].[time_total]
		,[person_trip].[dist_total]
		,[person_trip].[cost_total]
		,[person_trip].[value_of_time]
		,[person_trip].[value_of_time_drive_bin_id]
		,[person_trip].[weight_person_trip]
		,[person_trip].[weight_trip]
	FROM
		[fact].[person_trip]
	INNER JOIN
		[dimension].[person]
	ON
		[person_trip].[scenario_id] = [person].[scenario_id]
		AND [person_trip].[person_id] = [person].[person_id]
	INNER JOIN
		[dimension].[geography_work_location]
	ON
		[person].[geography_work_location_id] = [geography_work_location].[geography_work_location_id]
	INNER JOIN
		[dimension].[geography_school_location]
	ON
		[person].[geography_school_location_id] = [geography_school_location].[geography_school_location_id]
	INNER JOIN
		[dimension].[household]
	ON
		[person_trip].[scenario_id] = [household].[scenario_id]
		AND [person_trip].[household_id] = [household].[household_id]
	INNER JOIN
		[dimension].[geography_household_location]
	ON
		[household].[geography_household_location_id] = [geography_household_location].[geography_household_location_id]
	INNER JOIN
		[dimension].[tour]
	ON
		[person_trip].[scenario_id] = [tour].[scenario_id]
		AND [person_trip].[tour_id] = [tour].[tour_id]
	INNER JOIN
		[dimension].[model_tour]
	ON
		[tour].[model_tour_id] = [model_tour].[model_tour_id]
	INNER JOIN
		[dimension].[time_tour_start]
	ON
		[tour].[time_tour_start_id] = [time_tour_start].[time_tour_start_id]
	INNER JOIN
		[dimension].[time_tour_end]
	ON
		[tour].[time_tour_end_id] = [time_tour_end].[time_tour_end_id]
	INNER JOIN
		[dimension].[geography_tour_origin]
	ON
		[tour].[geography_tour_origin_id] = [geography_tour_origin].[geography_tour_origin_id]
	INNER JOIN
		[dimension].[geography_tour_destination]
	ON
		[tour].[geography_tour_destination_id] = [geography_tour_destination].[geography_tour_destination_id]
	INNER JOIN
		[dimension].[mode_tour]
	ON
		[tour].[mode_tour_id] = [mode_tour].[mode_tour_id]
	INNER JOIN
		[dimension].[purpose_tour]
	ON
		[tour].[purpose_tour_id] = [purpose_tour].[purpose_tour_id]
	INNER JOIN
		[dimension].[model_trip]
	ON
		[person_trip].[model_trip_id] = [model_trip].[model_trip_id]
	INNER JOIN
		[dimension].[mode_trip]
	ON
		[person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
	INNER JOIN
		[dimension].[purpose_trip_origin]
	ON
		[person_trip].[purpose_trip_origin_id] = [purpose_trip_origin].[purpose_trip_origin_id]
	INNER JOIN
		[dimension].[purpose_trip_destination]
	ON
		[person_trip].[purpose_trip_destination_id] = [purpose_trip_destination].[purpose_trip_destination_id]
	INNER JOIN
		[dimension].[inbound]
	ON
		[person_trip].[inbound_id] = [inbound].[inbound_id]
	INNER JOIN
		[dimension].[time_trip_start]
	ON
		[person_trip].[time_trip_start_id] = [time_trip_start].[time_trip_start_id]
	INNER JOIN
		[dimension].[time_trip_end]
	ON
		[person_trip].[time_trip_end_id] = [time_trip_end].[time_trip_end_id]
	INNER JOIN
		[dimension].[geography_trip_origin]
	ON
		[person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
	INNER JOIN
		[dimension].[geography_trip_destination]
	ON
		[person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
	INNER JOIN
		[dimension].[geography_parking_destination]
	ON
		[person_trip].[geography_parking_destination_id] = [geography_parking_destination].[geography_parking_destination_id]
	INNER JOIN
		[dimension].[transit_tap] AS [transit_tap_boarding]
	ON
		[person_trip].[scenario_id] = [transit_tap_boarding].[scenario_id]
		AND [person_trip].[transit_tap_boarding_id] = [transit_tap_boarding].[transit_tap_id]
	INNER JOIN
		[dimension].[transit_tap] AS [transit_tap_alighting]
	ON
		[person_trip].[scenario_id] = [transit_tap_alighting].[scenario_id]
		AND [person_trip].[transit_tap_alighting_id] = [transit_tap_alighting].[transit_tap_id]
	INNER JOIN
		[dimension].[escort_stop_type_origin]
	ON
		[person_trip].[escort_stop_type_origin_id] = [escort_stop_type_origin].[escort_stop_type_origin_id]
	INNER JOIN
		[dimension].[escort_stop_type_destination]
	ON
		[person_trip].[escort_stop_type_destination_id] = [escort_stop_type_destination].[escort_stop_type_destination_id]
	INNER JOIN
		[dimension].[mode_airport_arrival]
	ON
		[person_trip].[mode_airport_arrival_id] = [mode_airport_arrival].[mode_airport_arrival_id]
GO

-- Add metadata for [report].[person_trip]
EXECUTE [db_meta].[add_xp] 'report.person_trip', 'SUBSYSTEM', 'report'
EXECUTE [db_meta].[add_xp] 'report.person_trip', 'MS_Description', 'person trip fact table joined to all dimension tables'
GO




-- Create transit aggflow report view
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[report].[transit_aggflow]') AND type in ('V'))
DROP VIEW [report].[transit_aggflow]
GO

CREATE VIEW [report].[transit_aggflow] AS
	SELECT
		[transit_aggflow].[scenario_id]
		,[transit_aggflow].[transit_aggflow_id]
		,[transit_aggflow].[transit_link_id]
		,[transit_link].[trcov_id]
		,[transit_link].[transit_link_shape]
		,[transit_aggflow].[ab]
		,[transit_aggflow].[time_id]
		,[time].[abm_half_hour]
		,[time].[abm_half_hour_period_start]
		,[time].[abm_half_hour_period_end]
		,[time].[abm_5_tod]
		,[time].[abm_5_tod_period_start]
		,[time].[abm_5_tod_period_end]
		,[time].[day]
		,[time].[day_period_start]
		,[time].[day_period_end]
		,[transit_aggflow].[mode_transit_id]
		,[mode_transit].[mode_transit_description]
		,[transit_aggflow].[mode_transit_access_id]
		,[mode_transit_access].[mode_transit_access_description]
		,[mode_transit_access].[mode_aggregate_transit_access_description]
		,[transit_aggflow].[transit_flow]
		,[transit_aggflow].[non_transit_flow]
		,[transit_aggflow].[total_flow]
		,[transit_aggflow].[access_walk_flow]
		,[transit_aggflow].[xfer_walk_flow]
		,[transit_aggflow].[egress_walk_flow]
	FROM
		[fact].[transit_aggflow]
	INNER JOIN
		[dimension].[transit_link]
	ON
		[transit_aggflow].[scenario_id] = [transit_link].[scenario_id]
		AND [transit_aggflow].[transit_link_id] = [transit_link].[transit_link_id]
	INNER JOIN
		[dimension].[time]
	ON
		[transit_aggflow].[time_id] = [time].[time_id]
	INNER JOIN
		[dimension].[mode_transit]
	ON
		[transit_aggflow].[mode_transit_id] = [mode_transit].[mode_transit_id]
	INNER JOIN
		[dimension].[mode_transit_access]
	ON
		[transit_aggflow].[mode_transit_access_id] = [mode_transit_access].[mode_transit_access_id]
GO

-- Add metadata for [report].[transit_aggflow]
EXECUTE [db_meta].[add_xp] 'report.transit_aggflow', 'SUBSYSTEM', 'report'
EXECUTE [db_meta].[add_xp] 'report.transit_aggflow', 'MS_Description', 'transit aggflow fact table joined to all dimension tables'
GO




-- Create transit flow report view
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[report].[transit_flow]') AND type in ('V'))
DROP VIEW [report].[transit_flow]
GO

CREATE VIEW [report].[transit_flow] AS
	SELECT
		[transit_flow].[scenario_id]
		,[transit_flow].[transit_flow_id]
		,[transit_flow].[transit_route_id]
		,[transit_route].[route_id]
		,[transit_route].[route_name]
		,[transit_route].[mode_transit_route_id]
		,[mode_transit_route].[mode_transit_route_description]
		,[mode_transit_route].[mode_aggregate_transit_route_description]
		,[transit_route].[am_headway]
		,[transit_route].[pm_headway]
		,[transit_route].[op_headway]
		,[transit_route].[nt_headway]
		,[transit_route].[nt_hour]
		,[transit_route].[config]
		,[transit_route].[fare]
		,[transit_route].[transit_route_shape]
		,[transit_flow].[transit_stop_from_id]
		,[transit_stop_from].[transit_link_id] AS [transit_stop_from_transit_link_id]
		,[transit_stop_from_transit_link].[trcov_id] AS [transit_stop_from_trcov_id]
		,[transit_stop_from_transit_link].[transit_link_shape] AS [transit_stop_from_transit_link_shape]
		,[transit_stop_from].[stop_id] AS [transit_stop_from_stop_id]
		,[transit_stop_from].[mp] AS [transit_stop_from_mp]
		,[transit_stop_from].[near_node] AS [transit_stop_from_near_node]
		,[transit_stop_from].[fare_zone] AS [transit_stop_from_fare_zone]
		,[transit_stop_from].[stop_name] AS [transit_stop_from_stop_name]
		,[transit_stop_from].[transit_stop_shape] AS [transit_stop_from_transit_stop_shape]
		,[transit_flow].[transit_stop_to_id]
		,[transit_stop_to].[transit_link_id] AS [transit_stop_to_transit_link_id]
		,[transit_stop_to_transit_link].[trcov_id] AS [transit_stop_to_trcov_id]
		,[transit_stop_to_transit_link].[transit_link_shape] AS [transit_stop_to_transit_link_shape]
		,[transit_stop_to].[stop_id] AS [transit_stop_to_stop_id]
		,[transit_stop_to].[mp] AS [transit_stop_to_mp]
		,[transit_stop_to].[near_node] AS [transit_stop_to_near_node]
		,[transit_stop_to].[fare_zone] AS [transit_stop_to_fare_zone]
		,[transit_stop_to].[stop_name] AS [transit_stop_to_stop_name]
		,[transit_stop_to].[transit_stop_shape] AS [transit_stop_to_transit_stop_shape]
		,[transit_flow].[time_id]
		,[time].[abm_half_hour]
		,[time].[abm_half_hour_period_start]
		,[time].[abm_half_hour_period_end]
		,[time].[abm_5_tod]
		,[time].[abm_5_tod_period_start]
		,[time].[abm_5_tod_period_end]
		,[time].[day]
		,[time].[day_period_start]
		,[time].[day_period_end]
		,[transit_flow].[mode_transit_id]
		,[mode_transit].[mode_transit_description]
		,[mode_transit].[mode_aggregate_transit_description]
		,[transit_flow].[mode_transit_access_id]
		,[mode_transit_access].[mode_transit_access_description]
		,[mode_transit_access].[mode_aggregate_transit_access_description]
		,[transit_flow].[from_mp]
		,[transit_flow].[to_mp]
		,[transit_flow].[baseivtt]
		,[transit_flow].[cost]
		,[transit_flow].[transit_flow]
	FROM
		[fact].[transit_flow]
	INNER JOIN
		[dimension].[transit_route]
	ON
		[transit_flow].[scenario_id] = [transit_route].[scenario_id]
		AND [transit_flow].[transit_route_id] = [transit_route].[transit_route_id]
	INNER JOIN
		[dimension].[mode_transit_route]
	ON
		[transit_route].[mode_transit_route_id] = [mode_transit_route].[mode_transit_route_id]
	INNER JOIN
		[dimension].[transit_stop] AS [transit_stop_from] -- no role playing views for scenario specific dimensions
	ON
		[transit_flow].[scenario_id] = [transit_stop_from].[scenario_id]
		AND [transit_flow].[transit_stop_from_id] = [transit_stop_from].[transit_stop_id]
	INNER JOIN
		[dimension].[transit_link] AS [transit_stop_from_transit_link] -- no role playing views for scenario specific dimensions
	ON
		[transit_stop_from].[scenario_id] = [transit_stop_from_transit_link].[scenario_id]
		AND [transit_stop_from].[transit_link_id] = [transit_stop_from_transit_link].[transit_link_id]
	INNER JOIN
		[dimension].[transit_stop] AS [transit_stop_to] -- no role playing views for scenario specific dimensions
	ON
		[transit_flow].[scenario_id] = [transit_stop_to].[scenario_id]
		AND [transit_flow].[transit_stop_to_id] = [transit_stop_to].[transit_stop_id]
	INNER JOIN
		[dimension].[transit_link] AS [transit_stop_to_transit_link] -- no role playing views for scenario specific dimensions
	ON
		[transit_stop_from].[scenario_id] = [transit_stop_to_transit_link].[scenario_id]
		AND [transit_stop_from].[transit_link_id] = [transit_stop_to_transit_link].[transit_link_id]
	INNER JOIN
		[dimension].[time]
	ON
		[transit_flow].[time_id] = [time].[time_id]
	INNER JOIN
		[dimension].[mode_transit]
	ON
		[transit_flow].[mode_transit_id] = [mode_transit].[mode_transit_id]
	INNER JOIN
		[dimension].[mode_transit_access]
	ON
		[transit_flow].[mode_transit_access_id] = [mode_transit_access].[mode_transit_access_id]
GO

-- Add metadata for [report].[transit_flow]
EXECUTE [db_meta].[add_xp] 'report.transit_flow', 'SUBSYSTEM', 'report'
EXECUTE [db_meta].[add_xp] 'report.transit_flow', 'MS_Description', 'transit flow fact table joined to all dimension tables'
GO




-- Create transit on off report view
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[report].[transit_onoff]') AND type in ('V'))
DROP VIEW [report].[transit_onoff]
GO

CREATE VIEW [report].[transit_onoff] AS
	SELECT
		[transit_onoff].[scenario_id]
		,[transit_onoff].[transit_onoff_id]
		,[transit_onoff].[transit_route_id]
		,[transit_route].[route_name]
		,[transit_route].[mode_transit_route_id]
		,[mode_transit_route].[mode_transit_route_description]
		,[mode_transit_route].[mode_aggregate_transit_route_description]
		,[transit_route].[am_headway]
		,[transit_route].[pm_headway]
		,[transit_route].[op_headway]
		,[transit_route].[nt_headway]
		,[transit_route].[nt_hour]
		,[transit_route].[config]
		,[transit_route].[fare]
		,[transit_route].[transit_route_shape]
		,[transit_onoff].[transit_stop_id]
		,[transit_stop].[transit_link_id]
		,[transit_link].[trcov_id]
		,[transit_link].[transit_link_shape]
		,[transit_onoff].[time_id]
		,[time].[abm_half_hour]
		,[time].[abm_half_hour_period_start]
		,[time].[abm_half_hour_period_end]
		,[time].[abm_5_tod]
		,[time].[abm_5_tod_period_start]
		,[time].[abm_5_tod_period_end]
		,[time].[day]
		,[time].[day_period_start]
		,[time].[day_period_end]
		,[transit_onoff].[mode_transit_id]
		,[mode_transit].[mode_transit_description]
		,[transit_onoff].[mode_transit_access_id]
		,[mode_transit_access].[mode_transit_access_description]
		,[mode_transit_access].[mode_aggregate_transit_access_description]
		,[transit_onoff].[boardings]
		,[transit_onoff].[alightings]
		,[transit_onoff].[walk_access_on]
		,[transit_onoff].[direct_transfer_on]
		,[transit_onoff].[direct_transfer_off]
		,[transit_onoff].[egress_off]
	FROM
		[fact].[transit_onoff]
	INNER JOIN
		[dimension].[transit_route]
	ON
		[transit_onoff].[scenario_id] = [transit_route].[scenario_id]
		AND [transit_onoff].[transit_route_id] = [transit_route].[transit_route_id]
	INNER JOIN
		[dimension].[mode_transit_route]
	ON
		[transit_route].[mode_transit_route_id] = [mode_transit_route].[mode_transit_route_id]
	INNER JOIN
		[dimension].[transit_stop]
	ON
		[transit_onoff].[scenario_id] = [transit_stop].[scenario_id]
		AND [transit_onoff].[transit_stop_id] = [transit_stop].[transit_stop_id]
	INNER JOIN
		[dimension].[transit_link]
	ON
		[transit_stop].[scenario_id] = [transit_link].[scenario_id]
		AND [transit_stop].[transit_link_id] = [transit_link].[transit_link_id]
	INNER JOIN
		[dimension].[time]
	ON
		[transit_onoff].[time_id] = [time].[time_id]
	INNER JOIN
		[dimension].[mode_transit]
	ON
		[transit_onoff].[mode_transit_id] = [mode_transit].[mode_transit_id]
	INNER JOIN
		[dimension].[mode_transit_access]
	ON
		[transit_onoff].[mode_transit_access_id] = [mode_transit_access].[mode_transit_access_id]
GO

-- Add metadata for [report].[transit_onoff]
EXECUTE [db_meta].[add_xp] 'report.transit_onoff', 'SUBSYSTEM', 'report'
EXECUTE [db_meta].[add_xp] 'report.transit_onoff', 'MS_Description', 'transit on off fact table joined to all dimension tables'
GO




-- Create transit pnr report view
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[report].[transit_pnr]') AND type in ('V'))
DROP VIEW [report].[transit_pnr]
GO

CREATE VIEW [report].[transit_pnr] AS
	SELECT
		[transit_pnr].[scenario_id]
		,[transit_pnr].[transit_pnr_id]
		,[transit_pnr].[transit_tap_id]
		,[transit_tap].[tap]
		,[transit_tap].[transit_tap_shape]
		,[transit_pnr].[lot_id]
		,[transit_pnr].[geography_id]
		,[geography].[mgra_13]
		,[geography].[mgra_13_shape]
		,[geography].[taz_13]
		,[geography].[taz_13_shape]
		,[geography].[luz_13]
		,[geography].[luz_13_shape]
		,[geography].[cicpa_2016]
		,[geography].[cicpa_2016_name]
		,[geography].[cicpa_2016_shape]
		,[geography].[cocpa_2016]
		,[geography].[cocpa_2016_name]
		,[geography].[cocpa_2016_shape]
		,[geography].[jurisdiction_2016]
		,[geography].[jurisdiction_2016_name]
		,[geography].[jurisdiction_2016_shape]
		,[geography].[region_2004]
		,[geography].[region_2004_name]
		,[geography].[region_2004_shape]
		,[geography].[external_zone]
		,[transit_pnr].[time_id]
		,[time].[abm_half_hour]
		,[time].[abm_half_hour_period_start]
		,[time].[abm_half_hour_period_end]
		,[time].[abm_5_tod]
		,[time].[abm_5_tod_period_start]
		,[time].[abm_5_tod_period_end]
		,[time].[day]
		,[time].[day_period_start]
		,[time].[day_period_end]
		,[transit_pnr].[parking_type]
		,[transit_pnr].[capacity]
		,[transit_pnr].[distance]
		,[transit_pnr].[vehicles]
	FROM 
		[fact].[transit_pnr]
	INNER JOIN
		[dimension].[transit_tap]
	ON
		[transit_pnr].[scenario_id] = [transit_tap].[scenario_id]
		AND [transit_pnr].[transit_tap_id] = [transit_tap].[transit_tap_id]
	INNER JOIN
		[dimension].[geography]
	ON
		[transit_pnr].[geography_id] = [geography].[geography_id]
	INNER JOIN
		[dimension].[time]
	ON
		[transit_pnr].[time_id] = [time].[time_id]
GO

-- Add metadata for [report].[transit_pnr]
EXECUTE [db_meta].[add_xp] 'report.transit_pnr', 'SUBSYSTEM', 'report'
EXECUTE [db_meta].[add_xp] 'report.transit_pnr', 'MS_Description', 'transit pnr fact table joined to all dimension tables'
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[report].[vi_hwyload]') AND type in ('V'))
DROP VIEW [report].[vi_hwyload]
GO

CREATE VIEW [report].[vi_hwyload] AS
/*	Author: Gregor Schroeder
	Date: 7/18/2018
	Description: View to create loaded highway coverage network.
		This can be used as either a query layer or to output a shapefile.
		Recreates Clint Daniels created function [abm_13_2_3].[fn_hwy_vol_by_mode_and_tod]
		used in process_shapefiles.py
*/
SELECT
	[hwy_link].[scenario_id] AS [scen_id] -- truncated due to .shp field name limitations
	,[scenario].[year] AS [scen_year]
	,RTRIM([scenario].[abm_version]) AS [abm_ver]
	,[hwy_link].[hwy_link_id] AS [hwy_link]
	,[hwy_link].[hwycov_id]
	,[hwy_link].[shape].MakeValid() AS [shape]
	,CASE	WHEN LEN([hwy_link].[nm]) > 2
			THEN SUBSTRING(RTRIM([hwy_link].[nm]), 2, LEN([hwy_link].[nm]) - 2)
			ELSE RTRIM([hwy_link].[nm]) END AS [link_name]
	,[hwy_link].[length_mile] AS [len_mile]
	,CONVERT(smallint, [hwy_link].[cojur]) AS [count_jur] -- .shp cannot handle tinyint data type
	,[hwy_link].[costat] AS [count_stat]
	,CONVERT(smallint, [hwy_link].[coloc]) AS [count_loc] -- .shp cannot handle tinyint data type
	,CONVERT(smallint, [hwy_link].[ifc]) AS [ifc] -- .shp cannot handle tinyint data type
	,CASE	WHEN [hwy_link].[ifc] = 1
			THEN 'Freeway'
			WHEN [hwy_link].[ifc] = 2
			THEN 'Prime Arterial'
			WHEN [hwy_link].[ifc] = 3
			THEN 'Major Arterial'
			WHEN [hwy_link].[ifc] = 4
			THEN 'Collector'
			WHEN [hwy_link].[ifc] = 5
			THEN 'Local Collector'
			WHEN [hwy_link].[ifc] = 6
			THEN 'Rural Collector'
			WHEN [hwy_link].[ifc] = 7
			THEN 'Local (non-circulation element) Road'
			WHEN [hwy_link].[ifc] = 8
			THEN 'Freeway Connector Ramp'
			WHEN [hwy_link].[ifc] = 9
			THEN 'Local Ramp'
			WHEN [hwy_link].[ifc] = 10
			THEN 'Zone Connector'
			ELSE NULL END AS [ifc_desc]
	,CONVERT(smallint, [hwy_link].[ihov]) AS [ihov] -- .shp cannot handle tinyint data type
	,CONVERT(smallint, [hwy_link].[itruck]) AS [itruck] -- .shp cannot handle tinyint data type
	,CONVERT(smallint, [hwy_link].[ispd]) AS [post_speed] -- .shp cannot handle tinyint data type
	,CONVERT(smallint, [hwy_link].[iway]) AS [iway] -- .shp cannot handle tinyint data type
	,CONVERT(smallint, [hwy_link].[imed]) AS [imed] -- .shp cannot handle tinyint data type
	,[hwy_link_ab_wide].[ab_from_node] AS [from_node]
	,RTRIM([hwy_link_ab_wide].[ab_from_nm]) AS [from_nm]
	,[hwy_link_ab_wide].[ab_to_node] AS [to_node]
	,RTRIM([hwy_link_ab_wide].[ab_to_nm]) AS [to_nm]
	,[hwy_flow_wide].[total_flow]
	,[hwy_flow_wide].[ab_tot_flow] AS [abTotFlow]
	,[hwy_flow_wide].[ba_tot_flow] AS [baTotFlow]
	,[hwy_flow_wide].[ab_tot_flow] * [hwy_link].[length_mile] AS [ab_vmt]
	,[hwy_flow_wide].[ba_tot_flow] * [hwy_link].[length_mile] AS [ba_vmt]
	,[hwy_flow_wide].[total_flow] * [hwy_link].[length_mile] AS [vmt]
	,(([ab_ea_min] * [ab_ea_flow]) + ([ab_am_min] * [ab_am_flow]) +
		([ab_md_min] * [ab_md_flow]) + ([ab_pm_min] * [ab_pm_flow]) +
		([ab_ev_min] * [ab_ev_flow])) / 60 AS [ab_vht]
	,(([ba_ea_min] * [ba_ea_flow]) + ([ba_am_min] * [ba_am_flow]) +
		([ba_md_min] * [ba_md_flow]) + ([ba_pm_min] * [ba_pm_flow]) +
		([ba_ev_min] * [ba_ev_flow])) / 60 AS [ba_vht]
	,(([ab_ea_min] * [ab_ea_flow]) + ([ab_am_min] * [ab_am_flow]) +
		([ab_md_min] * [ab_md_flow]) + ([ab_pm_min] * [ab_pm_flow]) +
		([ab_ev_min] * [ab_ev_flow]) + ([ba_ea_min] * [ba_ea_flow]) +
		([ba_am_min] * [ba_am_flow]) + ([ba_md_min] * [ba_md_flow]) +
		([ba_pm_min] * [ba_pm_flow]) + ([ba_ev_min] * [ba_ev_flow])) / 60 AS [vht]
	,[hwy_flow_wide].[ab_ea_flow]
	,[hwy_flow_wide].[ba_ea_flow]
	,[hwy_flow_wide].[ab_am_flow]
	,[hwy_flow_wide].[ba_am_flow]
	,[hwy_flow_wide].[ab_md_flow]
	,[hwy_flow_wide].[ba_md_flow]
	,[hwy_flow_wide].[ab_pm_flow]
	,[hwy_flow_wide].[ba_pm_flow]
	,[hwy_flow_wide].[ab_ev_flow]
	,[hwy_flow_wide].[ba_ev_flow]
	,[hwy_flow_mode_wide].[ab_auto_flow] AS [abAutoFlow]
	,[hwy_flow_mode_wide].[ba_auto_flow] AS [baAutoFlow]
	,[hwy_flow_mode_wide].[ab_sov_flow] AS [abSovFlow]
	,[hwy_flow_mode_wide].[ba_sov_flow] AS [baSovFlow]
	,[hwy_flow_mode_wide].[ab_hov2_flow] AS [abHov2Flow]
	,[hwy_flow_mode_wide].[ba_hov2_flow] AS [baHov2Flow]
	,[hwy_flow_mode_wide].[ab_hov3_flow] AS [abHov3Flow]
	,[hwy_flow_mode_wide].[ba_hov3_flow] AS [baHov3Flow]
	,[hwy_flow_mode_wide].[ab_truck_flow] AS [abTrucFlow]
	,[hwy_flow_mode_wide].[ba_truck_flow] AS [baTrucFlow]
	,[hwy_flow_mode_wide].[ab_bus_flow] AS [abBusFlow]
	,[hwy_flow_mode_wide].[ba_bus_flow] AS [baBusFlow]
	,[hwy_flow_wide].[ab_ea_mph]
	,[hwy_flow_wide].[ba_ea_mph]
	,[hwy_flow_wide].[ab_am_mph]
	,[hwy_flow_wide].[ba_am_mph]
	,[hwy_flow_wide].[ab_md_mph]
	,[hwy_flow_wide].[ba_md_mph]
	,[hwy_flow_wide].[ab_pm_mph]
	,[hwy_flow_wide].[ba_pm_mph]
	,[hwy_flow_wide].[ab_ev_mph]
	,[hwy_flow_wide].[ba_ev_mph]
	,[hwy_flow_wide].[ab_ea_min]
	,[hwy_flow_wide].[ba_ea_min]
	,[hwy_flow_wide].[ab_am_min]
	,[hwy_flow_wide].[ba_am_min]
	,[hwy_flow_wide].[ab_md_min]
	,[hwy_flow_wide].[ba_md_min]
	,[hwy_flow_wide].[ab_pm_min]
	,[hwy_flow_wide].[ba_pm_min]
	,[hwy_flow_wide].[ab_ev_min]
	,[hwy_flow_wide].[ba_ev_min]
	,[hwy_link_ab_tod_wide].[ab_ea_lane]
	,[hwy_link_ab_tod_wide].[ba_ea_lane]
	,[hwy_link_ab_tod_wide].[ab_am_lane]
	,[hwy_link_ab_tod_wide].[ba_am_lane]
	,[hwy_link_ab_tod_wide].[ab_md_lane]
	,[hwy_link_ab_tod_wide].[ba_md_lane]
	,[hwy_link_ab_tod_wide].[ab_pm_lane]
	,[hwy_link_ab_tod_wide].[ba_pm_lane]
	,[hwy_link_ab_tod_wide].[ab_ev_lane]
	,[hwy_link_ab_tod_wide].[ba_ev_lane]
	,[hwy_flow_wide].[ab_ea_voc]
	,[hwy_flow_wide].[ba_ea_voc]
	,[hwy_flow_wide].[ab_am_voc]
	,[hwy_flow_wide].[ba_am_voc]
	,[hwy_flow_wide].[ab_md_voc]
	,[hwy_flow_wide].[ba_md_voc]
	,[hwy_flow_wide].[ab_pm_voc]
	,[hwy_flow_wide].[ba_pm_voc]
	,[hwy_flow_wide].[ab_ev_voc]
	,[hwy_flow_wide].[ba_ev_voc]
FROM
	[dimension].[hwy_link]
INNER JOIN
	[dimension].[scenario]
ON
	[hwy_link].[scenario_id] = [scenario].[scenario_id]
INNER JOIN ( -- get wide version of [dimension].[hwy_link_ab]
	SELECT
		[scenario_id]
		,[hwy_link_id]
		,[from_node] AS [ab_from_node]
		,[from_nm] AS [ab_from_nm]
		,[to_node] AS [ab_to_node]
		,[to_nm] AS [ab_to_nm]
	FROM
		[dimension].[hwy_link_ab]
	WHERE
		[ab] = 1
) AS [hwy_link_ab_wide]
ON
	[hwy_link].[scenario_id] = [hwy_link_ab_wide].[scenario_id]
	AND [hwy_link].[hwy_link_id] = [hwy_link_ab_wide].[hwy_link_id]
INNER JOIN ( -- get wide version of [fact].[hwy_flow]
	SELECT
		[hwy_flow].[scenario_id]
		,[hwy_flow].[hwy_link_id]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '1'
					THEN [hwy_flow].[flow]
					ElSE 0 END) AS [ab_ea_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '1'
					THEN [hwy_flow].[flow]
					ElSE 0 END) AS [ba_ea_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '2'
					THEN [hwy_flow].[flow]
					ElSE 0 END) AS [ab_am_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '2'
					THEN [hwy_flow].[flow]
					ElSE 0 END) AS [ba_am_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '3'
					THEN [hwy_flow].[flow]
					ElSE 0 END) AS [ab_md_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '3'
					THEN [hwy_flow].[flow]
					ElSE 0 END) AS [ba_md_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '4'
					THEN [hwy_flow].[flow]
					ElSE 0 END) AS [ab_pm_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '4'
					THEN [hwy_flow].[flow]
					ElSE 0 END) AS [ba_pm_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '5'
					THEN [hwy_flow].[flow]
					ElSE 0 END) AS [ab_ev_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '5'
					THEN [hwy_flow].[flow]
					ElSE 0 END) AS [ba_ev_flow]
		,SUM([hwy_flow].[flow]) AS [total_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					THEN [hwy_flow].[flow]
					ElSE 0 END) AS [ab_tot_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					THEN [hwy_flow].[flow]
					ElSE 0 END) AS [ba_tot_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '1'
					THEN [hwy_flow].[speed]
					ElSE 0 END) AS [ab_ea_mph]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '1'
					THEN [hwy_flow].[speed]
					ElSE 0 END) AS [ba_ea_mph]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '2'
					THEN [hwy_flow].[speed]
					ElSE 0 END) AS [ab_am_mph]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '2'
					THEN [hwy_flow].[speed]
					ElSE 0 END) AS [ba_am_mph]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '3'
					THEN [hwy_flow].[speed]
					ElSE 0 END) AS [ab_md_mph]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '3'
					THEN [hwy_flow].[speed]
					ElSE 0 END) AS [ba_md_mph]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '4'
					THEN [hwy_flow].[speed]
					ElSE 0 END) AS [ab_pm_mph]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '4'
					THEN [hwy_flow].[speed]
					ElSE 0 END) AS [ba_pm_mph]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '5'
					THEN [hwy_flow].[speed]
					ElSE 0 END) AS [ab_ev_mph]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '5'
					THEN [hwy_flow].[speed]
					ElSE 0 END) AS [ba_ev_mph]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '1'
					THEN [hwy_flow].[time]
					ElSE 0 END) AS [ab_ea_min]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '1'
					THEN [hwy_flow].[time]
					ElSE 0 END) AS [ba_ea_min]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '2'
					THEN [hwy_flow].[time]
					ElSE 0 END) AS [ab_am_min]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '2'
					THEN [hwy_flow].[time]
					ElSE 0 END) AS [ba_am_min]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '3'
					THEN [hwy_flow].[time]
					ElSE 0 END) AS [ab_md_min]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '3'
					THEN [hwy_flow].[time]
					ElSE 0 END) AS [ba_md_min]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '4'
					THEN [hwy_flow].[time]
					ElSE 0 END) AS [ab_pm_min]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '4'
					THEN [hwy_flow].[time]
					ElSE 0 END) AS [ba_pm_min]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '5'
					THEN [hwy_flow].[time]
					ElSE 0 END) AS [ab_ev_min]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '5'
					THEN [hwy_flow].[time]
					ElSE 0 END) AS [ba_ev_min]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '1'
					THEN [hwy_flow].[voc]
					ElSE 0 END) AS [ab_ea_voc]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '1'
					THEN [hwy_flow].[voc]
					ElSE 0 END) AS [ba_ea_voc]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '2'
					THEN [hwy_flow].[voc]
					ElSE 0 END) AS [ab_am_voc]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '2'
					THEN [hwy_flow].[voc]
					ElSE 0 END) AS [ba_am_voc]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '3'
					THEN [hwy_flow].[voc]
					ElSE 0 END) AS [ab_md_voc]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '3'
					THEN [hwy_flow].[voc]
					ElSE 0 END) AS [ba_md_voc]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '4'
					THEN [hwy_flow].[voc]
					ElSE 0 END) AS [ab_pm_voc]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '4'
					THEN [hwy_flow].[voc]
					ElSE 0 END) AS [ba_pm_voc]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [time].[abm_5_tod] = '5'
					THEN [hwy_flow].[voc]
					ElSE 0 END) AS [ab_ev_voc]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [time].[abm_5_tod] = '5'
					THEN [hwy_flow].[voc]
					ElSE 0 END) AS [ba_ev_voc]
	FROM
		[fact].[hwy_flow]
	INNER JOIN
		[dimension].[hwy_link_ab]
	ON
		[hwy_flow].[scenario_id] = [hwy_link_ab].[scenario_id]
		AND [hwy_flow].[hwy_link_ab_id] = [hwy_link_ab].[hwy_link_ab_id]
	INNER JOIN
		[dimension].[time]
	ON
		[hwy_flow].[time_id] = [time].[time_id]
	GROUP BY
		[hwy_flow].[scenario_id]
		,[hwy_flow].[hwy_link_id]
) AS [hwy_flow_wide]
ON
	[hwy_link].[scenario_id] = [hwy_flow_wide].[scenario_id]
	AND [hwy_link].[hwy_link_id] = [hwy_flow_wide].[hwy_link_id]
INNER JOIN ( -- get wide version of [fact].[hwy_flow_mode]
	SELECT
		[hwy_flow_mode].[scenario_id]
		,[hwy_flow_mode].[hwy_link_id]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [mode].[mode_description] IN ('Drive Alone Non-Toll',
														'Drive Alone Toll Eligible',
														'Shared Ride 2 Non-Toll',
														'Shared Ride 2 Toll Eligible',
														'Shared Ride 3 Non-Toll',
														'Shared Ride 3 Toll Eligible')
					THEN [hwy_flow_mode].[flow]
					END) AS [ab_auto_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [mode].[mode_description] IN ('Drive Alone Non-Toll',
														'Drive Alone Toll Eligible',
														'Shared Ride 2 Non-Toll',
														'Shared Ride 2 Toll Eligible',
														'Shared Ride 3 Non-Toll',
														'Shared Ride 3 Toll Eligible')
					THEN [hwy_flow_mode].[flow]
					END) AS [ba_auto_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [mode].[mode_description] IN ('Drive Alone Non-Toll',
														'Drive Alone Toll Eligible')
					THEN [hwy_flow_mode].[flow]
					END) AS [ab_sov_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [mode].[mode_description] IN ('Drive Alone Non-Toll',
														'Drive Alone Toll Eligible')
					THEN [hwy_flow_mode].[flow]
					END) AS [ba_sov_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [mode].[mode_description] IN ('Shared Ride 2 Non-Toll',
														'Shared Ride 2 Toll Eligible')
					THEN [hwy_flow_mode].[flow]
					END) AS [ab_hov2_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [mode].[mode_description] IN ('Shared Ride 2 Non-Toll',
														'Shared Ride 2 Toll Eligible')
					THEN [hwy_flow_mode].[flow]
					END) AS [ba_hov2_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [mode].[mode_description] IN ('Shared Ride 3 Non-Toll',
														'Shared Ride 3 Toll Eligible')
					THEN [hwy_flow_mode].[flow]
					END) AS [ab_hov3_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [mode].[mode_description] IN ('Shared Ride 3 Non-Toll',
														'Shared Ride 3 Toll Eligible')
					THEN [hwy_flow_mode].[flow]
					END) AS [ba_hov3_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [mode].[mode_description] IN ('Heavy Heavy Duty Truck (Non-Toll)',
														'Heavy Heavy Duty Truck (Toll)',
														'Highway Network Preload - Bus',
														'Light Heavy Duty Truck (Non-Toll)',
														'Light Heavy Duty Truck (Toll)',
														'Medium Heavy Duty Truck (Non-Toll)',
														'Medium Heavy Duty Truck (Toll)')
					THEN [hwy_flow_mode].[flow]
					END) AS [ab_truck_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [mode].[mode_description] IN ('Heavy Heavy Duty Truck (Non-Toll)',
														'Heavy Heavy Duty Truck (Toll)',
														'Highway Network Preload - Bus',
														'Light Heavy Duty Truck (Non-Toll)',
														'Light Heavy Duty Truck (Toll)',
														'Medium Heavy Duty Truck (Non-Toll)',
														'Medium Heavy Duty Truck (Toll)')
					THEN [hwy_flow_mode].[flow]
					END) AS [ba_truck_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 1
					AND [mode].[mode_description] = 'Highway Network Preload - Bus'
					THEN [hwy_flow_mode].[flow]
					END) AS [ab_bus_flow]
		,SUM(CASE	WHEN [hwy_link_ab].[ab] = 0
					AND [mode].[mode_description] = 'Highway Network Preload - Bus'
					THEN [hwy_flow_mode].[flow]
					END) AS [ba_bus_flow]
	FROM
		[fact].[hwy_flow_mode]
	INNER JOIN
		[dimension].[hwy_link_ab]
	ON
		[hwy_flow_mode].[scenario_id] = [hwy_link_ab].[scenario_id]
		AND [hwy_flow_mode].[hwy_link_ab_id] = [hwy_link_ab].[hwy_link_ab_id]
	INNER JOIN
		[dimension].[mode]
	ON
		[hwy_flow_mode].[mode_id] = [mode].[mode_id]
	GROUP BY
		[hwy_flow_mode].[scenario_id]
		,[hwy_flow_mode].[hwy_link_id]
) AS [hwy_flow_mode_wide]
ON
	[hwy_link].[scenario_id] = [hwy_flow_mode_wide].[scenario_id]
	AND [hwy_link].[hwy_link_id] = [hwy_flow_mode_wide].[hwy_link_id]
INNER JOIN ( -- get wide version of [dimension].[hwy_link_ab_tod]
	SELECT
		[hwy_link_ab_tod].[scenario_id]
		,[hwy_link_ab_tod].[hwy_link_id]
		,SUM(CASE	WHEN [hwy_link_ab_tod].[ab] = 1
					AND [time].[abm_5_tod] = '1'
					THEN [hwy_link_ab_tod].[ln]
					ElSE 0 END) AS [ab_ea_lane]
		,SUM(CASE	WHEN [hwy_link_ab_tod].[ab] = 0
					AND [time].[abm_5_tod] = '1'
					THEN [hwy_link_ab_tod].[ln]
					ElSE 0 END) AS [ba_ea_lane]
		,SUM(CASE	WHEN [hwy_link_ab_tod].[ab] = 1
					AND [time].[abm_5_tod] = '2'
					THEN [hwy_link_ab_tod].[ln]
					ElSE 0 END) AS [ab_am_lane]
		,SUM(CASE	WHEN [hwy_link_ab_tod].[ab] = 0
					AND [time].[abm_5_tod] = '2'
					THEN [hwy_link_ab_tod].[ln]
					ElSE 0 END) AS [ba_am_lane]
		,SUM(CASE	WHEN [hwy_link_ab_tod].[ab] = 1
					AND [time].[abm_5_tod] = '3'
					THEN [hwy_link_ab_tod].[ln]
					ElSE 0 END) AS [ab_md_lane]
		,SUM(CASE	WHEN [hwy_link_ab_tod].[ab] = 0
					AND [time].[abm_5_tod] = '3'
					THEN [hwy_link_ab_tod].[ln]
					ElSE 0 END) AS [ba_md_lane]
		,SUM(CASE	WHEN [hwy_link_ab_tod].[ab] = 1
					AND [time].[abm_5_tod] = '4'
					THEN [hwy_link_ab_tod].[ln]
					ElSE 0 END) AS [ab_pm_lane]
		,SUM(CASE	WHEN [hwy_link_ab_tod].[ab] = 0
					AND [time].[abm_5_tod] = '4'
					THEN [hwy_link_ab_tod].[ln]
					ElSE 0 END) AS [ba_pm_lane]
		,SUM(CASE	WHEN [hwy_link_ab_tod].[ab] = 1
					AND [time].[abm_5_tod] = '5'
					THEN [hwy_link_ab_tod].[ln]
					ElSE 0 END) AS [ab_ev_lane]
		,SUM(CASE	WHEN [hwy_link_ab_tod].[ab] = 0
					AND [time].[abm_5_tod] = '5'
					THEN [hwy_link_ab_tod].[ln]
					ElSE 0 END) AS [ba_ev_lane]
	FROM
		[dimension].[hwy_link_ab_tod]
	INNER JOIN
		[dimension].[time]
	ON
		[hwy_link_ab_tod].[time_id] = [time].[time_id]
	GROUP BY
		[hwy_link_ab_tod].[scenario_id]
		,[hwy_link_ab_tod].[hwy_link_id]
) AS [hwy_link_ab_tod_wide]
ON
	[hwy_link].[scenario_id] = [hwy_link_ab_tod_wide].[scenario_id]
	AND [hwy_link].[hwy_link_id] = [hwy_link_ab_tod_wide].[hwy_link_id]
GO

-- Add metadata for [report].[vi_hwyload]
EXECUTE [db_meta].[add_xp] 'report.vi_hwyload', 'SUBSYSTEM', 'report'
EXECUTE [db_meta].[add_xp] 'report.vi_hwyload', 'MS_Description', 'view to return loaded highway network for query layers or shapefiles'
GO




-- Create stored procedure for person trip and trip mode split
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[report].[sp_model_mode_share]') AND type in (N'P', N'PC'))
DROP PROCEDURE [report].[sp_model_mode_share]
GO

CREATE PROCEDURE [report].[sp_model_mode_share]
	@scenario_id integer,
	@model_list varchar(200) -- list of ABM sub-models to include delimited by commas
	-- example usage to get mode split for resident models:
	-- EXECUTE [report].[sp_mode_split] 1, 'Individual,Internal-External,Joint'
	-- see [dimension].[model_trip].[model_trip_description] for valid values
AS

/*	Author: Gregor Schroeder
	Date: 7/6/2018
	Description: Person trip and trip mode split for given input scenario
		and list of ABM sub-models.
*/

-- ensure the input @model_list parameter contains valid ABM sub-model descriptions
IF EXISTS(
	SELECT
		[value]
	FROM
		STRING_SPLIT(@model_list, ',') AS [mode_list]
	LEFT OUTER JOIN
		[dimension].[model_trip]
	ON
		[mode_list].[value] = [model_trip].[model_trip_description]
	WHERE
		[model_trip].[model_trip_id] IS NULL)
BEGIN
RAISERROR ('Input value for ABM sub-model does not exist. Check the @model_list parameter.', 16, 1)
RETURN -1
END

-- get person trips and trips by mode
DECLARE @aggregated_trips TABLE (
	[mode_aggregate_trip_description] nchar(50) NOT NULL,
	[person_trips] float NOT NULL,
	[trips] float NOT NULL)

INSERT INTO @aggregated_trips
SELECT
	ISNULL([mode_aggregate_trip_description], 'Total') AS [mode_aggregate_trip_description]
	,SUM([weight_person_trip]) AS [person_trips]
	,SUM([weight_trip]) AS [trips]
FROM
	[fact].[person_trip]
INNER JOIN
	[dimension].[model_trip]
ON
	[person_trip].[model_trip_id] = [model_trip].[model_trip_id]
INNER JOIN
	[dimension].[mode_trip]
ON
	[person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
WHERE
	[scenario_id] = @scenario_id
	AND [model_trip].[model_trip_description] IN (SELECT [value] FROM STRING_SPLIT(@model_list, ','))
GROUP BY
	[mode_aggregate_trip_description]
WITH ROLLUP

SELECT
	@scenario_id AS [scenario_id]
	,[mode_aggregate_trip_description]
	,100.0 * [person_trips] / (SELECT [person_trips] FROM @aggregated_trips WHERE [mode_aggregate_trip_description] = 'Total') AS [pct_person_trips]
	,[person_trips]
	,100.0 * [trips] / (SELECT [trips] FROM @aggregated_trips WHERE [mode_aggregate_trip_description] = 'Total') AS [pct_trips]
	,[trips]
FROM
	@aggregated_trips

RETURN
GO

-- Add metadata for [report].[sp_model_mode_share]
EXECUTE [db_meta].[add_xp] 'report.sp_model_mode_share', 'SUBSYSTEM', 'report'
EXECUTE [db_meta].[add_xp] 'report.sp_model_mode_share', 'MS_Description', 'person trip and trip mode split for given input scenario and list of ABM sub-models'
GO




-- Create stored procedure for resident mode share
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[report].[sp_resident_mode_share]') AND type in (N'P', N'PC'))
DROP PROCEDURE [report].[sp_resident_mode_share]
GO

CREATE PROCEDURE [report].[sp_resident_mode_share]
	@scenario_id integer,
	@geography_column nvarchar(50)
AS
/*	Author: Gregor Schroeder
	Date: 11/8/2018
	Description: San Diego resident person trip mode share of trips originating
		from the resident's home location. The geographic resolution is chosen
		by the user. */
BEGIN
	-- ensure the input geography column exists
	-- in the [dimension].[geography] table
	-- stop execution if it does not and throw error
	IF NOT EXISTS (
		SELECT
			[COLUMN_NAME]
		FROM
			[INFORMATION_SCHEMA].[COLUMNS]
		WHERE
			[TABLE_SCHEMA] = 'dimension'
			AND [TABLE_NAME] = 'geography'
			AND [COLUMN_NAME] = @geography_column)
	BEGIN
		RAISERROR ('The column %s does not exist in the [dimension].[geography] table.', 16, 1, @geography_column)
	END
	-- if it does exist then continue execution
	ELSE
	BEGIN
	SET NOCOUNT ON;

	-- create temporary table of mode share results
	CREATE TABLE #aggregated_trips (
		[geography] nchar(50) NOT NULL,
		[mode_aggregate_trip_description] nchar(50) NOT NULl,
		[person_trips] float NOT NULL);

	-- build dynamic SQL string
	DECLARE @sql nvarchar(max) = '
	INSERT INTO #aggregated_trips
		SELECT
			ISNULL([geography].' + @geography_column + ', ''Exclude'') AS [geography]
			,ISNULL([mode_aggregate_trip_description], ''Total'') AS [mode_aggregate_trip_description]
			,SUM([person_trip].[weight_person_trip]) AS [person_trips]
		FROM
			[fact].[person_trip]
		INNER JOIN
			[dimension].[model_trip]
		ON
			[person_trip].[model_trip_id] = [model_trip].[model_trip_id]
		INNER JOIN
			[dimension].[mode_trip]
		ON
			[person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
		INNER JOIN
			[dimension].[household]
		ON
			[person_trip].[scenario_id] = [household].[scenario_id]
			AND [person_trip].[household_id] = [household].[household_id]
			-- this final condition limits to only trips originating in the household location
			AND [person_trip].[geography_trip_origin_id] = [household].[geography_household_location_id]
		INNER JOIN
			[dimension].[geography]
		ON
			[household].[geography_household_location_id] = [geography].[geography_id]
		WHERE
			[person_trip].[scenario_id] = ' + CONVERT(varchar, @scenario_id) + '
			AND [household].[scenario_id] = ' + CONVERT(varchar,  @scenario_id) + '
			AND [model_trip].[model_trip_description] IN (''Individual'',
														  ''Internal-External'',
														  ''Joint'') -- San Diego Resident Models
		GROUP BY
			[geography].' + @geography_column + '
			,[mode_aggregate_trip_description]
		WITH ROLLUP

	-- create and output mode share percentages within each geography
	SELECT
		' + CONVERT(varchar, @scenario_id) + ' AS [scenario_id]
		,#aggregated_trips.[geography]
		,[mode_aggregate_trip_description] AS [mode_aggregate]
		,ROUND(100.0 * #aggregated_trips.[person_trips] / [tbl_totals].[person_trips], 2) AS [pct_person_trips]
		,#aggregated_trips.[person_trips]
	FROM
		#aggregated_trips
	INNER JOIN (
		SELECT
			[geography]
			,[person_trips]
		FROM
			#aggregated_trips
		WHERE
			[mode_aggregate_trip_description] = ''Total'') AS [tbl_totals]
	ON
		#aggregated_trips.[geography] = [tbl_totals].[geography]
	WHERE
		#aggregated_trips.[geography] != ''Exclude'''

	-- execute dynamic SQL string
	EXECUTE (@sql)

	-- drop temporary table
	DROP TABLE #aggregated_trips
	END
END
GO

-- Add metadata for [report].[sp_resident_mode_share]
EXECUTE [db_meta].[add_xp] 'report.sp_resident_mode_share', 'SUBSYSTEM', 'report'
EXECUTE [db_meta].[add_xp] 'report.sp_resident_mode_share', 'MS_Description', 'San Diego resident person trip mode share of trips originating from the resident''s home location'
GO




-- Create stored procedure for resident vmt by home/workplace location
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[report].[sp_resident_vmt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [report].[sp_resident_vmt]
GO

CREATE PROCEDURE [report].[sp_resident_vmt]
	@scenario_id integer,
	@geography_column nvarchar(max),
	@workers bit = 0, -- indicator to select workers only, includes telecommuters
	@home_location bit = 0, -- indicator to assign activity to home location
	@work_location bit = 0 -- indicator to assign activity to workplace location, includes telecommuters
AS

/*	Author: Gregor Schroeder
	Date: Revised 11/8/2018
	Description: Resident pmt/vmt. Can filter activity from all residents to workers only.
				 Can assign activity to either home or workplace location.
				 Per-capita measures depend on the assigned activity and worker filter
				 selected. The geographic resolution is chosen by the user.
*/
BEGIN

	-- ensure the input geography column exists
	-- in the [dimension].[geography] table
	-- stop execution if it does not and throw error
	IF NOT EXISTS (
		SELECT
			[COLUMN_NAME]
		FROM
			[INFORMATION_SCHEMA].[COLUMNS]
		WHERE
			[TABLE_SCHEMA] = 'dimension'
			AND [TABLE_NAME] = 'geography'
			AND [COLUMN_NAME] = @geography_column)
	BEGIN
		RAISERROR ('The column %s does not exist in the [dimension].[geography] table.', 16, 1, @geography_column)
	END

	-- ensure only one of indicator to assign activity to home or work location
	-- is selected
	IF CONVERT(int, @home_location) + CONVERT(int, @work_location) > 1
	BEGIN
	RAISERROR ('Select to assign activity to either home or work location.', 16, 1)
	END

	-- if activity is assigned to work location then the workers
	-- only filter must be selected
	IF CONVERT(int, @workers) = 0 AND CONVERT(int, @work_location) >= 1
	BEGIN
	RAISERROR ('Assigning activity to work location requires selection of workers only filter.', 16, 1)
	END


	-- if all input parameters are valid execute the stored procedure
	-- build dynamic SQL string
	-- note the use of nvarchar(max) throughout to avoid implicit conversion to varchar(8000)
	DECLARE @sql nvarchar(max) = '
	SELECT
		' + CONVERT(nvarchar(max), @scenario_id) + ' AS [scenario_id]
		,CASE	WHEN ' + CONVERT(nvarchar(max), @workers) + ' = 0 THEN ''All Residents''
				WHEN ' + CONVERT(nvarchar(max), @workers) + ' = 1 THEN ''Workers Only''
				ELSE NULL END AS [population]
		,CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1 THEN ''Activity Assigned to Home Location''
				WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1 THEN ''Activity Assigned to Workplace Location''
				ELSE NULL END AS [activity_location]
		,[persons].' + @geography_column + '
		,[persons].[persons]
		,ISNULL([trips].[trips], 0) AS [trips]
		,ISNULL([trips].[trips], 0) / [persons].[persons] AS [trips_per_capita]
		,ISNULL([trips].[vmt], 0) AS [vmt]
		,ISNULL([trips].[vmt], 0) / [persons].[persons] AS [vmt_per_capita]
	FROM (
		SELECT DISTINCT -- distinct here for case when only total is wanted (no home location, no work location), avoids duplicate Total column caused by ROLLUP
			ISNULL(CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1
							THEN [geography_household_location].household_location_' + @geography_column + '
							WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1
							THEN  [geography_work_location].work_location_' + @geography_column + '
							ELSE NULL
							END, ''Total'') AS ' + @geography_column + '
			,SUM([person].[weight_person]) AS [persons]
		FROM
			[dimension].[person]
		INNER JOIN
			[dimension].[household]
		ON
			[person].[scenario_id] = [household].[scenario_id]
			AND [person].[household_id] = [household].[household_id]
		INNER JOIN
			[dimension].[geography_household_location]
		ON
			[household].[geography_household_location_id] = [geography_household_location].[geography_household_location_id]
		INNER JOIN
			[dimension].[geography_work_location]
		ON
			[person].[geography_work_location_id] = [geography_work_location].[geography_work_location_id]
		WHERE
			[person].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
			AND [household].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
			AND [person].[weight_person] > 0
			AND (' + CONVERT(nvarchar(max), @workers) + ' = 0 OR (' + CONVERT(nvarchar(max), @workers) + ' = 1 AND [person].[work_segment] != ''Non-Worker'')) -- exclude non-workers if worker filter is selected
		GROUP BY
			CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1
					THEN [geography_household_location].household_location_' + @geography_column + '
					WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1
					THEN  [geography_work_location].work_location_' + @geography_column + '
					ELSE NULL
					END
		WITH ROLLUP) AS [persons]
	LEFT OUTER JOIN ( -- keep zones with residents/employees even if 0 trips/vmt
		SELECT DISTINCT -- distinct here for case when only total is wanted (no home location, no work location), avoids duplicate Total column caused by ROLLUP
			ISNULL(CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1
							THEN [geography_household_location].household_location_' + @geography_column + '
							WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1
							THEN  [geography_work_location].work_location_' + @geography_column + '
							ELSE NULL
							END, ''Total'') AS ' + @geography_column + '
			,SUM([person_trip].[weight_trip]) AS [trips]
			,SUM([person_trip].[weight_trip] * [person_trip].[dist_drive]) AS [vmt]
		FROM
			[fact].[person_trip]
		INNER JOIN
			[dimension].[model_trip]
		ON
			[person_trip].[model_trip_id] = [model_trip].[model_trip_id]
		INNER JOIN
			[dimension].[household]
		ON
			[person_trip].[scenario_id] = [household].[scenario_id]
			AND [person_trip].[household_id] = [household].[household_id]
		INNER JOIN
			[dimension].[person]
		ON
			[person_trip].[scenario_id] = [person].[scenario_id]
			AND [person_trip].[person_id] = [person].[person_id]
		INNER JOIN
			[dimension].[geography_household_location]
		ON
			[household].[geography_household_location_id] = [geography_household_location].[geography_household_location_id]
		INNER JOIN
			[dimension].[geography_work_location]
		ON
			[person].[geography_work_location_id] = [geography_work_location].[geography_work_location_id]
		WHERE
			[person_trip].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
			AND [person].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
			AND [household].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
			AND [model_trip].[model_trip_description] IN (''Individual'',
														  ''Internal-External'',
														  ''Joint'') -- only resident models use synthetic population
			AND (' + CONVERT(nvarchar(max), @workers) + ' = 0
			     OR (' + CONVERT(nvarchar(max), @workers) + ' = 1 AND [person].[work_segment] != ''Non-Worker'')) -- exclude non-workers if worker filter is selected
		GROUP BY
			CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1
					THEN [geography_household_location].household_location_' + @geography_column + '
					WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1
					THEN  [geography_work_location].work_location_' + @geography_column + '
					ELSE NULL
					END
		WITH ROLLUP) AS [trips]
	ON
		[persons].' + @geography_column + ' = [trips].' + @geography_column + '
	ORDER BY -- keep sort order of alphabetical with Total at bottom
		CASE WHEN [persons].' + @geography_column + ' = ''Total'' THEN ''ZZ''
		ELSE [persons].' + @geography_column + ' END ASC
		OPTION(MAXDOP 1)'


	-- execute dynamic SQL string
	EXECUTE (@sql)
END
GO

-- Add metadata for [report].[sp_resident_vmt]
EXECUTE [db_meta].[add_xp] 'report.sp_resident_vmt', 'SUBSYSTEM', 'report'
EXECUTE [db_meta].[add_xp] 'report.sp_resident_vmt', 'MS_Description', 'vehicle miles travelled by residents home/workplace location'
GO




-- Create stored procedure for resident mode share
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[report].[sp_worker_mode_share]') AND type in (N'P', N'PC'))
DROP PROCEDURE [report].[sp_worker_mode_share]
GO

CREATE PROCEDURE [report].[sp_worker_mode_share]
	@scenario_id integer,
	@geography_column nvarchar(50)
AS
/*	Author: Gregor Schroeder
	Date: 11/8/2018
	Description: San Diego resident person trip mode share of work purpose trips
		destinating at the resident's workplace location. The geographic resolution
		is chosen by the user. */
BEGIN
	-- ensure the input geography column exists
	-- in the [dimension].[geography] table
	-- stop execution if it does not and throw error
	IF NOT EXISTS (
		SELECT
			[COLUMN_NAME]
		FROM
			[INFORMATION_SCHEMA].[COLUMNS]
		WHERE
			[TABLE_SCHEMA] = 'dimension'
			AND [TABLE_NAME] = 'geography'
			AND [COLUMN_NAME] = @geography_column)
	BEGIN
		RAISERROR ('The column %s does not exist in the [dimension].[geography] table.', 16, 1, @geography_column)
	END
	-- if it does exist then continue execution
	ELSE
	BEGIN
	SET NOCOUNT ON;

	-- create temporary table of mode share results
	CREATE TABLE #aggregated_trips (
		[geography] nchar(50) NOT NULL,
		[mode_aggregate_trip_description] nchar(50) NOT NULl,
		[person_trips] float NOT NULL);

	-- build dynamic SQL string
	DECLARE @sql nvarchar(max) = '
	INSERT INTO #aggregated_trips
		SELECT
			ISNULL([geography].' + @geography_column + ', ''Exclude'') AS [geography]
			,ISNULL([mode_aggregate_trip_description], ''Total'') AS [mode_aggregate_trip_description]
			,SUM([person_trip].[weight_person_trip]) AS [person_trips]
		FROM
			[fact].[person_trip]
		INNER JOIN
			[dimension].[model_trip]
		ON
			[person_trip].[model_trip_id] = [model_trip].[model_trip_id]
		INNER JOIN
			[dimension].[mode_trip]
		ON
			[person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
		INNER JOIN
			[dimension].[purpose_trip_destination]
		ON
			[person_trip].[purpose_trip_destination_id] = [purpose_trip_destination].[purpose_trip_destination_id]
		INNER JOIN
			[dimension].[tour]
		ON
			[person_trip].[scenario_id] = [tour].[scenario_id]
			AND [person_trip].[tour_id] = [tour].[tour_id]
		INNER JOIN
			[dimension].[geography]
		ON
			[person_trip].[geography_trip_destination_id] = [geography].[geography_id]
		WHERE
			[person_trip].[scenario_id] = ' + CONVERT(varchar, @scenario_id) + '
			AND [tour].[scenario_id] = ' + CONVERT(varchar, @scenario_id) + '
			AND [model_trip].[model_trip_description] IN (''Individual'',
														  ''Internal-External'',
														  ''Joint'') -- San Diego Resident Models
			AND [purpose_trip_destination].[purpose_trip_destination_description] = ''Work''
			AND [tour].[tour_category] = ''Mandatory''  -- necessary to filter out At-Work subtour trips with Work trip purpose
		GROUP BY
			[geography].' + @geography_column + '
			,[mode_aggregate_trip_description]
		WITH ROLLUP

		-- create and output mode share percentages within each geography
		SELECT
			' + CONVERT(varchar, @scenario_id) + ' AS [scenario_id]
			,#aggregated_trips.[geography]
			,[mode_aggregate_trip_description] AS [mode_aggregate]
			,ROUND(100.0 * #aggregated_trips.[person_trips] / [tbl_totals].[person_trips], 2) AS [pct_person_trips]
			,#aggregated_trips.[person_trips]
		FROM
			#aggregated_trips
		INNER JOIN (
			SELECT
				[geography]
				,[person_trips]
			FROM
				#aggregated_trips
			WHERE
				[mode_aggregate_trip_description] = ''Total'') AS [tbl_totals]
		ON
			#aggregated_trips.[geography] = [tbl_totals].[geography]
		WHERE
			#aggregated_trips.[geography] != ''Exclude'''

	-- execute dynamic SQL string
	EXECUTE (@sql)

	-- drop temporary table
	DROP TABLE #aggregated_trips
	END
END
GO

-- Add metadata for [report].[sp_worker_mode_share]
EXECUTE [db_meta].[add_xp] 'report.sp_worker_mode_share', 'SUBSYSTEM', 'report'
EXECUTE [db_meta].[add_xp] 'report.sp_worker_mode_share', 'MS_Description', 'San Diego resident person trip mode share of work purpose trips destinating at the resident''s workplace location'
GO




-- create function to assign tour mode ---------------------------------------
-- to all resident ABM sub-model tours inbound/outbound directions
-- based on SANDAG tour mode hierarchy
DROP FUNCTION IF EXISTS [report].[fn_resident_tour_mode_hierarchy]
GO

CREATE FUNCTION [report].[fn_resident_tour_mode_hierarchy]
(
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
)
RETURNS TABLE
AS
RETURN
/**
summary:   >
    Calculate aggregate mode for San Diego Resident ABM sub-models
	(Individiual, Internal-External, Joint) tour journey
	(tour and inbound/outbound direction) according to the SANDAG determined
	hierarchy.
    For a unique tour journey ([tour_id], [inbound_id]):
	If transit is a mode on any trip in the journey then use transit as the
	mode. If transit is not present then use the mode with the longest
	distance on the journey. If there are any ties then apply a hierarchy
	(walk > bike > sr3 > sr2 > sov > taxi > school bus).
	Returns table of unique tour journeys ([tour_id], [inbound_id]) for
	all San Diego Resident ABM sub-model non-NULL tours
    ([tour_id] != 0, [tour].[weight_tour] > 0, [tour].[weight_person_tour] > 0)
    for a given [scenario_id] with the calculated SANDAG aggregate tour
    journey mode.

revisions:
    - None
**/
    with [tour_distances] AS (
    	-- create table of total tour distances
	    -- segmented by inbound/outbound direction and mode
	    -- returns a list of unique ([tour_id], [inbound_id], [mode_aggregate_trip_description])
	    -- with the summation of total distance within each 3-tuple
	    SELECT
		    [person_trip].[tour_id]
		    ,[person_trip].[inbound_id]
		    ,[mode_trip].[mode_aggregate_trip_description]
		    ,SUM([dist_total]) AS [dist_total]
	    FROM
		    [fact].[person_trip]
	    INNER JOIN
		    [dimension].[mode_trip]
	    ON
		    [person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
	    INNER JOIN
		    [dimension].[model_trip]
	    ON
		    [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
	    INNER JOIN
		    [dimension].[tour]
	    ON
		    [person_trip].[scenario_id] = [tour].[scenario_id]
		    AND [person_trip].[tour_id] = [tour].[tour_id]
	    WHERE
		    [person_trip].[scenario_id] = @scenario_id
		    -- remove NULL tours aka trip records not associated with tours
		    -- could use [tour].[weight_tour] > 0 or [tour_id] != 0
		    AND [tour].[weight_person_tour] > 0
            -- San Diego Resident models only
		    AND [model_trip].[model_trip_description] IN ('Individual',
													      'Internal-External',
													      'Joint')
	    GROUP BY
		    [person_trip].[scenario_id]
		    ,[person_trip].[tour_id]
		    ,[person_trip].[inbound_id]
		    ,[mode_trip].[mode_aggregate_trip_description]),
	-- using aggregated tour distances list
	-- segmented by inbound/outbound direction
	-- if transit is present at any point in the tour then use transit as the mode
	-- if transit is not present use the longest distance mode
	-- if there is a tie, then walk > bike > sr3 > sr2 > sov > taxi > school bus
	-- return final tour list with the calculated tour mode
	-- unique by ([tour_id], [inbound_id])
	[tiebreakers] AS (
		SELECT
			[tour_id]
			,[inbound_id]
			,MAX([transit_tour]) AS [transit_tour]
			,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Walk'
							THEN 1 ELSE 0 END) AS [tiebreaker_walk]
			,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Bike'
							THEN 1 ELSE 0 END) AS [tiebreaker_bike]
			,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Shared Ride 3'
							THEN 1 ELSE 0 END) AS [tiebreaker_sr3]
			,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Shared Ride 2'
							THEN 1 ELSE 0 END) AS [tiebreaker_sr2]
			,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Drive Alone'
							THEN 1 ELSE 0 END) AS [tiebreaker_da]
			,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Taxi'
							THEN 1 ELSE 0 END) AS [tiebreaker_taxi]
			,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'School Bus'
							THEN 1 ELSE 0 END) AS [tiebreaker_sb]
		FROM (
			-- create aggregated tour distances from tour distances list
			-- identify tours where transit is present
			-- and get the mode of the record with the largest tour distance
			-- segmented by inbound/outbound direction
			-- takes list of unique ([tour_id], [inbound_id], [mode_aggregate_trip_description])
			-- and returns the records with the longest distances within the 3-tuple
			-- this in not unique within ([tour_id], [inbound_id]) as there can be ties
			SELECT
				[tour_distances].[tour_id]
				,[tour_distances].[inbound_id]
				,[tour_distances].[mode_aggregate_trip_description]
				,[tt].[transit_tour]
			FROM
				[tour_distances]
			INNER JOIN (
				SELECT
					[tour_id]
					,[inbound_id]
					,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Transit'
								THEN 1 ELSE 0 END) AS [transit_tour]
					,MAX([dist_total]) AS [longest_distance]
				FROM
					[tour_distances]
				GROUP BY
					[tour_id]
					,[inbound_id]) AS [tt]
			ON
				[tour_distances].[tour_id] = [tt].[tour_id]
				AND [tour_distances].[inbound_id] = [tt].[inbound_id]
				AND [tour_distances].[dist_total] = [tt].[longest_distance]
			) AS [agg_tour_distances]
		GROUP BY
			[tour_id]
			,[inbound_id])
	SELECT
		@scenario_id AS [scenario_id]
		,[tour_id]
		,[inbound_id]
		,CASE	WHEN [transit_tour] = 1 THEN 'Transit'
				WHEN [tiebreaker_walk] = 1 THEN 'Walk'
				WHEN [tiebreaker_bike] = 1 THEN 'Bike'
				WHEN [tiebreaker_sr3] = 1 THEN 'Shared Ride 3'
				WHEN [tiebreaker_sr2] = 1 THEN 'Shared Ride 2'
				WHEN [tiebreaker_da] = 1 THEN 'Drive Alone'
				WHEN [tiebreaker_taxi] = 1 THEN 'Taxi'
				WHEN [tiebreaker_sb] = 1 THEN 'School Bus'
				ELSE NULL END AS [mode_aggregate_description]
	FROM
		[tiebreakers]
GO

-- add metadata for [report].[fn_resident_tour_mode_hierarchy]
EXECUTE [db_meta].[add_xp] 'report.fn_resident_tour_mode_hierarchy', 'MS_Description', 'inline function returning list of all ABM San Diego Resident sub-model non-NULL unique tour journeys ([tour_id], [inbound_id]) with the calculated aggregate SANDAG tour mode appended.'
GO