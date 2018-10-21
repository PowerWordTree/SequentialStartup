::顺序启动脚本
::@author FB
::@version 1.00

@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
CD /D "%~dp0"

::处理命令行参数
::  参数1: 配置文件
IF EXIST "%~1" (
  SET "CFGFILE=%~1"
) ELSE (
  SET "CFGFILE=%~dpn0.cfg"
)

::开始执行
CALL :ECHO "==========  开始执行 " " =========="
FOR /F "eol=# tokens=1,* delims== usebackq" %%I IN ("%CFGFILE%") DO (
  CALL :TRIM "VARNAME" "%%I"
  CALL :TRIM "VARDATA" "%%J"
  IF /I "!VARNAME!" == "RUN" (
    CALL :ECHO "##" "运行命令: !VARDATA!"
    CALL :GET_PATH "RUN_PATH" "!VARDATA!"
    START "!VARDATA!" /D "!RUN_PATH!" !VARDATA!
    SET "RUN_PATH="
  )
  IF /I "!VARNAME!" == "URL" (
    CALL :ECHO "##" "检测网址: !VARDATA!"
    CALL :CHECK_URL "!VARDATA!"
  )
  IF /I "!VARNAME!" == "SLEEP" (
    CALL :ECHO "##" "等待时间: !VARDATA!"
    CALL :SLEEP !VARDATA!
  )
)

::执行结束
CALL :ECHO "==========  执行结束 " " =========="
GOTO :EOF


::检查网址
::  参数1: 网址
:CHECK_URL
FOR /F "tokens=*" %%I IN ('curl -I -m 10 -o NUL -s -w %%{http_code} "%~1"') DO (
  IF NOT "%%I" == "200" IF NOT "%%I" == "302" (
	CALL :SLEEP 3
    GOTO :CHECK_URL
  )
)
GOTO :EOF

::延迟
::  参数1: 时间(秒)
:SLEEP
IF "%~1" == "" GOTO :EOF
CHOICE /T "%~1" /D "Y" 1>NUL 2>NUL 
SET "SLEEPPARAM="
GOTO :EOF

::包含时间的输出
::  参数1: 前缀文字
::  参数2: 后缀文字
:ECHO
@ECHO %~1 %DATE% %TIME% %~2
GOTO :EOF

::去空格
::  参数1: 输出到变量名
::  参数2: 目标字符串
:TRIM
SET "TRIMSTR=%~2"
:TRIMLEFT
IF "%TRIMSTR:~0,1%" == " " (
  SET "TRIMSTR=%TRIMSTR:~1%"
  GOTO :TRIMLEFT
)
:TRIMRIGHT
IF "%TRIMSTR:~-1%" == " " (
  SET "TRIMSTR=%TRIMSTR:~0,-1%"
  GOTO :TRIMLEFT
)
SET "%~1=%TRIMSTR%"
SET "TRIMSTR="
GOTO :EOF

::截取文件路径
::  参数1: 保存到变量名
::  参数2: 完整文件路径
:GET_PATH
SET "%~1=%~dp2"
GOTO :EOF
