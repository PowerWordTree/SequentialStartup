@ECHO OFF

:LOOP
ECHO stat | nc.exe 127.0.0.1 2181 | find "Zookeeper" 1>NUL 2>&1
IF "%ERRORLEVEL%" == "0" GOTO :EOF
CHOICE /T 3 /D Y 1>NUL 2>&1
GOTO :LOOP
