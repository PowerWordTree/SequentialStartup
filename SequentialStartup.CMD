::˳�������ű�
::@author FB
::@version 1.00

@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
CD /D "%~dp0"

::���������в���
::  ����1: �����ļ�
IF EXIST "%~1" (
  SET "CFGFILE=%~1"
) ELSE (
  SET "CFGFILE=%~dpn0.cfg"
)

::��ʼִ��
CALL :ECHO "==========  ��ʼִ�� " " =========="
FOR /F "eol=# tokens=1,* delims== usebackq" %%I IN ("%CFGFILE%") DO (
  CALL :TRIM "VARNAME" "%%I"
  CALL :TRIM "VARDATA" "%%J"
  IF /I "!VARNAME!" == "RUN" (
    CALL :ECHO "##" "��������: !VARDATA!"
    CALL :GET_PATH "RUN_PATH" "!VARDATA!"
    START "!VARDATA!" /D "!RUN_PATH!" !VARDATA!
    SET "RUN_PATH="
  )
  IF /I "!VARNAME!" == "URL" (
    CALL :ECHO "##" "�����ַ: !VARDATA!"
    CALL :CHECK_URL "!VARDATA!"
  )
  IF /I "!VARNAME!" == "SLEEP" (
    CALL :ECHO "##" "�ȴ�ʱ��: !VARDATA!"
    CALL :SLEEP !VARDATA!
  )
)

::ִ�н���
CALL :ECHO "==========  ִ�н��� " " =========="
GOTO :EOF


::�����ַ(ʹ��curl.exe)
::  ����1: ��ַ
:CHECK_URL
FOR /F "tokens=*" %%I IN ('curl -I -m 10 -o NUL -s -w %%{http_code} "%~1"') DO (
  IF NOT "%%I" == "200" IF NOT "%%I" == "302" (
	CALL :SLEEP 3
    GOTO :CHECK_URL
  )
)
GOTO :EOF

::�ӳ�
::  ����1: ʱ��(��)
:SLEEP
IF "%~1" == "" GOTO :EOF
CHOICE /T "%~1" /D "Y" 1>NUL 2>NUL 
SET "SLEEPPARAM="
GOTO :EOF

::����ʱ������
::  ����1: ǰ׺����
::  ����2: ��׺����
:ECHO
@ECHO %~1 %DATE% %TIME% %~2
GOTO :EOF

::ȥ�ո�
::  ����1: �����������
::  ����2: Ŀ���ַ���
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

::��ȡ�ļ�·��
::  ����1: ���浽������
::  ����2: �����ļ�·��
:GET_PATH
SET "%~1=%~dp2"
GOTO :EOF