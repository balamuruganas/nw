@ECHO OFF
setlocal EnableDelayedExpansion
if [%1]==[/?] goto:Help
:Prepare -- Preparation step. Initialization of Batch Execution Parameters
pushd %CWD%
set DISKLETTER=%CD:~0,3% & set DISKLETTER
set CWD=%CD%& set CWD
:: Solution Filename
set %1&set %2&set %3&set %4&set %5&set %6&set %7
if "%SLNFILENAME%"=="" echo ERROR: Please Define Solution Filename && goto:Help
:: CSProject name
if "%CSPROJ%"=="" echo ERROR: Please Define CSProject Name && goto:Help
:: Visual Studio version
:: If VSVersion is not defined we use 14.0 as a default one
if "%VSVERSION%"=="" set VSVERSION=14.0
:: Project Build Type -> Configuration Profile
:: If Buildtype is not defined we use Debug as a default one
if "%BUILDTYPE%"=="" set BUILDTYPE=Debug
:: If THREADS value is not defined we use 2 by default
if "%THREADS%"=="" set THREADS=4
::Variable for Current Time
goto:Step0
:Step0 -- Search for Solution File
echo ----- Looking for Solution File -----
if exist %SLNFILENAME% (echo ---- File exists ---- && set SLNPATH=%CD%& goto :Step1) else (echo ---- File does not exist in %CD% ---- && echo ---- Going Upper On Level ---- && pushd ..\ && if %CD%==%DISKLETTER% ( echo ERROR: Check If File is Placed under Source Folder && exit /b 1) else ( goto:Step0 ))
:Step1 -- Search for Tools Required for Build Process
echo --- Solution Path is: %SLNPATH% ---
if "%WORKSPACE%"=="" set WORKSPACE=%SLNPATH%
if not defined WORKSPACE set WORKSPACE=%SLNPATH%
echo WARNING: MSBUILD Location from %VSVERSION% of Visual Studio && set MSBUILD=%ProgramFiles(x86)%\MSBuild\%VSVERSION%\Bin\MSBuild.exe
if exist "%MSBUILD%" ( echo -- MSBUILD file is found -- )
:Step2 -- Restore Nuget Packages
echo WARNING: XUNIT2RUNNER Tool should be in packages folder && set XUNIT2RUNNER="%SLNPATH%\packages\xunit.runner.console.2.2.0\tools\xunit.console.exe"
set XUNIT2RUNNER
if exist "%XUNIT2RUNNER%" ( echo -- XUNIT2RUNNER file is found -- )
:: Here we will find Project file in directory recursively
For /R %WORKSPACE%\src %%G IN (*.Tests.csproj) do (
echo Found Project File in: %%G && set CSPROJECTFILEPATH="%%G"
set CSPROJECTFILEPATH
FOR %%i IN ("%CSPROJECTFILEPATH%") DO (
    set CSPROJECTDRIVE=%%~di
    set CSPROJECTPATH=%%~pi
    set CSPROJECTFILEEXT=%%~xi
)
echo --- Bulding Project ---
set CSPROJ
)
call "%MSBUILD%" !CSPROJECTFILEPATH! /t:build /p:Configuration=%BUILDTYPE% /p:OutDir="%WORKSPACE%\build" /m
::)
pushd  build
del *Tests*.xml
del *.log
For /R %CD% %%G IN (*.Tests.dll) do (
echo %%~nxG
call %XUNIT2RUNNER% %%~nxG -maxthreads %THREADS% -nunit %%~nG.xml
)
popd
exit %ERRORLEVEL%
:Help
ECHO ----- Parameters Requirements -----
ECHO - REQUIRED:-
ECHO 1. Solution Filename ^-^-^> eg. "SLNFILENAME=VTestCore.sln"
ECHO 2. CSProject Name ^-^-^> eg. "CSPROJ=NW.XC.Tests.UI"
ECHO - OPTIONAL:-
ECHO 3. Visual Studio version ^-^-^> eg. "VSVERSION=14.0", default "VSVERSION=14.0"
ECHO 4. Project Build Type ^-^-^> eg. "BUILDTYPE=Debug", default "BUILDTYPE=Debug"
ECHO 5. THREADS for Test Execution ^-^-^> eg. "NUNIT=2", default is "NUNIT=2"
goto:EOF