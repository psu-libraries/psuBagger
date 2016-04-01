@if "%DEBUG%" == "" @echo off
@rem ##########################################################################
@rem
@rem  bagit startup script for Windows
@rem
@rem ##########################################################################

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

@rem Add default JVM options here. You can also use JAVA_OPTS and BAGIT_OPTS to pass JVM options to this script.
set DEFAULT_JVM_OPTS="-Dapp.home=.." "-Dversion=4.12.0"

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set APP_BASE_NAME=%~n0
set APP_HOME=%DIRNAME%..

@rem Find java.exe
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%" == "0" goto init

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%/bin/java.exe

if exist "%JAVA_EXE%" goto init

echo.
echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:init
@rem Get command-line arguments, handling Windows variants

if not "%OS%" == "Windows_NT" goto win9xME_args
if "%@eval[2+2]" == "4" goto 4NT_args

:win9xME_args
@rem Slurp the command line arguments.
set CMD_LINE_ARGS=
set _SKIP=2

:win9xME_args_slurp
if "x%~1" == "x" goto execute

set CMD_LINE_ARGS=%*
goto execute

:4NT_args
@rem Get arguments from the 4NT Shell from JP Software
set CMD_LINE_ARGS=%$

:execute
@rem Setup the command line

set CLASSPATH=%APP_HOME%\lib\bagit-4.12.0.jar;%APP_HOME%\lib\slf4j-api-1.7.5.jar;%APP_HOME%\lib\commons-compress-1.8.1.jar;%APP_HOME%\lib\commons-logging-api-1.1.jar;%APP_HOME%\lib\commons-logging-1.1.3.jar;%APP_HOME%\lib\commons-io-2.4.jar;%APP_HOME%\lib\commons-codec-1.9.jar;%APP_HOME%\lib\httpclient-4.3.2.jar;%APP_HOME%\lib\httpmime-4.3.2.jar;%APP_HOME%\lib\jsap-2.1.jar;%APP_HOME%\lib\dom4j-1.6.1.jar;%APP_HOME%\lib\commons-net-3.3.jar;%APP_HOME%\lib\commons-exec-1.2.jar;%APP_HOME%\lib\jaxen-1.1.4.jar;%APP_HOME%\lib\classworlds-1.1.jar;%APP_HOME%\lib\log4j-1.2.17.jar;%APP_HOME%\lib\httpcore-4.3.1.jar;%APP_HOME%\lib\xml-apis-1.0.b2.jar;%APP_HOME%\conf

@rem Execute bagit
"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %BAGIT_OPTS%  -classpath "%CLASSPATH%" gov.loc.repository.bagit.driver.CommandLineBagDriver %CMD_LINE_ARGS%

:end
@rem End local scope for the variables with windows NT shell
if "%ERRORLEVEL%"=="0" goto mainEnd

:fail
rem Set variable BAGIT_EXIT_CONSOLE if you need the _script_ return code instead of
rem the _cmd.exe /c_ return code!
if  not "" == "%BAGIT_EXIT_CONSOLE%" exit 1
exit /b 1

:mainEnd
if "%OS%"=="Windows_NT" endlocal

:omega
