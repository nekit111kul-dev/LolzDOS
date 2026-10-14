@ECHO OFF
IF "%1"=="" GOTO USAGE
ECHO %1> C:\NET_URL.TMP
ECHO Opening %1 ...
GOTO END
:USAGE
ECHO Usage: NET address     e.g.  NET google.com
:END
