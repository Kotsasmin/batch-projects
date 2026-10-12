@ECHO OFF

"%SystemRoot%\System32\MODE" CON COLS=80 LINES=25>NUL 2>&1

SET "LAUNCHER_DP0=%~dp0"

PUSHD "%LAUNCHER_DP0%"



SET TITLEHEADER=copyitright's Updatable Minecraft Launcher
SET SCRIPT_VERSION=20022021-0426

TITLE %TITLEHEADER% ^| %SCRIPT_VERSION%



SET "APPDIR=Minecraft (copyitright)"

FOR %%a in ("%CD%") do SET DIR=%%~na

IF /I NOT "%DIR%"=="%APPDIR%" (

  TITLE Wrong folder! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

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



SET "SYSDIR=%SystemRoot%\System32"

CALL :PATH_CHECK



SET "TIJD=%TIME: =%"

SET "TEMPDIR=%PROGRAMDATA%\%APPDIR%"

SET AUTH_CONFIG=auth_conf.cir
SET "CRASH_FILE=%AUTH_CONFIG:~,-3%txt"

ATTRIB -R -S -H "%AUTH_CONFIG:~,-3%*">NUL 2>&1



CALL :INIT_VARS



SETLOCAL EnableExtensions EnableDelayedExpansion

SET WEBSITE=https://www.playfreeminecraft.nl
SET DISCORD_SHORT=https://discord.gg/4xHvdYG

SET BODYHEADER=%TITLEHEADER% ^| 2o11 ~ 2o21 ^| Build %SCRIPT_VERSION%
SET SERVER_URLS_1= Website: !WEBSITE:~8!    Server: join.!WEBSITE:~12!:25565
SET SERVER_URLS_2=  Chat/Support: !DISCORD_SHORT:~8!    Backup: the.minecraftnoob.com:25565
SET SPACER=------------------------------------------------------------------------------

SET UPDATE_INFO=*** NEW LAUNCHER FOUND^^! ENABLE UPDATE NOTIFICATIONS TO UPDATE LAUNCHER ***
SET UPDATE_INFO_ERR=*** UNABLE TO RETRIEVE UPDATE INFORMATION ***

SET PROBLEM=If the problem persists, visit my website for info or message me on Discord

SET ANYKEY=(Press any key
SET PLAY=!ANYKEY! to start OFFICIAL Minecraft launcher)
SET CONTINUE=!ANYKEY! to continue)
SET QUIT=!ANYKEY! to quit)

SET ADDED=PLAYER ADDED^^!
SET RETRY=TRY AGAIN^^!

SET LAUNCHER=Minecraft.exe

SET LAUNCHER_CONFIG=firstrun
SET MESSAGES=messages

SET CRL=exe\curl.exe
SET JQ=exe\jq-win32.exe
SET NZP=exe\unzip.exe

SET "GAMEDIR=!USER_APPDATA!\.minecraft"

SET "ACCOUNTS=!GAMEDIR!\launcher_accounts.json"
SET "PROFILES=!GAMEDIR!\launcher_profiles.json"
SET "SETTINGS=!GAMEDIR!\launcher_settings.json"

SET "PROFILE_ENTRY=added by copyitright's launcher | don't modify | !WEBSITE:~8!"
SET PROFILES_COUNT=0

SET DEFAULT_UUID=00000000000000000000000000000000
SET MY_RESOURCE_PACK=.minecraft\resourcepacks\copyitright.zip

SET LAUNCHER_URL=https://is.gd/Minecraft_exe
SET LAUNCHER_ALT=https://launcher.mojang.com/download/%LAUNCHER%

SET NOTE=NOTE: Enable update notifications to keep track of important changes

SET "HOSTS=!SYSDIR!\drivers\etc\HOSTS"

SET AUTH_SERVER=authserver.mojang.com

SET TLS_VERSION=1.3

SET TIMEOUT=3
SET TIMER=10

SET TAG=Other

SET LF=^



ATTRIB -R -S -H "%LAUNCHER_CONFIG%">NUL 2>&1
ATTRIB -R -S -H "!SETTINGS!">NUL 2>&1
ATTRIB -R -S -H "!USER_APPDATA!\launcher_*.json">NUL 2>&1
ATTRIB -R -S -H "WhatsNew*">NUL 2>&1



CALL :CLEAN_TEMPDIR



IF /I "%1"=="-change_colors" SET TAG=changeCLR
IF /I "%1"=="-colors" (goto COLORS) ELSE (CALL :COLORS)



IF /I NOT "%~nx0"=="Minecraft Launcher.cmd" (

  SET OBJECT=SCRIPT "Minecraft Launcher.cmd"
  goto NOTFOUND

)

IF NOT EXIST "%CRL%" (

  SET OBJECT=APPLICATION "%CRL%"
  goto NOTFOUND

)

IF NOT EXIST "%JQ%" (

  SET OBJECT=APPLICATION "%JQ%"
  goto NOTFOUND

)

IF NOT EXIST "%NZP%" (

  SET OBJECT=APPLICATION "%NZP%"
  goto NOTFOUND

)



IF NOT EXIST "!USER_APPDATA!\.minecraft\" (

  ATTRIB -R -S -H "!USER_APPDATA!\.minecraft">NUL 2>&1
  DEL /A /F /Q "!USER_APPDATA!\.minecraft">NUL 2>&1

  IF EXIST "!USER_APPDATA!\.minecraft" (
    SET LABEL=NO WRITE ACCESS
    goto ERROR
  )

  2>NUL MD "!USER_APPDATA!\.minecraft"

)



ECHO "!CD!" | FIND /I "!USER_APPDATA!\.minecraft">NUL

IF !ERRORLEVEL! EQU 0 goto WRONG_FOLDER



IF "%1"=="" SET TAG=Normal

IF /I "%1"=="-add_player" SET TAG=addPlayer
IF /I "%1"=="-toggle_autoupdate" SET TAG=toggleAutoUp
IF /I "%1"=="-toggle_nag" SET TAG=toggleNag
IF /I "%1"=="-toggle_rnd" SET TAG=toggleRND
IF /I "%1"=="-update_launcher" SET TAG=Update
IF /I "%1"=="-updated_launcher" SET TAG=Updated
IF /I "%1"=="-uninstall_launcher" SET TAG=Uninstall



IF /I "%TAG%"=="Updated" (

  SET "REMOTE_VER=%SCRIPT_VERSION%"

  SET "CLRS= "

  TITLE Success^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

  CALL :HEADER

  echo.
  echo.
  echo.
  echo.
  echo.
  ECHO  LAUNCHER UPDATED
  echo.
  echo.
  echo.
  echo.
  ECHO  The launcher files were updated to build %SCRIPT_VERSION%
  ECHO  Keep track of this version when reporting any problems
  echo.
  echo.
  echo.
  echo.
  echo.
  ECHO  !CONTINUE!
  PAUSE>NUL|SET /P =

)



IF NOT EXIST WhatsNew.htm CALL :RESET_CHANGELOG



IF /I "%TAG%"=="addPlayer" goto NEW_USER
IF /I "%TAG%"=="toggleAutoUp" goto TOGGLE_AU
IF /I "%TAG%"=="toggleNag" goto TOGGLE_NAG
IF /I "%TAG%"=="toggleRND" goto TOGGLE_RND
IF /I "%TAG%"=="Uninstall" goto UNINSTALL



:START
CLS

echo.
ECHO  Please wait...

IF /I NOT "%TAG%"=="Updated" (

  IF /I "%UN%"=="YES" CALL :CHECK_UPDATES
  IF /I "%AU%"=="YES" (IF /I "%UN%"=="NO" CALL :CHECK_UPDATES)



  SET UPDATE_HOST=https://update.minecraftlauncher.nl

  CALL :CHECK_UPDATE_HOST

  IF DEFINED CHANGELOG_URL (IF DEFINED CHANGELOG_ALT goto NEXT)



  SET UPDATE_HOST=http://update.minecraftnoob.com

  CALL :CHECK_UPDATE_HOST

)



:NEXT
FOR /F %%U in ('%CRL% --connect-timeout !TIMEOUT! -f -k -L -s -w %%{url_effective} -o NUL !UPDATE_HOST! 2^>NUL') do SET TARGET_URL=%%U

IF /I NOT "%TAG%"=="Updated" (

  ATTRIB -R -S -H WhatsNew.htm.bak>NUL 2>&1
  DEL /A /F /Q WhatsNew.htm.bak>NUL 2>&1
  REN WhatsNew.htm WhatsNew.htm.bak>NUL 2>&1

  "%CRL%" --connect-timeout !TIMEOUT! -f -k -s -L "!CHANGELOG_URL!">WhatsNew.htm 2>NUL

  CALL :CHECK_CHANGELOG

  IF NOT EXIST WhatsNew.htm (

    "%CRL%" --connect-timeout !TIMEOUT! -f -k -s -L "!CHANGELOG_ALT!/WhatsNew.htm">WhatsNew.htm 2>NUL

    CALL :CHECK_CHANGELOG

  )

)



IF NOT EXIST WhatsNew.htm (

  REN WhatsNew.htm.bak WhatsNew.htm>NUL 2>&1

  IF NOT EXIST WhatsNew.htm CALL :RESET_CHANGELOG

  IF "%UN%"=="NO" (

    IF /I NOT "%TAG%"=="Update" goto WELCOME

  ) ELSE (

    SET "UPDATE_INFO="

  )

  goto NO_UPDATE_INFO

)

ATTRIB -R -S -H WhatsNew.htm.bak>NUL 2>&1
DEL /A /F /Q WhatsNew.htm.bak>NUL 2>&1



IF "%SCRIPT_VERSION%"=="%REMOTE_VER%" (

  SET "UPDATE_INFO="

  IF /I "%TAG%"=="Update" goto NO_UPDATES

  goto WELCOME

)

IF "%UN%"=="NO" (

  IF /I "%AU%"=="YES" goto UPDATE_LAUNCHER

  IF /I NOT "%TAG%"=="Update" goto WELCOME

)

IF /I "%AU%"=="YES" goto UPDATE_LAUNCHER

IF DEFINED REMOTE_VER goto FOUND_UPDATE



:NO_UPDATE_INFO
TITLE No update info^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.

IF !ERRORLEVEL! NEQ 0 SET ERROR=(ERROR #!ERRORLEVEL!)

ECHO  !UPDATE_INFO_ERR:~4,-4! !ERROR!

echo.
echo.
ECHO  Possible reasons:
echo.
ECHO  - I'm preparing and/or live-testing a new launcher update
ECHO  - There's a problem with the (remote^) internet connection
ECHO  - Server is under maintenance or it's address has changed
ECHO  - Your launcher is too old and has to be updated manually
echo.
ECHO  !PROBLEM!
echo.
echo.
echo.
ECHO  !CONTINUE!
PAUSE>NUL|SET /P =

SET "UPDATE_INFO="

goto WELCOME



:NO_UPDATES
TITLE No update found ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  YOU ARE USING THE LATEST VERSION
echo.
echo.
echo.
echo.

IF "%UN%"=="YES" (echo.) ELSE (ECHO  !NOTE!)

echo.
echo.
ECHO  However, if you (for whatever reason) want to update to the SAME version,
ECHO  you may do so by typing YES in all uppercase, or leaving it blank to SKIP
echo.
echo.

SET /P "UPDATE=Confirm your choice: "

IF "!UPDATE!"=="" (

  SET "TAG=No Updates"

  goto WELCOME

)

IF "!UPDATE!"=="YES" (

  SET TAG=Redo Update

  SET SCRIPT_VERSION=UPDATETO-SAME

  goto UPDATE_LAUNCHER

)

SET "UPDATE="

goto NO_UPDATES



:FOUND_UPDATE
TITLE Update found ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  *** NEW LAUNCHER VERSION AVAILABLE ***
echo.
echo.
ECHO      VERSION FORMAT   DDMMYYYY HHMM
ECHO    Installed version: %SCRIPT_VERSION%
ECHO    Available version: %REMOTE_VER% (new)
echo.
echo.
ECHO  To review the changes, type 'Y' followed by Enter (leave blank to update)
echo.

SET /P UPDATE=Your choice: 

IF /I "!UPDATE!"=="y" (

  IF NOT EXIST WhatsNew.htm CALL :RESET_CHANGELOG

  START "" WhatsNew.htm

  echo.
  ECHO  !ANYKEY! to update the launcher^)
  PAUSE>NUL|SET /P =

) ELSE (

  IF "!UPDATE!"=="" (

    IF NOT EXIST WhatsNew.htm CALL :RESET_CHANGELOG

  ) ELSE (

    SET "UPDATE="

    goto FOUND_UPDATE

  )

)

goto UPDATE_LAUNCHER



:WELCOME
IF DEFINED CLRS (

  SET "CLRS="

  TITLE Welcome ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

  CALL :HEADER

  echo.
  echo.
  echo.
  ECHO              Hello and thanks for using my Minecraft launcher^^! :-^)
  ECHO               I hope that you will have a blast playing Minecraft
  echo.
  ECHO          If you experience problems with my launcher, make sure you've
  ECHO        followed the instructions carefully, your system meets the game's
  ECHO      requirements, and the launcher/scripts aren't blocked by any programs
  echo.
  ECHO     If you think the problem is related to my launcher and you're using the
  ECHO       latest version, visit my website for info, or message me on Discord
  echo.

  IF "%UN%"=="NO" (

    IF DEFINED UPDATE_INFO (

      ECHO    !UPDATE_INFO!

    ) ELSE (

      ECHO    !NOTE!

    )

  ) ELSE (

    echo.

  )

  echo.
  echo.
  ECHO                               -HaPPy MiNeCRaFTiNG-
  ECHO                                   copyitright
  PAUSE>NUL|SET /P =

  CALL :FIRST_NOTICE
  CALL :REGFIX_CHECK

)



CALL :CHECK_BLOCK_STATE
CALL :CHECK_LAUNCHER_FILE



IF DEFINED PITSTOP goto CONTINUE



IF /I "%BLOCK_STATE%"=="BLOCK" IF "!DATA!"=="" goto EMPTY_FILE_NOTICE



IF /I "%ACCOUNT_STATE%"=="CRACKED" (

  IF /I NOT "%BLOCK_STATE%"=="BLOCK" goto WRONG_STATE

) ELSE (

  IF /I "%ACCOUNT_STATE%"=="LEGITIMATE" (

    IF /I "%BLOCK_STATE%"=="BLOCK" goto WRONG_STATE
    IF "%BLOCK_STATE%"=="" goto WRONG_STATE

  ) ELSE (

    IF /I "%ACCOUNT_STATE%"=="UNSELECTED" goto WRONG_STATE

    IF "%BLOCK_STATE%"=="" goto WRONG_STATE

  )

)



IF /I "%BLOCK_STATE%"=="BLOCK" (

  CALL :CHECK_CRACKED_USERS

  IF "!COMPARE!"=="" (

    SET "oops="
    SET PROFILES_COUNT=0

    goto NEW_USER

  )

)



:CONTINUE
CALL :LAUNCHER_PROFILES_FOOTER
CALL :COPY_SERVERLIST
CALL :RESOURCE_PACK



IF EXIST "%LAUNCHER%" goto LAUNCH



TITLE Downloading... ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
echo.
ECHO  DOWNLOADING OFFICIAL MINECRAFT LAUNCHER
echo.

"%CRL%" --connect-timeout !TIMEOUT! --progress-bar -f -k -L "!LAUNCHER_URL!" -o "%LAUNCHER%"

IF !ERRORLEVEL! NEQ 0 (

  SET "ERR=!ERRORLEVEL!"
  SET "FAIL= "

  DEL /A /F /Q "%LAUNCHER%">NUL 2>&1

)

IF NOT EXIST "%LAUNCHER%" (

  "%CRL%" --connect-timeout !TIMEOUT! --progress-bar -f -k -L -O "!LAUNCHER_ALT!"

  IF !ERRORLEVEL! NEQ 0 (

    SET "ERR=!ERRORLEVEL!"

    DEL /A /F /Q "%LAUNCHER%">NUL 2>&1

  )

)

IF NOT EXIST "%LAUNCHER%" (

  TITLE Download failed^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

  CALL :HEADER

  echo.
  echo.
  echo.
  echo.
  echo.
  ECHO  OFFICIAL LAUNCHER COULD NOT BE DOWNLOADED (ERROR #!ERR!^)
  echo.
  echo.
  echo.
  ECHO  Make sure you are connected to the internet and the server is reachable
  echo.
  ECHO  !PROBLEM!
  echo.
  echo.
  echo.
  echo.
  echo.
  ECHO  !QUIT!
  PAUSE>NUL|SET /P =
  EXIT

) ELSE (

  TITLE Victory^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%
  echo.
  ECHO  SUCCESSFULLY DOWNLOADED OFFICIAL LAUNCHER
  echo.
  echo.

  IF DEFINED FAIL (

    echo.
    echo.

  ) ELSE (

    echo.
    echo.
    echo.
    echo.

  )

  ECHO  !PLAY!
  PAUSE>NUL|SET /P =

)

goto LAUNCH



:UPDATE_LAUNCHER
IF NOT EXIST "%CRL%" (
  SET OBJECT=APPLICATION "%CRL%"
  goto NOTFOUND
)

IF NOT EXIST "%NZP%" (
  SET OBJECT=APPLICATION "%NZP%"
  goto NOTFOUND
)

2>NUL MD "!TEMPDIR!\exe"

TITLE Contacting update server... ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

"%CRL%" --connect-timeout !TIMEOUT! -f -k -s -L "!CHANGELOG_ALT!/mcl-%REMOTE_VER%%DEBUG%.exe">"!TEMPDIR!\mcl-%REMOTE_VER%%DEBUG%.cmd" 2>NUL

IF EXIST "!TEMPDIR!\mcl-%REMOTE_VER%%DEBUG%.cmd" (

  SET /P CONTENTS_CHECK=<"!TEMPDIR!\mcl-%REMOTE_VER%%DEBUG%.cmd"

  IF "!CONTENTS_CHECK:~,1!"=="<" (

    CD.>"!TEMPDIR!\mcl-%REMOTE_VER%%DEBUG%.cmd" 2>NUL
    DEL /A /F /Q "!TEMPDIR!\mcl-%REMOTE_VER%%DEBUG%.cmd">NUL 2>&1

  )

)

IF NOT EXIST "!TEMPDIR!\mcl-%REMOTE_VER%%DEBUG%.cmd" (

  TITLE Update failed^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

  CALL :HEADER

  echo.
  echo.
  echo.
  echo.
  echo.
  ECHO  UPDATE SCRIPT COULD NOT BE DOWNLOADED
  echo.
  echo.
  echo.
  ECHO  Make sure you are connected to the internet and the server is reachable
  echo.
  ECHO  !PROBLEM!
  echo.
  echo.
  echo.
  echo.
  echo.
  ECHO  !QUIT!
  PAUSE>NUL|SET /P =
  EXIT

)

ATTRIB +R +S +H "!TEMPDIR!\mcl-%REMOTE_VER%%DEBUG%.cmd">NUL 2>&1

"!TEMPDIR!\mcl-%REMOTE_VER%%DEBUG%.cmd"

EXIT



:LAUNCH
IF NOT EXIST "%LAUNCHER%" goto LAUNCHER_MISSING

TITLE Get Ready..^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CLS

echo.
ECHO  Get Ready..^^!

"!COMSPEC!" /C START "" "%LAUNCHER%" --workdir "!USER_APPDATA!\.minecraft"



IF DEFINED UPDATE_INFO (

  echo.
  ECHO    !UPDATE_INFO!

)



CALL :CHECK_LOCALE



:AGAIN
IF /I "%TAG%"=="Updated" (

  IF /I "!LANG!"=="E" SET "MSG=Thank you for updating to my latest launcher version^! :^)"
  IF /I "!LANG!"=="N" SET "MSG=Bedankt om naar m'n nieuwste launcher versie te updaten^! :^)"

  CALL :WRITE_STATS
  CALL :POST_STATS

  goto COUNTDOWN

)

IF "%RM%"=="YES" (

  CALL :RANDOM_MESSAGE

  IF DEFINED NOPE goto USER_FEEDBACK

) ELSE (

  SET "TIMER=5"

  CALL :WRITE_STATS
  CALL :POST_STATS

  goto COUNTDOWN

)



:USER_FEEDBACK
SET "NOPE="

IF /I "%RM%"=="YES" (

  IF "!MSG:~,1!"==" " (

    IF "%EP%"=="NO" (

      SET "NOPE= "
      SET "MSG="

      goto AGAIN

    )

    SET TIMER=5

    SET "MSG=!MSG:~1!"

    SET "POLL= (poll)"

    CALL :WRITE_STATS
    CALL :POST_STATS

    CALL :SHOW_MESSAGE

    echo.
    echo.

    SET "TIME=!TIME: =!"

    IF /I "!LANG!"=="E" SET /P "FEEDBACK=Your answer: "
    IF /I "!LANG!"=="N" SET /P "FEEDBACK=Je antwoord: "

    IF "!FEEDBACK!"=="" (

      SET "MSG="

      goto COUNTDOWN

    )

    SET "QUESTION=!MSG!"
    SET "MSG=Thank you for your feedback^! :)"

    SET "TXT=!TXT!!POLL!"

    2>NUL MD "!TEMPDIR!"

    ECHO.>"!TXT!.txt" 2>NUL
    ECHO  -Question asked on !DATE! at !TIME!->>"!TXT!.txt" 2>NUL
    ECHO.>>"!TXT!.txt" 2>NUL
    ECHO    Q: !QUESTION!>>"!TXT!.txt" 2>NUL
    ECHO.>>"!TXT!.txt" 2>NUL
    ECHO    A: !FEEDBACK!>>"!TXT!.txt" 2>NUL
    ECHO.>>"!TXT!.txt" 2>NUL

    SET "TIME="
    SET "TIME=!TIME: =!"

    ECHO  -User responded on !DATE! at !TIME!->>"!TXT!.txt" 2>NUL

    ECHO.>>"!TXT!.txt" 2>NUL
    ECHO.>>"!TXT!.txt" 2>NUL
    ECHO.>>"!TXT!.txt" 2>NUL

    CALL :QUICK_STATS
    CALL :POST_STATS

  ) ELSE (

    IF "!MSG:~,1!"=="*" (

      SET TIMER=5

      IF /I "!LANG!"=="E" SET "AUTO-SKIP=(will auto-skip after 5 seconds)"
      IF /I "!LANG!"=="N" SET "AUTO-SKIP=(gaat na 5 seconden vanzelf verder)"

      IF "%EP%"=="YES" (

        IF /I "!LANG!"=="E" (

          SET "MSG=Do you want to disable feedback questions? !AUTO-SKIP!"

          CALL :WRITE_STATS
          CALL :POST_STATS

          CALL :SHOW_MESSAGE

          echo.

          CHOICE /C YN /D N /T 5 /M "Your choice"

          IF !ERRORLEVEL! EQU 1 (

            SET "MSG=Feedback questions are disabled^!"

            SET "EP=NO"

            CALL :SAVE_SETTINGS

          ) ELSE (

            SET "MSG="

          )

        )

        IF /I "!LANG!"=="N" (

          SET "MSG=Wil je feedback vragen uitschakelen? !AUTO-SKIP!"

          CALL :WRITE_STATS
          CALL :POST_STATS

          CALL :SHOW_MESSAGE

          echo.

          CHOICE /C JN /D N /T 5 /M "Je keuze"

          IF !ERRORLEVEL! EQU 1 (

            SET "MSG=Feedback vragen zijn uitgeschakeld^!"

            SET "EP=NO"

            CALL :SAVE_SETTINGS

          ) ELSE (

            SET "MSG="

          )

        )

      ) ELSE (

        IF "%EP%"=="NO" (

          IF /I "!LANG!"=="E" (

            SET "MSG=Do you want to receive feedback questions? !AUTO-SKIP!"

            CALL :WRITE_STATS
            CALL :POST_STATS

            CALL :SHOW_MESSAGE

            echo.

            CHOICE /C YN /D N /T 5 /M "Your choice"

            IF !ERRORLEVEL! EQU 1 (

              SET "MSG=Feedback questions are enabled^!"

              SET "EP=YES"

              CALL :SAVE_SETTINGS

            ) ELSE (

              SET "MSG="

            )

          )

          IF /I "!LANG!"=="N" (

            SET "MSG=Wil je feedback vragen ontvangen? !AUTO-SKIP!"

            CALL :WRITE_STATS
            CALL :POST_STATS

            CALL :SHOW_MESSAGE

            echo.

            CHOICE /C JN /D N /T 5 /M "Je keuze"

            IF !ERRORLEVEL! EQU 1 (

              SET "MSG=Feedback vragen zijn ingeschakeld^!"

              SET "EP=YES"

              CALL :SAVE_SETTINGS

            ) ELSE (

              SET "MSG="

            )

          )

        )

      )

    ) ELSE (

      CALL :WRITE_STATS
      CALL :POST_STATS

    )

  )

)

goto COUNTDOWN



:NEW_USER
CALL :CHECK_BLOCK_STATE

IF /I "%TAG%"=="addPlayer" (

  IF /I NOT "%BLOCK_STATE%"=="BLOCK" goto STATE_NOTICE

)

CALL :CHECK_CRACKED_USERS

IF "!COMPARE!"=="" (

  TITLE New "cracked" user ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

) ELSE (

  TITLE Additional "cracked" user ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

)

SET "name="

CALL :HEADER

echo.
echo.
echo.
echo.
echo.

IF "!COMPARE!"=="" (

  ECHO  NEW "CRACKED" USER (FIRST ENTRY IS SELECTED AS DEFAULT^)

) ELSE (

  ECHO  ADDITIONAL "CRACKED" USER

)

echo.
echo.
echo.
ECHO  Here you can create or add additional "cracked" user entries
ECHO  Alphanumeric and underscores only, and 16 characters in total
echo.
ECHO  Skins? namemc.com (pick some skins and type their names here^)
echo.
echo.
IF DEFINED oops (ECHO  !oops!) ELSE (echo.)
echo.

IF "!COMPARE!"=="" (

  SET /P "name=Enter the name of your Minecraft character: 

) ELSE (

  SET /P "name=Additional Player name (Done? Press Enter): 

)

CALL :CHECK_CRACKED_USERS

IF "!COMPARE!"=="" (

  SET "FOOTER= "
  SET PROFILES_COUNT=0

)

IF "!name!"=="" (

  IF !PROFILES_COUNT! EQU 0 (

    IF "!FOOTER!"=="" goto START

    SET oops=NOTHING ENTERED^^! (-2^)
    SET PROFILES_COUNT=0

    SET "FOOTER="

    goto NEW_USER

  ) ELSE (

    SET "name=!variable1!"

    goto DONE

  )

)



SET "variable1=!name!"
SET "variable2=NEW_USER"

CALL :CHECK_NAME

SET "name=!variable1!"

CALL :CHECK_DUPE_NAME



IF "%DECIDE%"=="" (

  CALL :SKIN_CONFIG

) ELSE (

  IF NOT DEFINED NO_SKINS CALL :CHECK_SKIN

)



CALL :LAUNCHER_PROFILES_USER

SET "variable1=!name!"

goto NEW_USER



:DONE
TITLE Launcher file created^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

SET TEXT=!name!, you

IF !PROFILES_COUNT! EQU 2 SET TEXT=You (and your friend)
IF !PROFILES_COUNT! GTR 2 SET TEXT=You (and your friends)

SET "TRIMMED_APPDATA=!USER_APPDATA!"
SET "TEMP_APPDATA=!USER_APPDATA:~76!"

IF DEFINED TEMP_APPDATA SET "TRIMMED_APPDATA=!USER_APPDATA:~,75!~"

echo.
echo.
echo.
ECHO  LAUNCHER FILE SUCCESSFULLY CREATED
echo.
echo.
ECHO  !TEXT! can now play Minecraft for FREE^^! (please don't pirate)
echo.
ECHO  The '.minecraft' folder can be found at this location (read from '%AUTH_CONFIG:~,-4%'):
ECHO  '!TRIMMED_APPDATA!'
echo.
ECHO  (to delete a SINGLE user: select ACCOUNT in OFFICIAL launcher ^> click LOG OUT)
echo.
ECHO  Are you planning to SWITCH between Minecraft VERSIONS? Prevent GAME crashes:
ECHO  Add seperate GAME DIRECTORIES under "Installations" in the OFFICIAL launcher
echo.
echo.
ECHO  !CONTINUE!
PAUSE>NUL|SET /P =

IF /I "%TAG%"=="addPlayer" goto START

goto WELCOME



:NOTFOUND
TITLE Not found^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  THE !OBJECT! COULD NOT BE FOUND
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
ECHO  !QUIT!
PAUSE>NUL|SET /P =
EXIT



:LAUNCHER_MISSING
TITLE Missing launcher^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  OFFICIAL MINECRAFT LAUNCHER COULD NOT BE FOUND
echo.
echo.
echo.

SET MESSAGE=Restart this program to download the launcher again

IF /I "%UN%"=="YES" (

  ECHO  !MESSAGE!

) ELSE (

  IF /I "%TAG%"=="Updated" (

    ECHO  !MESSAGE!

  ) ELSE (

    IF /I "%TAG%"=="No Updates" (

      ECHO  !MESSAGE!

    ) ELSE (

      ECHO  Try to update this launcher using the 'Update Launcher' shortcut

    )

  )

)

echo.
ECHO  !PROBLEM!
echo.
echo.
echo.
echo.
echo.
ECHO  !QUIT!
PAUSE>NUL|SET /P =
EXIT



:FIRST_NOTICE
TITLE First-time Notice^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  FIRST-TIME NOTICE
echo.
echo.
echo.
ECHO  It is ONCE AGAIN required to *BLOCK* the auth server if you're a "CRACKED"
ECHO  Minecraft user. This due to Microsoft hardening its authentication security
echo.
ECHO  Prevent unexpected issues (also with '%AUTH_CONFIG:~,-4%'), and use my launcher to
ECHO  start the game, as it will perform some checks to ensure everything's okay
echo.
echo.
echo.
ECHO  !CONTINUE!
PAUSE>NUL|SET /P =

goto :EOF



:EMPTY_FILE_NOTICE
TITLE Empty file Notice^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  LAUNCHER FILE EMPTY OR OUTDATED
echo.
echo.
echo.
ECHO  The current launcher file has no (cracked) user entries
ECHO  Perhaps the file is empty or my launcher became outdated
echo.
ECHO  If this message continues to pop up and you're using the
ECHO  latest version of my launcher, please notify me about it
echo.
echo.
echo.
ECHO  !ANYKEY! to add a "cracked" user)
PAUSE>NUL|SET /P =

goto NEW_USER



:RESET_CHANGELOG
ECHO  Dear reader, someone (or something) ^<u^>deleted^</u^> the ^<b^>original^</b^> file^<br^>^<br^>>"WhatsNew.htm" 2>NUL

IF "%UN%"=="YES" (
  ECHO  To get this file back, ^<b^>restart^</b^> or ^<b^>reinstall^</b^> copyitright's ^<u^>launcher^</u^>>>"WhatsNew.htm" 2>NUL
) ELSE (
  ECHO  To get this file back, ^<u^>enable^</u^> update notifications and ^<b^>restart^</b^> the launcher^<br^>>>"WhatsNew.htm" 2>NUL
  ECHO  If that doesn't solve anything, consider ^<b^>reinstalling^</b^> copyitright's ^<u^>launcher^</u^>>>"WhatsNew.htm" 2>NUL
)

ECHO ^<br^>^<br^>>>"WhatsNew.htm" 2>NUL
ECHO ^<font size="1"^>>>"WhatsNew.htm" 2>NUL
ECHO ^<br^> Website: ^<a href="!WEBSITE!"^>!WEBSITE:~8!^</a^>>>"WhatsNew.htm" 2>NUL
ECHO ^<br^> Support: ^<a href="!DISCORD_SHORT!"^>!DISCORD_SHORT:~8!^</a^>>>"WhatsNew.htm" 2>NUL
ECHO ^<br^>>>"WhatsNew.htm" 2>NUL
ECHO ^</font^>>>"WhatsNew.htm" 2>NUL

goto :EOF



:CHECK_CHANGELOG
IF EXIST WhatsNew.htm (

  SET /P REMOTE_VER=<WhatsNew.htm

  IF DEFINED REMOTE_VER (

    SET REMOTE_VER=!REMOTE_VER:~,13!

    SET /A CHECK=!REMOTE_VER:~,1!*1 2>NUL

    IF NOT "!CHECK!"=="!REMOTE_VER:~,1!" (

      SET "REMOTE_VER="
      SET "UPDATE_INFO=!UPDATE_INFO_ERR!"

      DEL /A /F /Q WhatsNew.htm>NUL 2>&1

    )

  ) ELSE (

    SET "UPDATE_INFO=!UPDATE_INFO_ERR!"

    DEL /A /F /Q WhatsNew.htm>NUL 2>&1

  )

)

goto :EOF



:CHECK_NAMELENGTH
(   SETLOCAL ENABLEDELAYEDEXPANSION
    set "str=A!%~1!"
    set "len=0"
    for /L %%A in (12,-1,0) do (
        set /a "len|=1<<%%A"
        for %%B in (!len!) do if "!str:~%%B,1!"=="" set /a "len&=~1<<%%A"
    )
)
( ENDLOCAL
    IF "%~2" NEQ "" SET /a %~2=%len%
)

goto :EOF



:SKIN_CONFIG
TITLE Skin config ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  PLAYER SKIN CONFIGURATION
echo.
echo.
ECHO  You have the choice to look for an online player skin for the given name
ECHO  If successful, your name's case may be changed to match the actual owner
echo.
ECHO  If no skin is visible in-game, it is possible that the legitimate owner
ECHO  hasn't uploaded a skin, uploaded the default skin, or no account exists
echo.
ECHO  NOTE: Type 'N' when considering LOCAL player skins using RESOURCE PACKS
echo.
echo.

SET /P DECIDE=Your choice (Y/N): 

IF /I "!DECIDE!"=="Y" (

  SET DECIDE=Enabled

  CALL :CHECK_SKIN

) ELSE (

  IF /I "!DECIDE!"=="N" (

    SET DECIDE=Disabled

    SET "NO_SKINS= "
    SET UUID=%DEFAULT_UUID%

  ) ELSE (

    SET "DECIDE="

    goto SKIN_CONFIG

  )

)

goto :EOF



:CONFIRM_NAME
TITLE No player skin found^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

SET "NAME_CONFIRM="

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  PLAYER SKIN NOT FOUND
echo.
echo.
echo.
ECHO  Unfortunately, no Minecraft account could be found under the given name
ECHO  You can either continue without a skin, or type a different player name
echo.
ECHO  (keep in mind to press Enter when there is no internet connectivity)
echo.
echo.
IF DEFINED oops (ECHO  !oops!) ELSE (echo.)
echo.

SET /P "NAME_CONFIRM=Enter new name (leave blank to accept): "

IF DEFINED NAME_CONFIRM (

  SET "variable1=!NAME_CONFIRM!"
  SET "variable2=CONFIRM_NAME"

  CALL :CHECK_NAME

  SET "name=!variable1!"

  CALL :CHECK_DUPE_NAME

  CALL :CHECK_SKIN

) ELSE (

  SET UUID=%DEFAULT_UUID%

)



CALL :LAUNCHER_PROFILES_USER

goto NEW_USER



:HEADER
CLS
echo.
ECHO  !BODYHEADER!
ECHO  %SPACER%
ECHO  !SERVER_URLS_1!
ECHO  !SERVER_URLS_2!
ECHO  %SPACER%

goto :EOF



:CHECK_BLOCK_STATE
TITLE Checking BLOCK state... ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

SET "BLOCK_STATE="
SET "HOSTS_STATE=GOOD"
SET "HOSTS_PROBLEM=N/A (HOSTS problems detected)"

IF EXIST "!HOSTS!" (

  ATTRIB -R -S -H "!HOSTS!">NUL 2>&1

  >NUL 2>&1 FINDSTR /BIRC:".*127.0.0.1 *!AUTH_SERVER!" "!HOSTS!"

  IF !ERRORLEVEL! EQU 0 (

    SET "HOSTS_STATE=!HOSTS_PROBLEM!"

    goto :EOF

  )



  >NUL 2>&1 FINDSTR /BIRC:".*0.0.0.0 *!AUTH_SERVER!" "!HOSTS!"

  IF !ERRORLEVEL! NEQ 0 (

    >NUL 2>&1 FINDSTR /I "!AUTH_SERVER!" "!HOSTS!"

    IF !ERRORLEVEL! EQU 0 (

      SET "HOSTS_STATE=!HOSTS_PROBLEM!"

    ) ELSE (

      SET BLOCK_STATE=NOT BLOCK

    )

  ) ELSE (

    >NUL 2>&1 FINDSTR /BIRC:" *0.0.0.0 *!AUTH_SERVER!" "!HOSTS!"

    IF !ERRORLEVEL! EQU 0 (

      SET BLOCK_STATE=BLOCK

    ) ELSE (

      >NUL 2>&1 FINDSTR /BIRC:" *# *0.0.0.0 *!AUTH_SERVER!" "!HOSTS!"

      IF !ERRORLEVEL! EQU 0 (

        SET BLOCK_STATE=UNBLOCK

      ) ELSE (

        SET "HOSTS_STATE=!HOSTS_PROBLEM!"

      )

    )

  )

) ELSE (

  SET "HOSTS_STATE=!HOSTS_PROBLEM!"

  SET BLOCK_STATE=NOT BLOCK

)

goto :EOF



:WRONG_STATE
SET "CAPTION_WRONG_BLOCK_STATE=Wrong block state^!"
SET "HEADER_WRONG_BLOCK_STATE=WRONG BLOCK STATE"

SET "CAPTION_UNKNOWN_BLOCK_STATE=Unknown block state^!"
SET "HEADER_UNKNOWN_BLOCK_STATE=BLOCK STATE UNKNOWN"

SET "CAPTION_USER_UNKNOWN=Unknown User^!"
SET "HEADER_USER_UNKNOWN=USER UNKNOWN"

SET "CAPTION_UNKNOWN_USER_AND_BLOCK_STATE=Unknown user/block state^!"
SET "HEADER_UNKNOWN_USER_AND_BLOCK_STATE=USER AND BLOCK STATE UNKNOWN"

SET "TEXT1_CRACKED=If a "CRACKED" user, run 'Auth (un)blocker' to BLOCK auth server, and proceed"
SET "TEXT2_CRACKED=If a LEGITIMATE user, simply proceed and SELECT or LOG INTO your own account"

SET "TEXT1_LEGITIMATE=A LEGITIMATE account is SELECTED but the AUTH server is currently 'BLOCKED'"
SET "TEXT2_LEGITIMATE=Either 'UNBLOCK' auth server or select a "CRACKED" user in OFFICIAL launcher"

SET "TEXT1_USER_UNKNOWN=There is currently no USER selected. Select a with '%BLOCK_STATE%ED' state"
SET "TEXT2_USER_UNKNOWN=compatible USER, or run 'Auth (un)blocker' to CHANGE current block STATE"

IF "%BLOCK_STATE%"=="" IF /I "%ACCOUNT_STATE%"=="CRACKED" (SET "BLOCK_TEXT=BLOCK") ELSE (SET "BLOCK_TEXT=UNBLOCK")

SET "TEXT1_UNKNOWN_BLOCK_STATE=The current block STATE couldn't be detected for the %ACCOUNT_STATE% user entry"
SET "TEXT2_UNKNOWN_BLOCK_STATE=Run 'Auth (un)blocker' and choose option '[2]' to '%BLOCK_TEXT%' the AUTH server"

SET "TEXT1_UNKNOWN_USER_AND_BLOCK_STATE=The current USER and auth server block STATE could NOT be detected"
SET "TEXT2_UNKNOWN_USER_AND_BLOCK_STATE=SELECT a USER and/or run 'Auth (un)blocker' to reset the block STATE"



IF /I "%ACCOUNT_STATE%"=="CRACKED" (

  SET "CAPTION=!CAPTION_WRONG_BLOCK_STATE!"
  SET "HEADER=!HEADER_WRONG_BLOCK_STATE!"
  SET "TEXT1_BODY=!TEXT1_CRACKED!"
  SET "TEXT2_BODY=!TEXT2_CRACKED!"

  IF "%BLOCK_STATE%"=="" (

    SET "CAPTION=!CAPTION_UNKNOWN_BLOCK_STATE!"
    SET "HEADER=!HEADER_UNKNOWN_BLOCK_STATE!"
    SET "TEXT1_BODY=!TEXT1_UNKNOWN_BLOCK_STATE!"
    SET "TEXT2_BODY=!TEXT2_UNKNOWN_BLOCK_STATE!"

  )

) ELSE (

  IF /I "%ACCOUNT_STATE%"=="LEGITIMATE" (

    SET "CAPTION=!CAPTION_WRONG_BLOCK_STATE!"
    SET "HEADER=!HEADER_WRONG_BLOCK_STATE!"
    SET "TEXT1_BODY=!TEXT1_LEGITIMATE!"
    SET "TEXT2_BODY=!TEXT2_LEGITIMATE!"

    IF "%BLOCK_STATE%"=="" (

      SET "CAPTION=!CAPTION_UNKNOWN_BLOCK_STATE!"
      SET "HEADER=!HEADER_UNKNOWN_BLOCK_STATE!"
      SET "TEXT1_BODY=!TEXT1_UNKNOWN_BLOCK_STATE!"
      SET "TEXT2_BODY=!TEXT2_UNKNOWN_BLOCK_STATE!"

    )

  ) ELSE (

    SET "CAPTION=!CAPTION_USER_UNKNOWN!"
    SET "HEADER=!HEADER_USER_UNKNOWN!"
    SET "TEXT1_BODY=!TEXT1_USER_UNKNOWN!"
    SET "TEXT2_BODY=!TEXT2_USER_UNKNOWN!"

    IF "%BLOCK_STATE%"=="" (

      SET "CAPTION=!CAPTION_UNKNOWN_USER_AND_BLOCK_STATE!"
      SET "HEADER=!HEADER_UNKNOWN_USER_AND_BLOCK_STATE!"
      SET "TEXT1_BODY=!TEXT1_UNKNOWN_USER_AND_BLOCK_STATE!"
      SET "TEXT2_BODY=!TEXT2_UNKNOWN_USER_AND_BLOCK_STATE!"

    )

  )

)



TITLE !CAPTION! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  !HEADER!
echo.
echo.
echo.
ECHO  !TEXT1_BODY!
ECHO  !TEXT2_BODY!
echo.
ECHO  NOTE: Always use my LAUNCHER to start the GAME or OFFICIAL
ECHO        launcher will ignore all of the '%AUTH_CONFIG:~,-4%' settings
echo.
echo.
echo.
ECHO  !ANYKEY! to continue at your OWN risk^)
PAUSE>NUL|SET /P =

SET PITSTOP=YES

goto WELCOME



:STATE_NOTICE
TITLE block STATE notice^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
echo.
ECHO  WRONG BLOCK STATE
echo.
echo.
echo.
ECHO  BLOCK the authentication server FIRST if you want to add any "CRACKED" users
ECHO  Run 'Auth (un)blocker' and choose menu option '[2]' to block the AUTH server
echo.
echo.
echo.
echo.
echo.
ECHO  !QUIT!
PAUSE>NUL|SET /P =
EXIT



:WRONG_FOLDER
TITLE Wrong launcher folder/location^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  WRONG LAUNCHER FOLDER/LOCATION
echo.
echo.
echo.
echo.
ECHO  This launcher is installed to an unallowed/incorrect location
ECHO  Please reinstall launcher to a destination not located inside:
echo.
ECHO  "!USER_APPDATA!\.minecraft"
echo.
echo.
echo.
ECHO  !QUIT!
PAUSE>NUL|SET /P =
EXIT



:CHECK_SKIN
SET "SERVER_RESPONSE="
SET "UUID="

FOR /F %%I in ('2^>NUL %CRL% --connect-timeout !TIMEOUT! -f -G -k -s -L https://api.mojang.com/users/profiles/minecraft/!name!') do SET SERVER_RESPONSE=%%I

IF DEFINED SERVER_RESPONSE (

  FOR /F %%I in ('ECHO !SERVER_RESPONSE! ^| "%JQ%" -r .name 2^>NUL') do SET name=%%I
  FOR /F %%I in ('ECHO !SERVER_RESPONSE! ^| "%JQ%" -r .id 2^>NUL') do SET UUID=%%I

  goto :EOF

)

SET oops=!RETRY!

goto CONFIRM_NAME



:LAUNCHER_PROFILES_USER
CALL :PROCESS_CHECK

IF NOT EXIST "!ACCOUNTS!" CD.>"!ACCOUNTS!" 2>NUL
FOR %%A IN ("!ACCOUNTS!") DO IF "%%~zA"=="0" ECHO {}>"!ACCOUNTS!" 2>NUL

IF NOT EXIST "!ACCOUNTS!" goto PROFILES_MISSING



"%JQ%" -r ".accounts+={\"!name!\":{\"accessToken\":\"\",\"localId\":\"!name!\",\"minecraftProfile\":{\"id\":\"!UUID!\",\"name\":\"!name!\"},\"type\":\"Mojang\",\"username\":\"!PROFILE_ENTRY!\"}}" "!ACCOUNTS!">"!ACCOUNTS:~,-5!" 2>NUL

DEL /A /F /Q "!ACCOUNTS!">NUL 2>&1
REN "!ACCOUNTS:~,-5!" "launcher_accounts.json">NUL 2>&1



CALL :CHECK_LAUNCHER_FILE

IF "!SELECTED_USER!"=="" (

  "%JQ%" -r ".+={\"activeAccountLocalId\":\"!name!\"}" "!ACCOUNTS!">"!ACCOUNTS:~,-5!" 2>NUL

  DEL /A /F /Q "!ACCOUNTS!">NUL 2>&1
  REN "!ACCOUNTS:~,-5!" "launcher_accounts.json">NUL 2>&1

)



SET /A PROFILES_COUNT+=1

IF !PROFILES_COUNT! EQU 1 SET "FIRST_NAME=!name!"

IF "!PLAYER!"=="" (SET "PLAYER=!name!") ELSE (SET "PLAYER=!PLAYER! + !name!")

SET oops=!ADDED! (!PROFILES_COUNT! IN TOTAL)

goto :EOF



:LAUNCHER_PROFILES_FOOTER
CALL :PROCESS_CHECK

IF NOT EXIST "!PROFILES!" CD.>"!PROFILES!" 2>NUL
FOR %%A IN ("!PROFILES!") DO IF "%%~zA"=="0" ECHO {}>"!PROFILES!" 2>NUL



SET "CUSTOM="

FOR /F "delims=" %%I in ('^""%JQ%" -r ".profiles.copyitright.gameDir|select(.^!=null)" "!PROFILES!"^" 2^>NUL') do SET "CUSTOM=%%I"

IF /I NOT "!CUSTOM!"=="!CD!\.minecraft" (

  SET "CUSTOM=!CD:\=\\!"

  "%JQ%" -r ".profiles+={\"copyitright\":{\"gameDir\":\"!CUSTOM!\\.minecraft\",\"icon\":\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACABAMAAAAxEHz4AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAnUExURUAkKVIvL142NmlDPF48Nv/axOPj4zlBXu3t7frIr////1Jkhfe2nNsEG6kAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACMSURBVGje7dQxEYAwEERRLGAhFrCAhVjAAhawgAUsYCGiaHabbVJz838FN3evzJKtk5ZZAAAAvwea8mKLcg4AAFAX2JQX9sjz3AMAAKgL+MD/PfLcDwwAAEAdwB+HOlUeen4pAACAesCtHvWqBDz3nu8AAADqAEN50Cd5z3cAAAD1gBmUhwAAAMWAMT6QPimXw/lhRQAAAABJRU5ErkJggg==\",\"lastVersionId\":\"latest-release\",\"name\":\"copyitright\",\"type\":\"custom\"}}" "!PROFILES!">>"!PROFILES:~,-5!" 2>NUL

  DEL /A /F /Q "!PROFILES!">NUL 2>&1
  REN "!PROFILES:~,-5!" "launcher_profiles.json">NUL 2>&1

)



SET "VALUE="

FOR /F "delims=" %%I in ('^""%JQ%" -r ".settings|select(.^!=null)" "!PROFILES!"^" 2^>NUL') do SET "VALUE=%%I"

IF "!VALUE!"=="" (

  "%JQ%" -r ".settings+={\"crashAssistance\":false,\"enableAnalytics\":false}" "!PROFILES!">"!PROFILES:~,-5!" 2>NUL

  DEL /A /F /Q "!PROFILES!">NUL 2>&1
  REN "!PROFILES:~,-5!" "launcher_profiles.json">NUL 2>&1

)

goto :EOF



:CHECK_DUPE_NAME
IF NOT EXIST "!ACCOUNTS!" goto :EOF

>NUL 2>&1 FINDSTR /IRC:"\"name\" *: *\"!name!\"" "!ACCOUNTS!"

IF !ERRORLEVEL! EQU 0 (

  SET oops=DUPLICATE NAME^^!

  goto !variable2!

)

goto :EOF



:RESOURCE_PACK
ATTRIB -R -S -H "!MY_RESOURCE_PACK!">NUL 2>&1

"%NZP%" -t "!MY_RESOURCE_PACK!">NUL 2>&1

IF !ERRORLEVEL! NEQ 0 DEL /A /F /Q "!MY_RESOURCE_PACK!">NUL 2>&1



IF NOT EXIST "!MY_RESOURCE_PACK!" (

   2>NUL MD ".minecraft\resourcepacks"

  "%CRL%" --connect-timeout !TIMEOUT! -f -k -s -L "!CHANGELOG_ALT!/resourcepacks/copyitright.zip">"!MY_RESOURCE_PACK!" 2>NUL

  IF NOT EXIST "!MY_RESOURCE_PACK!" goto :EOF

  "%NZP%" -t "!MY_RESOURCE_PACK!">NUL 2>&1

  IF !ERRORLEVEL! NEQ 0 (

    DEL /A /F /Q "!MY_RESOURCE_PACK!">NUL 2>&1

    goto :EOF

  )

)



IF EXIST "!GAMEDIR!\options.txt" (

  FINDSTR /C:"resourcePacks:["^" "!GAMEDIR!\options.txt">NUL

  IF !ERRORLEVEL! EQU 0 (

    >NUL FINDSTR /X /C:"resourcePacks:[\"vanilla\"]" "!GAMEDIR!\options.txt"

    IF !ERRORLEVEL! EQU 0 (

      >NUL FINDSTR /V /C:"resourcePacks:[\"vanilla\"]" "!GAMEDIR!\options.txt">"!GAMEDIR!\options.xtx"

      DEL /A /F /Q "!GAMEDIR!\options.txt">NUL 2>&1
      REN "!GAMEDIR!\options.xtx" "options.txt">NUL 2>&1

    ) ELSE (

      SET "NO_WRITE= "

    )

  )

)

ATTRIB -R -S -H "!GAMEDIR!\resourcepacks\copyitright.zip">NUL 2>&1

IF NOT EXIST "!GAMEDIR!\resourcepacks\copyitright.zip" (

  2>NUL MD "!GAMEDIR!\resourcepacks"

  COPY /Y "!MY_RESOURCE_PACK!" "!GAMEDIR!\resourcepacks\copyitright.zip">NUL 2>&1

)

IF "!NO_WRITE!"=="" ECHO resourcePacks:["copyitright.zip"]>>"!GAMEDIR!\options.txt" 2>NUL

SET "NO_WRITE="

FOR /F "tokens=2 delims=:" %%I IN ('2^>NUL FINDSTR /C:"resourcePacks:["^" "!GAMEDIR!\options.txt"') DO SET "SELECTED_RESOURCE_PACKS=%%I"

goto :EOF



:COPY_SERVERLIST
IF NOT EXIST "!GAMEDIR!\servers.dat" (

  ATTRIB -R -S -H ".minecraft\servers.cir">NUL 2>&1
  COPY /Y ".minecraft\servers.cir" "!GAMEDIR!\servers.dat">NUL 2>&1
  ATTRIB +R +S +H ".minecraft\servers.cir">NUL 2>&1

)

goto :EOF



:COLORS
IF EXIST "%LAUNCHER_CONFIG%" (

  IF /I NOT "%TAG%"=="changeCLR" (

    IF "!TRIGGER!"=="" FOR /F "delims=^= tokens=2" %%A IN ('2^>NUL FINDSTR /B "COLOR_SCHEME=" "%LAUNCHER_CONFIG%"') DO SET "COL=%%A"

  )

  IF DEFINED COL (

    SET "COL=!COL:~,2!"

    IF /I "!COL:~,1!"=="!COL:~1,1!" (

      SET "COL="
      SET "TRIGGER= "

      goto COLORS

    )

  ) ELSE (

    TITLE UI Color Chooser ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

    CALL :COLOR_INFO

    SET /P "COL=First value is for background color (single value to set text color, only): "

    IF DEFINED COL (

      SET "COL=!COL:~,2!"

      IF /I "!COL:~,1!"=="!COL:~1,1!" (

        SET "COL="

        goto COLORS

      )

    ) ELSE (

      SET COL=1F

    )

    SET "OKIDOKI= "
    SET "TRIGGER= "

  )

  ECHO !COL!|FINDSTR /r "[^a-fA-F0-9]">nul 2>&1 && (

    SET "COL="
    SET "TRIGGER= "

    goto COLORS

  )

  COLOR !COL!

  CALL :AUTOUPDATE_STATE
  CALL :NOTIFY_STATE
  CALL :MESSAGE_STATE
  CALL :FEEDBACK_STATE

  IF DEFINED TRIGGER CALL :SAVE_SETTINGS
  IF DEFINED OKIDOKI CALL :COLOR_SET

) ELSE (

  CD.>"%LAUNCHER_CONFIG%" 2>NUL && (SET "CLRS= " & SET "firstrun= (First Run)")

  goto COLORS

)

goto :EOF



:COLOR_SET
TITLE Done^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  NEW COLOR SCHEME HAS BEEN SET^^!
echo.
echo.
echo.
ECHO  Do you like the new look? No? You can always change the colors by running
ECHO  the script or shortcut 'Change Colors', or by editing '%LAUNCHER_CONFIG%' directly
ECHO  using Notepad/Notepad++, or any other text editing program of your choice
echo.
echo.
echo.
echo.
echo.
ECHO  !CONTINUE!
PAUSE>NUL|SET /P =

goto :EOF



:COLOR_INFO
TITLE Color Info ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
ECHO  Hey^^! Have you always wanted to change that boring look of my launcher?
echo.
ECHO  Well... NOW YOU CAN^^!
echo.
ECHO  Simply choose a color combination from the list below, and be happy again ^^_^^
echo.
ECHO    0 = Black       8 = Gray
ECHO    1 = Blue        9 = Light Blue
ECHO    2 = Green       A = Light Green
ECHO    3 = Aqua        B = Light Aqua
ECHO    4 = Red         C = Light Red
ECHO    5 = Purple      D = Light Purple
ECHO    6 = Yellow      E = Light Yellow
ECHO    7 = White       F = Bright White
echo.

goto :EOF



:RANDOM_MESSAGE
IF DEFINED NOPE goto PRNG

IF NOT EXIST "%MESSAGES%" CALL :RESET_MESSAGES



IF DEFINED CHANGELOG_ALT FOR /F "tokens=2" %%A IN ('2^>NUL %CRL% --connect-timeout !TIMEOUT! -f -I -k -s -L "!CHANGELOG_ALT!/%MESSAGES%.exe" ^| FIND /I "Content-Length"') do SET REMOTE_FILESIZE=%%A

IF "!REMOTE_FILESIZE!"=="" goto PRNG

FOR %%A IN ("%MESSAGES%") DO SET LOCAL_FILESIZE=%%~zA

IF NOT "!LOCAL_FILESIZE!"=="!REMOTE_FILESIZE!" (

  REN "%MESSAGES%" "%MESSAGES%.tmp">NUL 2>&1
  ATTRIB +R +S +H "%MESSAGES%.tmp">NUL 2>&1

  "%CRL%" --connect-timeout !TIMEOUT! -f -k -s -L "!CHANGELOG_ALT!/%MESSAGES%.exe">"%MESSAGES%" 2>NUL

  IF EXIST "%MESSAGES%" (

    SET "LOCAL_FILESIZE="

    FOR %%A IN ("%MESSAGES%") DO SET LOCAL_FILESIZE=%%~zA

    IF "!LOCAL_FILESIZE!"=="!REMOTE_FILESIZE!" (

      FOR /F "delims=" %%A IN ('TYPE "%MESSAGES%"') DO IF NOT DEFINED CONTENT SET CONTENT=%%A

      ATTRIB -R -S -H "%MESSAGES%*">NUL 2>&1

      IF "!CONTENT:~,1!"=="<" DEL /A /F /Q "%MESSAGES%">NUL 2>&1
      IF "!CONTENT!"=="" DEL /A /F /Q "%MESSAGES%">NUL 2>&1

      IF NOT EXIST "%MESSAGES%" goto SKIP

      DEL /A /F /Q "%MESSAGES%.tmp">NUL 2>&1

    ) ELSE (

      DEL /A /F /Q "%MESSAGES%">NUL 2>&1

    )

  )

)



:SKIP
IF NOT EXIST "%MESSAGES%" (

  ATTRIB -R -S -H "%MESSAGES%.tmp">NUL 2>&1
  REN "%MESSAGES%.tmp" "%MESSAGES%">NUL 2>&1

)



:PRNG
SET "MSG="
SET "PRNG="

SET "PRNG=!RANDOM!"
SET "PRNG=!RANDOM!"



SET /A MESSAGE_COUNT=0

FOR /F %%I IN ('TYPE "%MESSAGES%"^|FIND /C /V ""') DO SET /A MESSAGE_COUNT=%%I

SET /A RD=!PRNG!%%MESSAGE_COUNT

IF !RD! EQU 0 (SET "SKIP=") ELSE SET "SKIP=SKIP=!RD!"

SET "FOUND="

FOR /F "%SKIP%TOKENS=1*DELIMS=:" %%I IN ('2^>NUL FINDSTR /N "^" "%MESSAGES%"') DO IF NOT DEFINED FOUND SET "FOUND=%%I"&SET "MSG=%%J"

IF "!MSG!"=="" goto PRNG

goto :EOF



:SHOW_MESSAGE
echo.
echo.
echo.

IF /I "%TAG%"=="Updated" (

  ECHO  [A MESSAGE FROM THE DEVELOPER]

) ELSE (

  ECHO  [RANDOM MESSAGE BEFORE YOU PLAY]

)

echo.
ECHO  - !MSG!

goto :EOF



:CHECK_NAME
SET "variable1=!variable1: =_!"
SET "variable1=!variable1:.=_!"
SET "variable1=!variable1:-=_!"

ECHO !variable1!|FINDSTR /r "[^a-zA-Z0-9_]">nul 2>&1 && (

  SET oops=UNALLOWED CHAR^^!
  SET "variable1="

  goto !variable2!

)



CALL :CHECK_NAMELENGTH variable1 namelength

IF !namelength! EQU 1 (

  SET oops=NAME TOO SHORT^^! (-1^)
  SET "variable1="

  goto !variable2!

)

IF !namelength! GTR 16 (

  SET /A "namelength-=16"

  SET oops=NAME TOO LONG^^! (+!namelength!^)
  SET "variable1="

  goto !variable2!

)

SET "oops="

goto :EOF



:CHECK_OS_ARCH
SET SYS_ARCH=x64
SET CMD_ARCH=x64

IF /I "%PROCESSOR_ARCHITECTURE%"=="x86" (

  IF DEFINED PROCESSOR_ARCHITEW6432 (

    SET CMD_ARCH=x86

  ) ELSE (

    SET SYS_ARCH=x86
    SET CMD_ARCH=x86

  )

)

goto :EOF



:COUNTDOWN
CLS

IF !TIMER! EQU 1 (SET "s=") ELSE (SET "s=s")

echo.
ECHO  Get Ready..^^! -^> auto-closing in !TIMER! second!s!

IF DEFINED UPDATE_INFO (

  echo.
  ECHO    !UPDATE_INFO!

)

IF DEFINED MSG CALL :SHOW_MESSAGE

IF !TIMER! EQU 0 EXIT

>NUL PING -n 2 0.0.0.0

SET /A TIMER-=1

goto COUNTDOWN



:AUTOUPDATE_STATE
FOR /F "delims=^= tokens=2" %%A IN ('2^>NUL FINDSTR /B "AUTO_UPDATES=" "%LAUNCHER_CONFIG%"') DO SET "AU=%%A"

IF "%AU%"=="" (

  SET AU=YES
  SET "TRIGGER= "

) ELSE (

  IF NOT "%AU%"=="YES" (

    IF NOT "%AU%"=="NO" (

      SET AU=YES
      SET "TRIGGER= "

    ) ELSE (

      SET AU=NO

    )

  ) ELSE (

    SET AU=YES

  )

)

goto :EOF



:NOTIFY_STATE
FOR /F "delims=^= tokens=2" %%A IN ('2^>NUL FINDSTR /B "UPDATE_NOTES=" "%LAUNCHER_CONFIG%"') DO SET "UN=%%A"

IF "%UN%"=="" (

  SET UN=YES
  SET "TRIGGER= "

) ELSE (

  IF NOT "%UN%"=="YES" (

    IF NOT "%UN%"=="NO" (

      SET UN=YES
      SET "TRIGGER= "

    ) ELSE (

      SET UN=NO

    )

  ) ELSE (

    SET UN=YES

  )

)

goto :EOF



:MESSAGE_STATE
FOR /F "delims=^= tokens=2" %%A IN ('2^>NUL FINDSTR /B "RND_MESSAGES=" "%LAUNCHER_CONFIG%"') DO SET "RM=%%A"

IF "%RM%"=="" (

  SET RM=YES
  SET "TRIGGER= "

) ELSE (

  IF NOT "%RM%"=="YES" (

    IF NOT "%RM%"=="NO" (

      SET RM=YES
      SET "TRIGGER= "

    ) ELSE (

      SET RM=NO

    )

  ) ELSE (

    SET RM=YES

  )

)

goto :EOF



:FEEDBACK_STATE
FOR /F "delims=^= tokens=2" %%A IN ('2^>NUL FINDSTR /B "ENABLE_POLLS=" "%LAUNCHER_CONFIG%"') DO SET "EP=%%A"

IF "%EP%"=="" (

  SET EP=YES
  SET "TRIGGER= "

) ELSE (

  IF NOT "%EP%"=="YES" (

    IF NOT "%EP%"=="NO" (

      SET EP=YES
      SET "TRIGGER= "

    ) ELSE (

      SET EP=NO

    )

  ) ELSE (

    SET EP=YES

  )

)

goto :EOF



:TOGGLE_AU
CALL :HEADER

echo.
echo.
echo.
echo.
echo.
echo.
echo.

IF "%AU%"=="NO" (

  TITLE Automatic updates are ENABLED^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

  SET AU=YES

  ECHO  AUTOMATIC UPDATES HAVE BEEN ENABLED
  echo.
  ECHO  Re-run the program to disable them again

) ELSE (

  TITLE Automatic updates are DISABLED^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

  SET AU=NO

  ECHO  AUTOMATIC UPDATES HAVE BEEN DISABLED
  echo.
  ECHO  Re-run the program to enable them again

)

CALL :SAVE_SETTINGS

echo.
echo.
echo.
echo.
echo.
echo.
echo.
ECHO  !QUIT!
PAUSE>NUL|SET /P =
EXIT



:TOGGLE_NAG
CALL :HEADER

echo.
echo.
echo.
echo.
echo.
echo.
echo.

IF "%UN%"=="NO" (

  TITLE Notifications are ENABLED^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

  SET UN=YES

  ECHO  UPDATE NOTIFICATIONS HAVE BEEN ENABLED
  echo.
  ECHO  Re-run the program to hide them again

) ELSE (

  TITLE Notifications are DISABLED^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

  SET UN=NO

  ECHO  UPDATE NOTIFICATIONS HAVE BEEN DISABLED
  echo.
  ECHO  Re-run the program to enable them again

)

CALL :SAVE_SETTINGS

echo.
echo.
echo.
echo.
echo.
echo.
echo.
ECHO  !QUIT!
PAUSE>NUL|SET /P =
EXIT



:TOGGLE_RND
CALL :HEADER

echo.
echo.
echo.
echo.
echo.
echo.
echo.

IF "%RM%"=="YES" (

  TITLE Random messages are DISABLED^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

  SET RM=NO

  ECHO  RANDOM MESSAGES HAVE BEEN DISABLED
  echo.
  ECHO  Re-run the program to enable them again

) ELSE (

  SET RM=YES

  TITLE Random messages are ENABLED^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

  ECHO  RANDOM MESSAGES HAVE BEEN ENABLED
  echo.
  ECHO  Re-run the program to hide them again

)

CALL :SAVE_SETTINGS

echo.
echo.
echo.
echo.
echo.
echo.
echo.
ECHO  !QUIT!
PAUSE>NUL|SET /P =
EXIT



:CHECK_UPDATES
TITLE Checking for Launcher update... ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CLS
echo.
ECHO  Checking for Launcher update (auto-update: %AU%) ...

IF "%AU%"=="YES" (

  echo.

  ECHO  (depending on the system settings, UAC may ask for your permission to proceed^)

  >NUL PING -n 4 0.0.0.0

) ELSE (

  >NUL PING -n 2 0.0.0.0

)

goto :EOF



:RESET_MESSAGES
IF /I "!LANG!"=="E" ECHO The random messages couldn't be downloaded :^^(>>"%MESSAGES%" 2>NUL
IF /I "!LANG!"=="N" ECHO De random berichten konden niet worden gedownload :^^(>"%MESSAGES%" 2>NUL

goto :EOF



:SAVE_SETTINGS
ECHO COLOR_SCHEME=!COL!>"%LAUNCHER_CONFIG%" 2>NUL
ECHO AUTO_UPDATES=%AU%>>"%LAUNCHER_CONFIG%" 2>NUL
ECHO UPDATE_NOTES=%UN%>>"%LAUNCHER_CONFIG%" 2>NUL
ECHO RND_MESSAGES=%RM%>>"%LAUNCHER_CONFIG%" 2>NUL
ECHO ENABLE_POLLS=%EP%>>"%LAUNCHER_CONFIG%" 2>NUL

goto :EOF



:CHECK_LOCALE
SET "LAUNCHER_LOCALE='System/Game Default'"

FOR /F "delims=" %%I in ('^""%JQ%" -r ".locale|select(.^!=null)" "!SETTINGS!"^" 2^>NUL') do SET LAUNCHER_LOCALE=%%I

IF /I "!LAUNCHER_LOCALE:~,2!"=="nl" (

  SET "MESSAGES=%MESSAGES%.nld"
  SET "LANG=N"

) ELSE (

  SET "MESSAGES=%MESSAGES%.eng"
  SET "LANG=E"

)

goto :EOF



:UNINSTALL
TITLE Uninstall Launcher? ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  UNINSTALL MINECRAFT LAUNCHER
echo.
echo.
echo.
ECHO  Are you sure you want to delete copyitright's launcher and related shortcuts?
echo.
ECHO  NOTE: Contents of '.minecraft' folder will remain intact
echo.
echo.
echo.
echo.
echo.

SET /P UNINST=[type DELETE to UNINSTALL, anything else to CANCEL]: 

IF NOT "!UNINST!"=="DELETE" goto ABORT_UNINSTALL



CLS

ATTRIB -R -S -H "!PROGRAMDATA!\uninst.cmd">NUL 2>&1

ECHO @ECHO OFF>"!PROGRAMDATA!\uninst.cmd" 2>NUL
ECHO "%%SystemRoot%%\System32\MODE" CON COLS=80 LINES=25^>NUL 2^>^&^1>>"!PROGRAMDATA!\uninst.cmd" 2>NUL
ECHO COLOR !COL!>>"!PROGRAMDATA!\uninst.cmd" 2>NUL
ECHO TITLE !BODYHEADER:~,13! Minecraft Launcher Uninstaller ^^^^^| !BODYHEADER:~45,11! ^^^^^| !BODYHEADER:~59!>>"!PROGRAMDATA!\uninst.cmd" 2>NUL
ECHO RD /S /Q "!LAUNCHER_DP0!"^>NUL 2^>^&^1>>"!PROGRAMDATA!\uninst.cmd" 2>NUL
ECHO echo.>>"!PROGRAMDATA!\uninst.cmd" 2>NUL
ECHO ECHO  Launcher was successfully uninstalled... :(>>"!PROGRAMDATA!\uninst.cmd" 2>NUL
ECHO echo.>>"!PROGRAMDATA!\uninst.cmd" 2>NUL
ECHO ECHO  !ANYKEY! to self-delete the Uninstaller)>>"!PROGRAMDATA!\uninst.cmd" 2>NUL
ECHO PAUSE^>NUL>>"!PROGRAMDATA!\uninst.cmd" 2>NUL
ECHO goto 2^>NUL ^& DEL /A /F /Q "%%~f0" ^& EXIT>>"!PROGRAMDATA!\uninst.cmd" 2>NUL

IF !ERRORLEVEL! EQU 0 (

  TITLE Farewell, good friend... :'^( ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

  echo.
  ECHO     3 - Before i go i want to say: Farewell, good friend... :'^(
  >NUL PING -n 4 0.0.0.0
  ECHO     2 - Hopefully you won't forget me...
  >NUL PING -n 4 0.0.0.0
  ECHO     1 - Maybe we'll meet again one day...
  >NUL PING -n 4 0.0.0.0
  ECHO   0.5 - If not.. then there's not much we can do than part ways...
  >NUL PING -n 4 0.0.0.0
  ECHO   0.2 - Take good care of yourself...
  >NUL PING -n 4 0.0.0.0
  ECHO   0.0 - Cleaning up shortcuts and launcher directory...
  >NUL PING -n 4 0.0.0.0

) ELSE (

  TITLE Something went wrong... ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

  echo.
  ECHO  Something went wrong (ERROR #!ERRORLEVEL!^)
  echo.
  echo.
  ECHO  !QUIT!
  PAUSE>NUL|SET /P =
  EXIT

)

SET REG_KEY=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders

FOR /F "delims=" %%a IN ('2^>NUL REG QUERY "!REG_KEY!" /v Programs') DO SET "REG_VALUE=%%a"

IF DEFINED REG_VALUE (

  CALL SET "REG_VALUE=!REG_VALUE:*REG_EXPAND_SZ    =!"

  RD /S /Q "!REG_VALUE!\%DIR%">NUL 2>&1

  SET "REG_VALUE="

)

FOR /F "delims=" %%a IN ('2^>NUL REG QUERY "!REG_KEY!" /v Desktop') DO SET "REG_VALUE=%%a"

IF DEFINED REG_VALUE (

  CALL SET "REG_VALUE=!REG_VALUE:*REG_EXPAND_SZ    =!"

  RD /S /Q "!REG_VALUE!\%DIR%">NUL 2>&1

  SET "REG_VALUE="

)

PUSHD "!PROGRAMDATA!" && "!COMSPEC!" /C START "" uninst.cmd

EXIT



:ABORT_UNINSTALL
TITLE Thank You^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  DEINSTALLATION ABORTED BY USER
echo.
echo.
echo.
ECHO  Thank you for keeping Herobrine alive^^!
echo.
echo.
echo.
echo.
echo.
echo.
echo.
ECHO  !QUIT!
PAUSE>NUL|SET /P =
EXIT



:CHECK_CRACKED_USERS
SET "COMPARE="

>NUL 2>&1 FINDSTR /IC:"!PROFILE_ENTRY!" "!ACCOUNTS!"

IF !ERRORLEVEL! EQU 0 SET "COMPARE= "

goto :EOF



:PROFILES_MISSING
SET LABEL=FILE '!ACCOUNTS:~-22!' UNEXPECTEDLY DISAPPEARED

goto ERROR



:CHECK_UPDATE_HOST
SET "UPDATE_URL="
SET "CHANGELOG_URL="
SET "CHANGELOG_ALT="

FOR /F "delims=" %%U in ('2^>NUL %CRL% --connect-timeout !TIMEOUT! -f -k -s -L !UPDATE_HOST! 2^>NUL') do (

  SET UPDATE_URL=%%U

  IF DEFINED UPDATE_URL (

    IF "!CHANGELOG_URL!"=="" (

      IF /I "!UPDATE_URL:~,4!"=="http" (

        SET "CHANGELOG_URL=!UPDATE_URL!"

      )

    ) ELSE (

      IF "!CHANGELOG_ALT!"=="" (

        IF /I "!UPDATE_URL:~,4!"=="http" (

          SET "CHANGELOG_ALT=!UPDATE_URL!"

          goto :EOF

        )

      )

    )

  )

)

goto :EOF



:CHECK_LAUNCHER_FILE
TITLE Checking launcher file... ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

SET "ACCOUNT_TYPE="
SET "ACCOUNT_STATE="
SET "SELECTED_USER="
SET "DISPLAYNAME="
SET "OUTPUT="
SET "DATA="

IF EXIST "!ACCOUNTS!" (

  FOR /F "delims=" %%I in ('^""%JQ%" -r ".accounts[].username|select(.^!=null)" "!ACCOUNTS!"^" 2^>NUL') do SET DATA=%%I

  IF "!DATA!"=="" (

    SET "ACCOUNT_STATE=N/A (empty file)"

    goto :EOF

  )

  "%JQ%" ".accounts[] |= if has (\"accessToken\") then . else .accessToken = \"\" end" "!ACCOUNTS!">"!ACCOUNTS:~,-5!" 2>NUL

  IF !ERRORLEVEL! EQU 0 (

    DEL /A /F /Q "!ACCOUNTS!">NUL 2>&1
    REN "!ACCOUNTS:~,-5!" "launcher_accounts.json">NUL 2>&1

  ) ELSE (

    DEL /A /F /Q "!ACCOUNTS:~,-5!">NUL 2>&1

  )

  FOR /F "delims=" %%I in ('^""%JQ%" -r ".activeAccountLocalId|select(.^!=null)" "!ACCOUNTS!"^" 2^>NUL') do SET SELECTED_USER=%%I

  IF DEFINED SELECTED_USER (

    FOR /F "delims=" %%I in ('^""%JQ%" -r ".accounts.\"!SELECTED_USER!\".type|select(.^!=null)" "!ACCOUNTS!"^" 2^>NUL') do SET ACCOUNT_TYPE=%%I
    FOR /F "delims=" %%I in ('^""%JQ%" -r ".accounts.\"!SELECTED_USER!\".username|select(.^!=null)" "!ACCOUNTS!"^" 2^>NUL') do SET OUTPUT=%%I

    IF "!OUTPUT!"=="" (

      SET ACCOUNT_STATE=UNSELECTED

    ) ELSE (

      IF /I "!OUTPUT!"=="!PROFILE_ENTRY!" (

        SET ACCOUNT_STATE=CRACKED

      ) ELSE (

        IF /I "!OUTPUT!"=="!PROFILE_ENTRY:~,49!!WEBSITE:~12!" (

          SET ACCOUNT_STATE=CRACKED

        ) ELSE (

          SET ACCOUNT_STATE=LEGITIMATE

        )

      )

    )

    FOR /F "delims=" %%I in ('^""%JQ%" -r ".accounts.\"!SELECTED_USER!\".minecraftProfile.name|select(.^!=null)" "!ACCOUNTS!"^" 2^>NUL') do SET DISPLAYNAME=%%I

  ) ELSE (

    SET ACCOUNT_STATE=UNSELECTED

  )

) ELSE (

  SET "ACCOUNT_STATE=N/A (no file yet)"

)

goto :EOF



:STATUS
IF /I "%ACCOUNT_STATE%"=="CRACKED" (

  IF NOT "!OUTPUT!"=="!PROFILE_ENTRY!" SET "ACCOUNT_STATE=CRACKED (modified user entry)"

) ELSE (

  IF /I "%ACCOUNT_STATE%"=="LEGITIMATE" (

    IF DEFINED DISPLAYNAME (

      SET "ACCOUNT_STATE=LEGITIMATE (!OUTPUT!)"

    ) ELSE (

      IF /I "!ACCOUNT_TYPE!"=="Xbox" (

        SET "ACCOUNT_STATE=XBOX (not supported yet...)"
        SET "DISPLAYNAME=!OUTPUT!"
        SET UUID=N/A

      ) ELSE (

        SET "ACCOUNT_STATE=DEMO (!OUTPUT!)"
        SET DISPLAYNAME=Player
        SET UUID=%DEFAULT_UUID%

      )

    )

  ) ELSE (

    IF /I "%ACCOUNT_STATE%"=="UNSELECTED" SET "ACCOUNT_STATE=UNKNOWN (select user/account first)"

  )

)



IF DEFINED SELECTED_USER (

  FOR /F "delims=" %%I in ('^""%JQ%" -r ".accounts.\"!SELECTED_USER!\".minecraftProfile.id|select(.^!=null)" "!ACCOUNTS!"^" 2^>NUL') do SET UUID=%%I

)



IF DEFINED UUID (SET "UUID='!UUID!'") ELSE (SET "UUID=N/A")
IF DEFINED DISPLAYNAME (SET "DISPLAYNAME='%DISPLAYNAME%'") ELSE (SET "DISPLAYNAME=N/A")

goto :EOF



:PROCESS_CHECK
TITLE Checking processes.. ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

SET "PROCESS="
SET "LAUNCHER_EXE="
SET "GAME_EXE="

FOR /F %%a in ('TASKLIST /NH /FI "WINDOWTITLE eq Minecraft*" ^| FIND /I "console"') DO (

  SET PROCESS=%%a

  IF DEFINED PROCESS (

    ECHO !PROCESS! | FIND /I "Minecraft.exe">NUL
    IF !ERRORLEVEL! EQU 0 SET "LAUNCHER_EXE= "

    ECHO !PROCESS! | FIND /I "javaw.exe">NUL
    IF !ERRORLEVEL! EQU 0 SET "GAME_EXE= "

  )

)



IF DEFINED GAME_EXE (

  IF DEFINED LAUNCHER_EXE (

    SET PROCESS=MINECRAFT AND OFFICIAL LAUNCHER ARE STILL ACTIVE

  ) ELSE (

    SET PROCESS=MINECRAFT IS STILL ACTIVE

  )

) ELSE (

  IF DEFINED LAUNCHER_EXE (

    SET PROCESS=OFFICIAL LAUNCHER IS STILL ACTIVE

  ) ELSE (

    goto :EOF

  )

)



TITLE Game/Launcher still active? ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  !PROCESS!^^!
echo.
echo.
echo.
echo.
ECHO  Please exit GAME and OFFICIAL launcher BEFORE continuing
ECHO  Not doing so may result in loss of launcher user entries
echo.
echo.
IF DEFINED STILL_ACTIVE (ECHO  !STILL_ACTIVE!) ELSE (echo.)
echo.
echo.
ECHO  !ANYKEY! when ready)
PAUSE>NUL|SET /P =

SET STILL_ACTIVE=  ^^!^^!^^! PLEASE CHECK THE TASK MANAGER FOR MORE MINECRAFT RELATED PROCESSES ^^!^^!^^!

goto PROCESS_CHECK



:WRITE_STATS
CALL :CLEAN_TEMPDIR

2>NUL MD "!TEMPDIR!"

SET "TXT=!TEMPDIR!\Unknown (!COMPUTERNAME!) - %TAG% - %SCRIPT_VERSION%%FIRSTRUN%"

ECHO.>>"!TXT!.txt" 2>NUL

"%CRL%" --version>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

SET PS=pwsh.exe

>NUL 2>&1 !PS! /?

IF !ERRORLEVEL! NEQ 0 (

  SET PS=powershell.exe

  >NUL 2>&1 !PS! /?

  IF !ERRORLEVEL! NEQ 0 (

    SET "PS=!SYSDIR!\WindowsPowerShell\v1.0\powershell.exe"

  )

)

IF !ERRORLEVEL! EQU 0 (

  FOR /F "tokens=2 delims= " %%A IN ('!PS! -command $PSVersionTable ^| FIND /I "PSVersion"') do SET "POWERSHELL_VERSION=%%A"

  For /F "Tokens=2 delims=:" %%A In ('!PS! -command (Get-Date^)-(gcim Win32_OperatingSystem^).LastBootUpTime') Do (

    IF NOT DEFINED UPTIME (

      IF NOT DEFINED D (SET "D=%%A") ELSE (

        IF NOT DEFINED H (SET "H=%%A") ELSE (

          IF NOT DEFINED M (SET "M=%%A") ELSE (

            IF NOT DEFINED S (

              SET "S=%%A"

              SET "UPTIME=!d!d!h!h!m!m!s!s"

              SET "UPTIME=!UPTIME: =!"

            )

          )

        )

      )

    )

  )

) ELSE (

  SET POWERSHELL_VERSION=N/A
  SET UPTIME=N/A

)

ECHO     PowerShell : !POWERSHELL_VERSION!>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL
ECHO.>>"!TXT!.txt" 2>NUL

ECHO    UPDATE HOST : !UPDATE_HOST!>>"!TXT!.txt" 2>NUL
ECHO     TARGET URL : !TARGET_URL!>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

ECHO  CHANGELOG URL : !CHANGELOG_URL!>>"!TXT!.txt" 2>NUL
ECHO  CHANGELOG ALT : !CHANGELOG_ALT!>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL
ECHO  -=-=-=-=-=-=-=-=-=-^> !TIJD! ^<-=-=-=-=-=-=-=-=-=->>"!TXT!.txt" 2>NUL
ECHO.>>"!TXT!.txt" 2>NUL



CALL :CHECK_OS_ARCH



ECHO   CHOSEN UI COLORS : !COL!>>"!TXT!.txt" 2>NUL
ECHO       AUTO-UPDATES : %AU%>>"!TXT!.txt" 2>NUL
ECHO      UPDATE NOTIFY : %UN%>>"!TXT!.txt" 2>NUL
ECHO    RANDOM MESSAGES : %RM%>>"!TXT!.txt" 2>NUL
ECHO      USER FEEDBACK : %EP%>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL
ECHO.>>"!TXT!.txt" 2>NUL

IF "%RM%"=="NO" (

  IF DEFINED name (

    ECHO  MESSAGE: !MSG!>>"!TXT!.txt" 2>NUL

  ) ELSE (

    ECHO  MESSAGE: (DISABLED^)>>"!TXT!.txt" 2>NUL

  )

) ELSE (

  ECHO  MESSAGE: !MSG!!POLL!>>"!TXT!.txt" 2>NUL

)

ECHO.>>"!TXT!.txt" 2>NUL
ECHO.>>"!TXT!.txt" 2>NUL



>NUL 2>&1 REG QUERY "HKEY_USERS\S-1-5-19" && SET "ADMIN= [Admin]"



SET EXT_IPv4=Unknown
SET EXT_IPv6=Unknown

SET IPv4_HOSTNAME=Unable to resolve hostname
SET IPv6_HOSTNAME=!IPv4_HOSTNAME!

SET LOCAL_IP=Unknown

FOR /F %%I in ('%CRL% --connect-timeout !TIMEOUT! -4 -f -k -s !WEBSITE!/ip.php 2^>NUL') Do SET "EXT_IPv4=%%I"
FOR /F %%I in ('%CRL% --connect-timeout !TIMEOUT! -6 -f -k -s !WEBSITE!/ip.php 2^>NUL') Do SET "EXT_IPv6=%%I"

IF /I NOT "!EXT_IPv4!"=="Unknown" (

  REN "!TXT!.txt" "!EXT_IPv4! (!COMPUTERNAME!) - %TAG% - %SCRIPT_VERSION%%FIRSTRUN%.txt">NUL 2>&1

  CD.>"!TXT!.txt" 2>NUL
  DEL /A /F /Q "!TXT!.txt">NUL 2>&1

  SET "TXT=!TEMPDIR!\!EXT_IPv4! (!COMPUTERNAME!) - %TAG% - %SCRIPT_VERSION%%FIRSTRUN%"

  FOR /F "tokens=2" %%A in ('2^>NUL NSLOOKUP "!EXT_IPv4!" ^| FIND "    "') do SET "IPv4_HOSTNAME=%%A"

)

IF /I NOT "!EXT_IPv6!"=="Unknown" (

  FOR /F "tokens=2" %%A in ('2^>NUL NSLOOKUP "!EXT_IPv6!" ^| FIND "    "') do SET "IPv6_HOSTNAME=%%A"

)

FOR /F "tokens=3,4" %%A in ('2^>NUL ROUTE PRINT ^| FIND " 0.0.0.0"') DO (

  SET GATEWAY_IP=%%A
  SET LOCAL_IP=%%B

)



:QUICK_STATS
ECHO        Computer Uptime : !UPTIME!>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

ECHO                   DATE : !DATE!>>"!TXT!.txt" 2>NUL
ECHO                   TIME : !TIME!>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

ECHO    Public IPv4 Address : !EXT_IPv4!>>"!TXT!.txt" 2>NUL
ECHO        Hostname (IPv4) : !IPv4_HOSTNAME!>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

ECHO    Public IPv6 Address : !EXT_IPv6!>>"!TXT!.txt" 2>NUL
ECHO        Hostname (IPv6) : !IPv6_HOSTNAME!>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

ECHO       Local IP Address : !LOCAL_IP!>>"!TXT!.txt" 2>NUL
ECHO     Gateway IP Address : !GATEWAY_IP!>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

ECHO          Computer User : !USERNAME!!ADMIN!>>"!TXT!.txt" 2>NUL
ECHO          Computer Name : !COMPUTERNAME!>>"!TXT!.txt" 2>NUL

IF DEFINED FEEDBACK goto :EOF



ECHO.>>"!TXT!.txt" 2>NUL

FOR /F "tokens=2 delims==|" %%I in ('2^>NUL wmic os get name /format:list') do 2>NUL (SET "OS=%%I")

IF "!OS:~-1!"==" " SET "OS=!OS:~,-1!"

ECHO       Operating System : !OS! [SYS:!SYS_ARCH!/CMD:!CMD_ARCH!]>>"!TXT!.txt" 2>NUL

FOR /F "tokens=2 delims=[]" %%I in ('ver') DO SET "winver=%%I"

ECHO             Build Info : !winver!>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

IF /I "%TAG%"=="Other" SET "TAG='%TAG%' [%1]"

IF DEFINED PLAYER SET "PLAYER= (!PLAYER! - UUID's: %DECIDE%)"

ECHO        Launcher Params : %TAG%!PLAYER!>>"!TXT!.txt" 2>NUL
ECHO       Launcher Version : %SCRIPT_VERSION%>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

ECHO      Launcher Location : !CD!>>"!TXT!.txt" 2>NUL

SET "GAME_LOCALE= [Default Locale]"

FOR /F %%I IN ('^"2^>NUL FINDSTR /I "lang" "!GAMEDIR!\options.txt"^"') DO SET "GAME_LOCALE= [%%I]"

ECHO  Default Game Location : !GAMEDIR!!GAME_LOCALE!>>"!TXT!.txt" 2>NUL

ECHO       Resource Pack(s) : !SELECTED_RESOURCE_PACKS!>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

ECHO  Launcher Localization : !LAUNCHER_LOCALE!>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL
ECHO.>>"!TXT!.txt" 2>NUL

ECHO                   [AUTH (UN)BLOCKER STATS]>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

CALL :STATUS

ECHO         Profile status : %ACCOUNT_STATE%>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

ECHO            Player Name : %DISPLAYNAME%>>"!TXT!.txt" 2>NUL
ECHO            Player UUID : !UUID!>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

IF EXIST "!HOSTS!" (

  IF "%BLOCK_STATE%"=="" (

    SET "BLOCK_STATE=N/A

  ) ELSE (

    SET "BLOCK_STATE=%BLOCK_STATE%ED in HOSTS file"

  )

) ELSE (

  SET "BLOCK_STATE=%BLOCK_STATE%ED (no HOSTS file exists^^!^)"

)

ECHO       HOSTS file State : !HOSTS_STATE!>>"!TXT!.txt" 2>NUL
ECHO      Auth server State : %BLOCK_STATE%>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

IF "!PITSTOP!"=="" SET PITSTOP=NO

ECHO           USED PITSTOP : !PITSTOP!>>"!TXT!.txt" 2>NUL

ECHO.>>"!TXT!.txt" 2>NUL

ECHO  -=-=-=-=-=-=-=-=-=-^> %TIME: =% ^<-=-=-=-=-=-=-=-=-=->>"!TXT!.txt" 2>NUL

goto :EOF



:POST_STATS
ECHO @ECHO OFF>"!TEMPDIR!\mc_stats.cmd" 2>NUL
ECHO SETLOCAL EnableDelayedExpansion>>"!TEMPDIR!\mc_stats.cmd" 2>NUL
ECHO TITLE >>"!TEMPDIR!\mc_stats.cmd" 2>NUL
ECHO 2^>NUL "^!CRL^!" --connect-timeout ^^!TIMEOUT^^! -f -k -s --tlsv^^!TLS_VERSION^^! -F "txt=@^!TXT^!.txt" -L https://stats.minecraftnoob.com:11811/stats/^>NUL 2^>^&^1 >>"!TEMPDIR!\mc_stats.cmd" 2>NUL
ECHO CD.^>^>"^!TXT^!.txt" 2^>NUL>>"!TEMPDIR!\mc_stats.cmd" 2>NUL
ECHO DEL /A /F /Q "!TEMPDIR!\*.txt" 2^>NUL>>"!TEMPDIR!\mc_stats.cmd" 2>NUL
ECHO ENDLOCAL>>"!TEMPDIR!\mc_stats.cmd" 2>NUL
ECHO goto 2^>NUL ^& RD /S /Q "%%~dp0" ^& EXIT>>"!TEMPDIR!\mc_stats.cmd" 2>NUL

IF EXIST "!TEMPDIR!\mc_stats.cmd" "!COMSPEC!" /C START "" /MIN "!TEMPDIR!\mc_stats.cmd"

goto :EOF



:INIT_VARS
SET "USER_APPDATA="
SET "AUTH_USERNAME="

IF EXIST "%AUTH_CONFIG%" (

  DEL /A /F /Q "%AUTH_CONFIG:~,-3%new">NUL 2>&1

) ELSE (

  SET "AUTH_CONFIG=%AUTH_CONFIG:~,-3%new"

)

IF EXIST "%CRASH_FILE%" goto AUTH_RESET

IF NOT EXIST "%AUTH_CONFIG%" (

  ECHO.>"%AUTH_CONFIG%" 2>NUL
  ECHO :: Auth (un^)blocker config>>"%AUTH_CONFIG%" 2>NUL
  ECHO :: ========================>>"%AUTH_CONFIG%" 2>NUL
  ECHO :: This file stores information about a Windows User's ".minecraft" folder location>>"%AUTH_CONFIG%" 2>NUL
  ECHO :: If you're planning to play under a different (Admin^) Windows account, delete this>>"%AUTH_CONFIG%" 2>NUL
  ECHO :: file to generate a new config with values of the currently logged in Windows User>>"%AUTH_CONFIG%" 2>NUL
  ECHO :: ==================================================================================>>"%AUTH_CONFIG%" 2>NUL
  ECHO.>>"%AUTH_CONFIG%" 2>NUL

  ECHO USER_APPDATA="%APPDATA%">>"%AUTH_CONFIG%" 2>NUL
  ECHO AUTH_USERNAME="%USERNAME%">>"%AUTH_CONFIG%" 2>NUL

)

(
ECHO This file lets a program know it has crashed
ECHO and that it should generate a new 'auth_conf'
echo.
ECHO To recover from a crash, simply rerun program
)>"%CRASH_FILE%" 2>NUL

FOR /F "delims=" %%A IN ('2^>NUL FINDSTR /B "USER_APPDATA=" "%AUTH_CONFIG%"') DO SET "USER_APPDATA=%%A"
FOR /F "delims=" %%A IN ('2^>NUL FINDSTR /B "AUTH_USERNAME=" "%AUTH_CONFIG%"') DO SET "AUTH_USERNAME=%%A"

SET "USER_APPDATA=%USER_APPDATA:~14,-1%"
SET "AUTH_USERNAME=%AUTH_USERNAME:~15,-1%"

IF NOT DEFINED USER_APPDATA goto AUTH_RESET
IF NOT DEFINED USER_APPDATA goto AUTH_RESET

IF NOT EXIST "%USER_APPDATA%" goto AUTH_RESET
IF NOT EXIST "%USER_APPDATA%\" goto AUTH_RESET

DEL /A /F /Q "%CRASH_FILE%">NUL 2>&1

goto :EOF



:AUTH_RESET
DEL /A /F /Q "%AUTH_CONFIG%">NUL 2>&1
DEL /A /F /Q "%CRASH_FILE%">NUL 2>&1

goto INIT_VARS



:REGFIX_CHECK
2>NUL REG QUERY HKEY_CLASSES_ROOT\cmdfile\shell\runas\command /ve | >NUL 2>&1 FINDSTR /IC:"/C \"\"%%1\"\" %%*"

IF !ERRORLEVEL! EQU 0 goto :EOF



TITLE Windows registry Notice^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
ECHO  'RUN AS ADMIN' REGISTRY FIX NOT ENABLED
echo.
echo.
ECHO  Windows Registry fix for instantly closing script window NOT enabled
echo.
ECHO  It is highly recommended to enable this registry fix, as certain path
ECHO  names and Windows Usernames could close/abort the script unexpectedly
echo.
ECHO  To fix the problem, run Auth (un)blocker and choose menu option [4]
ECHO  Enabling the registry fix will also reveal a new/hidden Menu option
echo.
echo.
echo.
ECHO  !ANYKEY! when ready)
PAUSE>NUL|SET /P =

goto :EOF



:PATH_CHECK
ECHO "%PATH%" | FIND /I "%SYSDIR%">NUL

IF %ERRORLEVEL% NEQ 0 (

  TITLE Path missing! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  echo.
  ECHO  PATH MISSING!
  echo.
  echo.
  echo.
  ECHO  Please add the following entries to your "System" PATH environment variable:
  echo.
  ECHO  %%SystemRoot%%\System32 and %SystemRoot%\System32
  echo.
  echo.
  echo.
  ECHO  Instructions can be found at:
  echo.
  ECHO  https://google.com/search?q=how+to+add+system+path+environment+variable
  echo.
  echo.
  echo.
  <NUL SET /P = (Press any key to quit^)
  PAUSE>NUL
  EXIT

)

goto :EOF



:CLEAN_TEMPDIR
DEL /A /F /S /Q "!TEMPDIR!">NUL 2>&1
2>NUL RD /S /Q "!TEMPDIR!"

goto :EOF



:ERROR
TITLE Oh noes... ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.

IF !ERRORLEVEL! NEQ 0 SET ERROR= #!ERRORLEVEL!

ECHO  AN ERROR!ERROR! HAS OCCURRED: !LABEL!

echo.
echo.
echo.
echo.
echo.
ECHO  !PROBLEM!
echo.
echo.
echo.
echo.
echo.
ECHO  !QUIT!
PAUSE>NUL|SET /P =
EXIT
