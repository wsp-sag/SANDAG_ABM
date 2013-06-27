@echo off

set PROJECT_DRIVE=%1
set PROJECT_DIRECTORY=%2
set SAMPLERATE=%3
set ITERATION=%4

%PROJECT_DRIVE%
cd %PROJECT_DIRECTORY%
call %PROJECT_DIRECTORY%\CTRampEnv.bat

rem ### First save the JAVA_PATH environment variable so it s value can be restored at the end.
set OLDJAVAPATH=%JAVA_PATH%

rem ### Set the directory of the jdk version desired for this model run
rem ### Note that a jdk is required; a jre is not sufficient, as the UEC class generates
rem ### and compiles code during the model run, and uses javac in the jdk to do this.
set JAVA_PATH=%JAVA_64_PATH%

rem ### Name the project directory.  This directory will hava data and runtime subdirectories
set RUNTIME=%PROJECT_DIRECTORY%
set CONFIG=%RUNTIME%/config

rem ### Set the name of the properties file the application uses by giving just the base part of the name (with ".xxx" extension)
set PROPERTIES_NAME=sandag_abm

set JAR_LOCATION=%PROJECT_DIRECTORY%/application
set LIB_JAR_PATH=%JAR_LOCATION%\sandag_abm_pb.jar

set JAR_LOCATION=%RUNTIME%/application

rem ### Define the CLASSPATH environment variable for the classpath needed in this model run.
set OLDCLASSPATH=%CLASSPATH%
set CLASSPATH=%TRANSCAD_PATH%/GISDK/Matrices/TranscadMatrix.jar;%CONFIG%;%RUNTIME%;%LIB_JAR_PATH%;

rem ### Save the name of the PATH environment variable, so it can be restored at the end of the model run.
set OLDPATH=%PATH%

rem ### Change the PATH environment variable so that JAVA_HOME is listed first in the PATH.
rem ### Doing this ensures that the JAVA_HOME path we defined above is the on that gets used in case other java paths are in PATH.
set PATH=%TRANSCAD_PATH%;%JAVA_PATH%\bin;%OLDPATH%


rem ### Sandag ABM needs more than 16000m virtual machine, try 32000m
rem java -server -Xms24000m -Xmx24000m -cp "%CLASSPATH%" -Dlog4j.configuration=log4j.xml -Dproject.folder=%PROJECT_DIRECTORY% -Djppf.config=jppf-client.properties org.sandag.abm.application.SandagTourBasedModel %PROPERTIES_NAME% -iteration 1 -sampleRate 0.1 -sampleSeed 1
rem java -Xdebug -Xrunjdwp:transport=dt_socket,address=1044,server=y,suspend=y -server -Xms28000m -Xmx28000m -cp "%CLASSPATH%" -Dlog4j.configuration=log4j.xml -Dproject.folder=%PROJECT_DIRECTORY% -Djppf.config=jppf-client.properties org.sandag.abm.application.SandagTourBasedModel %PROPERTIES_NAME% -iteration 1 -sampleRate %SAMPLERATE% -sampleSeed 1

ping �n 5 localhost > nul

rem ## DISTRIBUTED ##
rem java -Xdebug -Xrunjdwp:transport=dt_socket,address=1045,server=y,suspend=y -server -Xms8000m -Xmx8000m -cp "%CLASSPATH%" -Dlog4j.configuration=log4j.xml -Dproject.folder=%PROJECT_DIRECTORY% -Djppf.config=jppf-clientDistributed.properties org.sandag.abm.application.SandagTourBasedModel %PROPERTIES_NAME% -iteration %ITERATION% -sampleRate %SAMPLERATE% -sampleSeed 1

rem Run locally
%JAVA_64_PATH%\bin\java -server -Xms7000m -Xmx7000m -cp "%CLASSPATH%" -Dlog4j.configuration=log4j.xml -Dproject.folder=%PROJECT_DIRECTORY% -Djppf.config=jppf-clientDistributed.properties org.sandag.abm.application.SandagTourBasedModel %PROPERTIES_NAME% -iteration %ITERATION% -sampleRate %SAMPLERATE% -sampleSeed 1

rem Build trip tables
%JAVA_64_PATH%\bin\java -server -Xms7000m -Xmx7000m -Djava.library.path=%TRANSCAD_PATH% -cp "%CLASSPATH%" -Dlog4j.configuration=log4j.xml -Dproject.folder=%PROJECT_DIRECTORY% org.sandag.abm.application.SandagTripTables %PROPERTIES_NAME%  -iteration %ITERATION% -sampleRate %SAMPLERATE% 

rem Airport model
%JAVA_64_PATH%\bin\java -server -Xms7000m -Xmx7000m -cp "%CLASSPATH%" -Dlog4j.configuration=log4j.xml -Dproject.folder=%PROJECT_DIRECTORY% org.sandag.abm.airport.AirportModel %PROPERTIES_NAME%  

rem Build airport model trip tables
%JAVA_64_PATH%\bin\java -server -Xms7000m -Xmx7000m -Djava.library.path=%TRANSCAD_PATH% -cp "%CLASSPATH%" -Dlog4j.configuration=log4j.xml -Dproject.folder=%PROJECT_DIRECTORY% org.sandag.abm.airport.AirportTripTables %PROPERTIES_NAME% 




rem ### restore saved environment variable values, and change back to original current directory
set JAVA_PATH=%OLDJAVAPATH%
set PATH=%OLDPATH%
set CLASSPATH=%OLDCLASSPATH%
