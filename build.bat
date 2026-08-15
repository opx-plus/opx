@echo off
setlocal

set "CMD=%~1"
if "%CMD%"=="" set "CMD=run"

if /i "%CMD%"=="run"  goto :run
if /i "%CMD%"=="test" goto :test

echo Unknown command: %CMD%
echo Usage: build [run^|test]
exit /b 1

:run
fpc -ghl build.pas -dOPX_PROGRAM && build
set "RESULT=%ERRORLEVEL%"
goto :cleanup

:test
fpc -ghl build.pas -dOPX_PROGRAM -dOPX_TESTS -dOPX_TESTS_RUNNER && build
set "RESULT=%ERRORLEVEL%"
goto :cleanup

:cleanup
delp .
exit /b %RESULT%