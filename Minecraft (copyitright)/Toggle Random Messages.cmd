@ECHO OFF

"%SystemRoot%\System32\MODE" CON COLS=80 LINES=25>NUL 2>&1

PUSHD "%~dp0"



SET TITLEHEADER=copyitright's Updatable Minecraft Launcher
SET SCRIPT_VERSION=20022021-0426
SET "BODYHEADER=%TITLEHEADER% ^| 2o11 ~ 2o21 ^| Build %SCRIPT_VERSION%"

TITLE %BODYHEADER%



FOR %%a in ("%CD%") do SET DIR=%%~na

IF /I NOT "%DIR%"=="Minecraft (copyitright)" (

  TITLE Wrong folder! ^| %BODYHEADER%

  echo.
  ECHO  Please run the script from the following (sub^)folder:
  echo.
  echo.
  ECHO  Minecraft (copyitright^)
  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  ECHO  (Press any key to quit^)
  PAUSE>NUL|SET /P =
  EXIT

)



SET WEBSITE=https://www.playfreeminecraft.nl
SET DISCORD_SHORT=https://discord.gg/4xHvdYG

SET SERVER_URLS_1= Website: %WEBSITE:~8%    Server: join.%WEBSITE:~12%:25565
SET SERVER_URLS_2=  Chat/Support: %DISCORD_SHORT:~8%    Backup: the.minecraftnoob.com:25565
SET SPACER=------------------------------------------------------------------------------
SET QUIT=(Press any key to quit)



IF /I NOT "%~nx0"=="Toggle Random Messages.cmd" (
  SET OBJECT=SCRIPT "Toggle Random Messages.cmd"
  goto NOTFOUND
)

IF NOT EXIST "Minecraft Launcher.cmd" (
  SET OBJECT=SCRIPT "Minecraft Launcher.cmd"
  goto NOTFOUND
)



"Minecraft Launcher.cmd" -toggle_rnd



:NOTFOUND
TITLE Not found! ^| %BODYHEADER%
echo.
ECHO  %BODYHEADER%
ECHO  %SPACER%
ECHO  %SERVER_URLS_1%
ECHO  %SERVER_URLS_2%
ECHO  %SPACER%
echo.
echo.
echo.
echo.
echo.
ECHO  THE %OBJECT% COULD NOT BE FOUND!
echo.
echo.
echo.
echo.
ECHO  Make sure you haven't (re)moved or renamed it
echo.
echo.
echo.
echo.
echo.
echo.
ECHO  %QUIT%
PAUSE>NUL|SET /P =
EXIT
