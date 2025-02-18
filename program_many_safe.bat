@ REM ######################################
@ REM # Variable to ignore <CR> in DOS
@ REM # line endings
@ set SHELLOPTS=igncr

@ REM ######################################
@ REM # Variable to ignore mixed paths
@ REM # i.e. G:/$SOPC_KIT_NIOS2/bin
@ set CYGWIN=nodosfilewarning

@ set QUARTUS_BIN=%QUARTUS_ROOTDIR%\bin
@ if not exist "%QUARTUS_BIN%" set QUARTUS_BIN=%QUARTUS_ROOTDIR%\bin64


:START
%QUARTUS_BIN%\quartus_pgm.exe -m jtag -c 1 -o "p;safe.pof"
@ set SOPC_BUILDER_PATH=%SOPC_KIT_NIOS2%+%SOPC_BUILDER_PATH%


@ REM Pause execution and ask user if they want to continue
set /p USER_INPUT=Enter 'n' to stop. Enter anything else to continue: 

@ REM Check if user input is "n" to exit loop
if /I "%USER_INPUT%"=="n" goto END
if /I "%USER_INPUT%"=="N" goto END

@ REM If not "n", repeat the process
goto START

:END
@ REM End of script
echo Exiting...

