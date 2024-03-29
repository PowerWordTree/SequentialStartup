::通用子程序
::@author FB
::@version 0.1

@ECHO OFF
CALL :%*
GOTO :EOF

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::去首尾空格
::  参数*: 目标字符串
::  返回$: 处理后的字符串
:TRIM
SET "$=%*"
GOTO :EOF

::获取完整路径
::  参数1: 目标路径
::  返回$: 完整路径
:FULL_PATH
SET "$=%~f1"
GOTO :EOF

::截取文件路径
::  参数1: 文件路径
::  返回$: 所在路径
:GET_PATH
SET "$=%~dp1"
GOTO :EOF


::获取字符串长度
::  参数1: 字符串
::  返回$: 长度
:GET_SIZE
SET "$STR=%~1#"
SET "$=0"
FOR %%I IN (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) DO (
  IF NOT "!$STR:~%%I,1!" == "" (
    SET /A "$+=%%I"
    SET "$STR=!$STR:~%%I!"
  )
)
SET "$STR="
GOTO :EOF

::判断字符串是否以指定字符串结尾
::  参数1: 目标字符串
::  参数2: 指定字符串
::  返回$: TRUE/FALSE
:END_WITH
SET "$STR=%~1"
CALL :GET_SIZE "%~2"
IF /I "!$STR:~-%$%!" == "%~2" (
  SET "$=TRUE"
) ELSE (
  SET "$=FALSE"
)
SET "$STR="
GOTO :EOF

::延迟
::  参数1: 时间(秒)
:SLEEP
SET /A "$=%~1 + 0"
CHOICE /T "%$%" /D "Y" 1>NUL 2>NUL 
GOTO :EOF
