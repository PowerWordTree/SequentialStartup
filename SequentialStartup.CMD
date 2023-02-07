::顺序启动脚本
::@author FB
::@version 1.02

@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
CD /D "%~dp0"
SET "PATH=%CD%\bin;%CD%\script;%PATH%"

::处理命令行参数
::  参数1: 配置文件
IF EXIST "%~1" (
  SET "CFGFILE=%~1"
) ELSE (
  SET "CFGFILE=%~dpn0.cfg"
)

::开始执行
ECHO ==========  开始执行 !DATE! !TIME! ==========
FOR /F "eol=# tokens=1,* usebackq delims==" %%I IN ("%CFGFILE%") DO (
  CALL Common.CMD TRIM %%I
  SET "VARNAME=!$!"
  CALL Common.CMD TRIM %%J
  SET  "VARDATA=!$!"
  IF /I "!VARNAME!" == "RUN" (
    ECHO ## !DATE! !TIME! 运行: !VARDATA!
    CALL :RUN !VARDATA!
  )
  IF /I "!VARNAME!" == "RUNWAIT" (
    ECHO ## !DATE! !TIME! 运行并等待: !VARDATA!
    CALL :RUNWAIT !VARDATA!
  )
  IF /I "!VARNAME!" == "URL" (
    ECHO ## !DATE! !TIME! 等待网址: !VARDATA!
    CALL :URL "!VARDATA!"
  )
  IF /I "!VARNAME!" == "PORT" (
    ECHO ## !DATE! !TIME! 等待端口: !VARDATA!
    FOR /F "tokens=1,* delims=:" %%A IN ("!VARDATA!") DO CALL :PORT "%%A" "%%B"
  )
  IF /I "!VARNAME!" == "ZOOKEEPER" (
    ECHO ## !DATE! !TIME! 等待Zookeeper: !VARDATA!
    FOR /F "tokens=1,* delims=:" %%A IN ("!VARDATA!") DO CALL :ZOOKEEPER "%%A" "%%B"
  )
  IF /I "!VARNAME!" == "SLEEP" (
    ECHO ## !DATE! !TIME! 等待: !VARDATA!秒
    CALL Common.CMD SLEEP !VARDATA!
  )
  IF /I "!VARNAME!" == "ECHO" (
    ECHO.!VARDATA!
  )
)

::执行结束
ECHO ==========  执行结束 !DATE! !TIME! ==========
GOTO :EOF

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::执行命令
::  参数1: 命令
:RUNWAIT
CALL Common.CMD GET_PATH "%~1"
START "!VARDATA!" /WAIT /D "!$!" %*
GOTO :EOF

::执行命令并等待
::  参数1: 命令
:RUN
CALL Common.CMD GET_PATH "%~1"
START "!VARDATA!" /D "!$!" %*
GOTO :EOF

::等待网址
::  参数1: 网址
:URL
FOR /F "tokens=*" %%I IN ('curl -I -m 10 -o NUL -s -w %%{http_code} "%~1"') DO (
  IF NOT "%%I" == "200" IF NOT "%%I" == "302" (
	CALL Common.CMD SLEEP 3
    GOTO :URL
  )
)
GOTO :EOF

::等待端口
::  参数1: 地址
::  参数2: 端口
:PORT
nc.exe -z "%~1" "%~2" 1>NUL 2>&1
IF "%ERRORLEVEL%" == "0" GOTO :EOF
CHOICE /T 3 /D Y 1>NUL 2>&1
GOTO :PORT

::等待Zookeeper
::  参数1: 地址
::  参数2: 端口
:ZOOKEEPER
ECHO stat | nc.exe "%~1" "%~2" | find /I "Zookeeper" 1>NUL 2>&1
IF "%ERRORLEVEL%" == "0" GOTO :EOF
CHOICE /T 3 /D Y 1>NUL 2>&1
GOTO :ZOOKEEPER

