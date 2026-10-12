@ECHO OFF

"%SystemRoot%\System32\MODE" CON COLS=80 LINES=25>NUL 2>&1

ENDLOCAL

SET "AUTH_DP0=%~dp0"
SET "AUTH_FILE0=%~f0"

PUSHD "%AUTH_DP0%"



CALL "Minecraft Launcher.cmd" -colors 2>NUL



SET "TITLEHEADER=copyitright's Minecraft Authentication (un^)blocker"
SET SCRIPT_VERSION=20022021-0426

TITLE %TITLEHEADER% ^| %SCRIPT_VERSION%



FOR %%a in ("%CD%") do SET DIR=%%~na

IF /I NOT "%DIR%"=="Minecraft (copyitright)" (

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



SETLOCAL EnableExtensions EnableDelayedExpansion

SET WEBSITE=https://www.playfreeminecraft.nl
SET DISCORD_SHORT=https://discord.gg/4xHvdYG

SET BODYHEADER=   %TITLEHEADER% ^| Build %SCRIPT_VERSION%
SET SERVER_URLS_1= Website: !WEBSITE:~8!    Server: join.!WEBSITE:~12!:25565
SET SERVER_URLS_2=  Chat/Support: !DISCORD_SHORT:~8!    Backup: the.minecraftnoob.com:25565
SET SPACER=------------------------------------------------------------------------------

SET ANYKEY=(Press any key
SET CONTINUE=!ANYKEY! continue)
SET RETURN=!ANYKEY! to return to menu)
SET QUIT=!ANYKEY! to quit)

SET AUTH_CONFIG=auth_conf
SET LAUNCHER_CONFIG=firstrun

SET "JQ=!AUTH_DP0!exe\jq-win32.exe"
SET "LAUNCHER=!AUTH_DP0!Minecraft Launcher.cmd"

SET "CONTEXT_TWEAKER_DL=https://www.playfreeminecraft.nl/downloads/context_menu_tweak.zip"

SET "ACCOUNTS=!USER_APPDATA!\.minecraft\launcher_accounts.json"
SET "PROFILES=!USER_APPDATA!\.minecraft\launcher_profiles.json"

SET "PROFILE_ENTRY=added by copyitright's launcher | don't modify | !WEBSITE:~8!"
SET DEFAULT_UUID=00000000000000000000000000000000

SET "SYSDIR=%SystemRoot%\System32"

SET AUTH_SERVER=authserver.mojang.com
SET LIBS_SERVER=libraries.minecraft.net
SET MODS_SERVER=files.minecraftforge.net

SET "BLOCKER_ENTRIES=!LIBS_SERVER! !MODS_SERVER! web.minecraftnoob.com"

SET LF=^



IF /I NOT "%~nx0"=="Auth (un)blocker.cmd" (
  SET OBJECT=SCRIPT "Auth (un)blocker.cmd"
  goto NOTFOUND
)

IF NOT EXIST "Minecraft Launcher.cmd" (

  SET OBJECT=APPLICATION "Minecraft Launcher.cmd"
  goto NOTFOUND

)



>NUL 2>&1 REG QUERY "HKEY_USERS\S-1-5-19" && SET "ADMIN= "



IF EXIST "%AUTH_CONFIG%.new" CALL :WELCOME



IF NOT EXIST "!SYSDIR!\drivers\etc\" (

  IF DEFINED ADMIN (

    DEL /A /F /Q "!SYSDIR!\drivers\etc">NUL 2>&1

    2>NUL MD "!SYSDIR!\drivers\etc"

  )

)  

PUSHD "!SYSDIR!\drivers\etc" 2>NUL

IF !ERRORLEVEL! NEQ 0 (

  SET LABEL=CAN'T CHANGE TO SYSTEM DIR
  goto ERROR

)

ATTRIB +R +S +H "HOSTS.block">NUL 2>&1
ATTRIB +R +S +H "HOSTS.unblock">NUL 2>&1



SET "RESET="

IF NOT EXIST HOSTS SET "RESET= "
IF NOT EXIST HOSTS.unblock SET "RESET= "
IF NOT EXIST HOSTS.block SET "RESET= "



IF DEFINED RESET goto INVALID_HOSTS_ENTRY

IF "%1"=="PITSTOP" goto INVALID_HOSTS_ENTRY

IF "!ADMIN!"=="" goto CHOOSER



CALL :PROCESS_CHECK
CALL :STATUS
CALL :BLOCKING_STRATEGY



:DONE
TITLE Auth server '%BLOCK_STATE%ED'^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.

DEL /A /F /Q HOSTS>NUL 2>&1

CALL :SET_BLOCK_STATE

>NUL IPCONFIG /FLUSHDNS

ECHO  AUTHENTICATION SERVER HAS BEEN '%BLOCK_STATE%ED' IN THE HOSTS FILE
echo.
echo.
echo.

IF /I "%BLOCK_STATE%"=="BLOCK" (

  ECHO   You can now play the full game as a "CRACKED" user
  ECHO   (online play *only* possible on unofficial servers^)
  echo.
  echo.
  ECHO   Run this script again to play using an OFFICIAL account
  echo.

) ELSE (

  IF /I "%BLOCK_STATE%"=="UNBLOCK" (

    ECHO   You can now play Minecraft using a LEGITIMATE or OFFICIAL game account
    ECHO   (online play on official servers *only* possible when purchasing game^)
    echo.
    echo.
    ECHO   Run this script again to play as a "CRACKED" user
    echo.

  )

)



echo.
echo.
ECHO  !QUIT!
PAUSE>NUL|SET /P =
EXIT



:BLOCKING_STRATEGY
IF /I "%BLOCK_STATE%"=="BLOCK" (

  SET BLOCK_STATE=block

  CALL :BACKUP_CURRENT_STATE

  SET BLOCK_STATE=UNBLOCK

) ELSE (

  IF /I "%BLOCK_STATE%"=="UNBLOCK" (

    SET BLOCK_STATE=unblock

    CALL :BACKUP_CURRENT_STATE

    SET BLOCK_STATE=BLOCK

  ) ELSE (

    IF /I "%BLOCK_STATE%"=="NOT BLOCK" SET BLOCK_STATE=BLOCK

  )

)

goto :EOF



:STATUS
CALL :CHECK_BLOCK_STATE
CALL :CHECK_LAUNCHER_FILE

IF DEFINED ADMIN IF "%1"=="" goto :EOF

CALL :NOTIFY_STATE



TITLE Status ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

IF NOT DEFINED MSG SET MSG=ED in HOSTS file

SET SUPPORTED=SUPPORTED
SET NOT_SUPPORTED=NOT SUPPORTED (unofficial servers only)

IF /I "%BLOCK_STATE%"=="NOT BLOCK" (

  SET MESSAGE= "CRACKED" PROFILE
  SET LEGITIMATE_ACCOUNTS=!SUPPORTED!

) ELSE (

  IF /I "%BLOCK_STATE%"=="UNBLOCK" (

    SET MESSAGE= "CRACKED" PROFILE
    SET LEGITIMATE_ACCOUNTS=!SUPPORTED!

  ) ELSE (

    IF /I "%BLOCK_STATE%"=="BLOCK" (

      SET MESSAGE=N *OFFICIAL* ACCOUNT
      SET LEGITIMATE_ACCOUNTS=!NOT_SUPPORTED!

    )

  )

)



SET "TEXT=TO USE A!MESSAGE!"
SET "TEXT_EXTRA=, CHOOSE MENU OPTION [2] OR RERUN SCRIPT AS ADMIN"

IF "%BLOCK_STATE%"=="" (

  SET "TEXT=TO REPAIR HOSTS FILE PROBLEMS"
  SET LEGITIMATE_ACCOUNTS=N/A

)



SET "UUID="



IF /I "%ACCOUNT_STATE%"=="CRACKED" (

  IF NOT "!OUTPUT!"=="!PROFILE_ENTRY!" SET "ACCOUNT_STATE=CRACKED (modified user entry)"

) ELSE (

  IF /I "%ACCOUNT_STATE%"=="LEGITIMATE" (

    IF "%DISPLAYNAME%"=="" (

      IF /I "!ACCOUNT_TYPE!"=="Xbox" (

        SET "ACCOUNT_STATE=XBOX (not supported yet...)"
        SET "DISPLAYNAME=!OUTPUT!"
        SET UUID=N/A

      ) ELSE (
      
        SET "ACCOUNT_STATE=DEMO (buy game to play on official servers)"
        SET "DISPLAYNAME=Player"
        SET "UUID=!DEFAULT_UUID!"

      )

    )

  ) ELSE (

    IF /I "%ACCOUNT_STATE%"=="UNSELECTED" (

      SET "ACCOUNT_STATE=UNKNOWN (select user/account first)"

    )

  )

)



IF DEFINED SELECTED_USER (

  FOR /F "delims=" %%I in ('^""%JQ%" -r ".accounts.\"!SELECTED_USER!\".minecraftProfile.id|select(.^!=null)" "!ACCOUNTS!"^" 2^>NUL') do SET UUID=%%I

)



IF DEFINED UUID (SET "UUID='!UUID!'") ELSE (SET UUID=N/A)
IF DEFINED DISPLAYNAME (SET "DISPLAYNAME='%DISPLAYNAME%'") ELSE (SET "DISPLAYNAME=N/A")



SET "TRIMMED_APPDATA=!USER_APPDATA!"
SET "TEMP_APPDATA=!USER_APPDATA:~52!"

IF DEFINED TEMP_APPDATA SET "TRIMMED_APPDATA=!USER_APPDATA:~,51!~"

echo.
echo.
ECHO  !TEXT!!TEXT_EXTRA!
echo.
echo.
ECHO               User Type: %ACCOUNT_STATE%
ECHO          AppData Folder: '!TRIMMED_APPDATA!'
echo.
ECHO             Player Name: %DISPLAYNAME%
ECHO             Player UUID: !UUID!
echo.
ECHO       Auth server State: %BLOCK_STATE%!MSG!
ECHO       Official accounts: !LEGITIMATE_ACCOUNTS!
echo.
ECHO    Update notifications: %UN%
echo.
echo.
ECHO  !RETURN!
PAUSE>NUL|SET /P =

goto CHOOSER



:HELP
TITLE Instructions  ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
ECHO                              - USAGE INSTRUCTIONS -
echo.
echo.
echo.
ECHO    There's not much to it. LEGITIMATE Minecraft owners keep the Auth. server
ECHO    UNBLOCKED at all times, whereas "CRACKED" Minecraft users keep it BLOCKED
echo.
ECHO    When switching between block states, 'Auth (un^)blocker' uses the values it
ECHO    finds in '%AUTH_CONFIG%'. It no longer matters if someone with another Windows
ECHO    account (un^)blocks the Auth server. If considering to play the game under a
ECHO    different Windows account, delete '%AUTH_CONFIG%' to generate new config values
echo.
echo.
echo.
ECHO  !ANYKEY! to see who supports my work)
PAUSE>NUL|SET /P =

TITLE Thank you All^^!  ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
ECHO                          - A (VERY) SPECIAL THANK YOU -
echo.
echo.
ECHO  First off, I would like to thank ALL the people that use(d) my Launcher :-)
ECHO  I also want to thank EVERYONE who('ve) support(ed) me (you know who you are^^!)
echo.
echo.
ECHO                           The people who have donated:
echo.
ECHO                 Medicijnman (Dennis H.)    ReasyKO (Ken K.)
ECHO                     CelBlue (Mla H.)      ShayShay (Shayenne B.)
echo.
ECHO                 =^> ^^!YOUR CONTRIBUTION IS GREATLY APPRECIATED^^! ^<=
echo.
echo.
ECHO  !RETURN!
PAUSE>NUL|SET /P =

goto CHOOSER



:CHECK_BLOCK_STATE
TITLE Checking HOSTS... ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

SET "MSG="
SET "BLOCK_STATE="
SET "HOSTS_STATE=GOOD"
SET "HOSTS_PROBLEM=N/A (HOSTS problems detected)"

ATTRIB -R -S -H HOSTS>NUL 2>&1

IF EXIST HOSTS (

  >NUL 2>&1 FINDSTR /I "!BLOCKER_ENTRIES!" HOSTS
  IF !ERRORLEVEL! EQU 0 SET "HOSTS_STATE=!HOSTS_PROBLEM!"

  >NUL 2>&1 FINDSTR /BIRC:".*127.0.0.1 *!AUTH_SERVER!" HOSTS
  IF !ERRORLEVEL! EQU 0 SET "HOSTS_STATE=!HOSTS_PROBLEM!"



  >NUL 2>&1 FINDSTR /BIRC:" *0.0.0.0 *!AUTH_SERVER!" HOSTS

  IF !ERRORLEVEL! EQU 0 (

    SET BLOCK_STATE=BLOCK

    2>NUL FINDSTR /V /BIRC:" *0.0.0.0 *!AUTH_SERVER!" HOSTS | >NUL 2>&1 FINDSTR /I "!AUTH_SERVER!"

    IF !ERRORLEVEL! EQU 0 SET "HOSTS_STATE=!HOSTS_PROBLEM!"

  ) ELSE (

    >NUL 2>&1 FINDSTR /BIRC:" *# *0.0.0.0 *!AUTH_SERVER!" HOSTS

    IF !ERRORLEVEL! EQU 0 (

      2>NUL FINDSTR /V /BIRC:" *# *0.0.0.0 *!AUTH_SERVER!" HOSTS | >NUL 2>&1 FINDSTR /I "!AUTH_SERVER!"

      IF !ERRORLEVEL! EQU 0 (

        SET "HOSTS_STATE=!HOSTS_PROBLEM!"

      ) ELSE (

        SET BLOCK_STATE=UNBLOCK

      )

    ) ELSE (

      >NUL 2>&1 FINDSTR /I "!AUTH_SERVER!" HOSTS

      IF !ERRORLEVEL! EQU 0 (

        SET "HOSTS_STATE=!HOSTS_PROBLEM!"

      ) ELSE (

        SET BLOCK_STATE=NOT BLOCK

      )

    )

  )

) ELSE (

  SET "HOSTS_STATE=!HOSTS_PROBLEM!"

  SET BLOCK_STATE=NOT BLOCK

  SET MSG=ED (no HOSTS file exists^^!^)

)



IF NOT "!HOSTS_STATE!"=="GOOD" (

  IF DEFINED IGNORE (

    IF EXIST HOSTS SET "MSG=!HOSTS_STATE!"

    goto :EOF

  )

  goto INVALID_HOSTS_ENTRY

)

goto :EOF



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



:CLEAN_START
ATTRIB -R -S -H HOSTS*>NUL 2>&1
DEL /A /F /Q HOSTS.block>NUL 2>&1
DEL /A /F /Q HOSTS.unblock>NUL 2>&1

CALL :HOSTS_BACKUP

goto :EOF



:HEADER
CLS
echo.
ECHO  !BODYHEADER!
ECHO  %SPACER%
ECHO  !SERVER_URLS_1!
ECHO  !SERVER_URLS_2!
ECHO  %SPACER%

goto :EOF



:BACKUP_CURRENT_STATE
IF EXIST "HOSTS.%BLOCK_STATE%" (
  ATTRIB -R -S -H "HOSTS.%BLOCK_STATE%">NUL 2>&1
  DEL /A /F /Q "HOSTS.%BLOCK_STATE%">NUL 2>&1
)

COPY HOSTS "HOSTS.%BLOCK_STATE%">NUL 2>&1

ATTRIB +R +S +H "HOSTS.%BLOCK_STATE%">NUL 2>&1

goto :EOF



:WRITE_BLOCK_STATE
ATTRIB -R -S -H "HOSTS.%BLOCK_STATE%">NUL 2>&1

ECHO ####################################>>"HOSTS.%BLOCK_STATE%" 2>NUL
ECHO ## COPYITRIGHT'S AUTH (UN)BLOCKER ##>>"HOSTS.%BLOCK_STATE%" 2>NUL
ECHO # HTTPS://WWW.PLAYFREEMINECRAFT.NL #>>"HOSTS.%BLOCK_STATE%" 2>NUL
ECHO ####################################>>"HOSTS.%BLOCK_STATE%" 2>NUL
ECHO !HASH!0.0.0.0 !AUTH_SERVER!     !HASH!>>"HOSTS.%BLOCK_STATE%" 2>NUL
ECHO ####################################>>"HOSTS.%BLOCK_STATE%" 2>NUL

ATTRIB +R +S +H "HOSTS.%BLOCK_STATE%">NUL 2>&1

goto :EOF



:SET_BLOCK_STATE
ATTRIB -R -S -H "HOSTS.%BLOCK_STATE%">NUL 2>&1
COPY "HOSTS.%BLOCK_STATE%" HOSTS>NUL 2>&1
ATTRIB +R +S +H "HOSTS.%BLOCK_STATE%">NUL 2>&1

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



:HOSTS_BACKUP
IF NOT EXIST HOSTS (

  ECHO # 127.0.0.1 localhost>HOSTS 2>NUL
  ECHO # ::1 localhost>>HOSTS 2>NUL

)

ATTRIB -R -S -H "HOSTS-good.cir">NUL 2>&1

>NUL 2>&1 FINDSTR /IV "!BLOCKER_ENTRIES! ################################ !AUTH_SERVER! copyitright %WEBSITE%" HOSTS>"HOSTS-good.cir"

ECHO.>>"HOSTS-good.cir" 2>NUL

COPY "HOSTS-good.cir" "HOSTS">NUL 2>&1
COPY "HOSTS-good.cir" "HOSTS.backup">NUL 2>&1

DEL /A /F /Q "HOSTS-good.cir">NUL 2>&1

goto :EOF



:PREPARE
SET BLOCK_STATE=unblock

CALL :BACKUP_CURRENT_STATE

SET HASH=#

CALL :WRITE_BLOCK_STATE

IF NOT EXIST HOSTS.unblock (

  SET ERR=!ERRORLEVEL!
  SET LABEL=UNABLE TO CREATE 'HOSTS.%BLOCK_STATE%'

  goto ERROR

)



SET BLOCK_STATE=block

CALL :BACKUP_CURRENT_STATE

SET HASH=

CALL :WRITE_BLOCK_STATE

IF NOT EXIST HOSTS.block (

  SET ERR=!ERRORLEVEL!
  SET LABEL=UNABLE TO CREATE 'HOSTS.%BLOCK_STATE%'

  goto ERROR

)



CALL :CHECK_LAUNCHER_FILE

IF /I NOT "%ACCOUNT_STATE%"=="CRACKED" SET BLOCK_STATE=unblock

CALL :SET_BLOCK_STATE

goto :EOF



:WELCOME
CALL :HEADER

echo.
echo.
echo.
echo.
ECHO  WELCOME TO AUTH (UN)BLOCKER^^!
echo.
echo.
echo.
ECHO  With this program you can (un)block the Minecraft Authentication server
ECHO  This gives you the opportunity to play as "CRACKED" and LEGITIMATE user
echo.
ECHO  When running the program with ADMIN privileges, it will SKIP the option menu
ECHO  If you face any kind of issues, visit %DISCORD_SHORT% for support
echo.
ECHO                                                                 - copyitright
echo.
echo.

IF DEFINED ADMIN (

  ECHO  !ANYKEY! to CHANGE the block state^)

) ELSE (

  ECHO  !ANYKEY! to go to the Main Menu^)

)

PAUSE>NUL|SET /P =

>NUL 2>&1 REN "%AUTH_CONFIG%.new" "%AUTH_CONFIG%.cir"

goto :EOF



:PROCESS_CHECK
TITLE Checking processes.. ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

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



:INVALID_HOSTS_ENTRY
IF DEFINED ADMIN (

  IF "%1"=="" (

    SET OPTION=PITSTOP

  ) ELSE (

    CALL :CLEAN_START
    CALL :PREPARE

    goto FILES_REPAIRED

  )

)

TITLE Problem(s) detected.. ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.

IF EXIST HOSTS (

  SET PROBLEMS=INVALID HOSTS ENTRIES DETECTED

) ELSE (

  SET PROBLEMS=HOSTS FILE IS MISSING

)

SET PROBLEMS_MULTI=MULTIPLE PROBLEMS DETECTED

IF NOT EXIST "HOSTS.unblock" SET PROBLEMS=!PROBLEMS_MULTI!
IF NOT EXIST "HOSTS.block" SET PROBLEMS=!PROBLEMS_MULTI!

ECHO  !PROBLEMS!

echo.
echo.
echo.

IF EXIST HOSTS (

  ECHO  One or more problems with the HOSTS and/or block state files were detected
  ECHO  Auth (un^)blocker will backup current HOSTS and try to resolve the problems
  echo.

) ELSE (

  echo.
  echo.
  ECHO  One or more important files appear to be missing. They will be regenerated

)

ECHO  Depending on the settings User Account Control may ask for your permission
echo.
echo.
echo.
echo.
ECHO  !ANYKEY! to fix the problems)
PAUSE>NUL|SET /P =

goto REQUEST_PRIVILEGES



:FILES_REPAIRED
TITLE Success^^! ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
echo.
echo.
echo.
ECHO  PROBLEMS RESOLVED
echo.
echo.
echo.
echo.
ECHO  Missing or invalid HOSTS entries/block states were repaired. A backup was made
echo.
echo.
echo.
echo.
echo.
echo.
ECHO  !RETURN!
PAUSE>NUL|SET /P =

goto CHOOSER



:NOTIFY_STATE
SET "UN="

FOR /F "delims=^= tokens=2" %%A IN ('2^>NUL FINDSTR /B "UPDATE_NOTES=" "!AUTH_DP0!%LAUNCHER_CONFIG%"') DO SET "UN=%%A"

IF "%UN%"=="" (

  SET UN=YES

) ELSE (

  IF NOT "%UN%"=="YES" (

    IF NOT "%UN%"=="NO" (SET UN=YES) ELSE (SET UN=NO)

  ) ELSE (

    SET UN=YES

  )

)

goto :EOF



:CHOOSER
SET "IGNORE= "
SET "OPTION="

CALL :CHECK_BLOCK_STATE

TITLE Make a choice.. ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

CALL :HEADER

echo.
echo.
ECHO                       WELCOME TO THE AUTH (UN)BLOCKER MENU
echo.
echo.

IF "!AUTH_USERNAME!"=="" SET "AUTH_USERNAME=!USERNAME!"

ECHO   Active Windows User: '!AUTH_USERNAME:~,20!'
echo.

ECHO  [1] = View HOSTS and User Information

SET "TEXT=[2]"

IF "!HOSTS_STATE!"=="GOOD" (

  SET BLOCK_STATE_PREFIX=Unb

  IF /I NOT "%BLOCK_STATE%"=="BLOCK" SET BLOCK_STATE_PREFIX=B

  ECHO  !TEXT! = !BLOCK_STATE_PREFIX!lock the Minecraft Auth server

) ELSE (

  ECHO  !TEXT! = Repair HOSTS file related problems

)

ECHO  [3] = Help/Instructions/List of donors
echo.

CALL :REGFIX_CHECK

ECHO  [4] = !TEXT!
echo.
ECHO  [5] = Exit 'Auth (un)blocker'
echo.

IF DEFINED FIX echo.

echo.

SET /P OPTION=Your choice: 

IF "!OPTION!"=="1" goto STATUS

IF "!OPTION!"=="2" (

  IF "!HOSTS_STATE!"=="GOOD" (goto REQUEST_PRIVILEGES) ELSE (goto INVALID_HOSTS_ENTRY)

)

IF "!OPTION!"=="3" goto HELP

IF "!OPTION!"=="4" (

  IF DEFINED FIX (CALL :REGFIX_APPLY) ELSE (START "" "%CONTEXT_TWEAKER_DL%")

)

IF "!OPTION!"=="5" EXIT

goto CHOOSER



:REQUEST_PRIVILEGES
IF DEFINED ADMIN "!AUTH_FILE0!" !OPTION!

IF DEFINED OPTION SET "OPTION=[!OPTION!]"

IF NOT "!HOSTS_STATE!"=="GOOD" SET OPTION=PITSTOP

SET PS=pwsh.exe

>NUL 2>&1 !PS! /?

IF !ERRORLEVEL! NEQ 0 (

  SET PS=powershell.exe

  >NUL 2>&1 !PS! /?

  IF !ERRORLEVEL! NEQ 0 (

    SET "PS=!SYSDIR!\WindowsPowerShell\v1.0\powershell.exe"

  )

)

PUSHD "!AUTH_DP0!"

>NUL 2>&1 "!PS!" -command Start-Process '%~nx0' !OPTION! -verb runas

IF !ERRORLEVEL! NEQ 0 (

  TITLE No PowerShell? ^| %TITLEHEADER% ^| %SCRIPT_VERSION%

  CALL :HEADER

  echo.
  echo.
  echo.
  echo.
  ECHO  ELEVATION ATTEMPT FAILED^^!
  echo.
  echo.
  ECHO  Auth (un^)blocker failed to invoke an elevation method using Windows PowerShell
  ECHO  It is possible that Windows Powershell isn't enabled/installed on this system
  echo.
  ECHO  If you choose to continue, the script will attempt a different
  ECHO  elevation method that is known for triggering Windows Security
  echo.
  ECHO  My advice? (re^)install/enable Powershell or right-click
  ECHO  the script or shortcut and select 'Run as Adminstrator'
  echo.
  echo.
  ECHO  !CONTINUE!
  PAUSE>NUL|SET /P =

  mshta.exe "javascript: var shell = new ActiveXObject('shell.application'); shell.ShellExecute('%~nx0', '!OPTION!', '', 'runas', 1); close();"

)

EXIT



:REGFIX_CHECK
SET "FIX="

SET "TEXT=Download my latest Windows Context Menu Tweak!LF!       (this opens the default assigned Web browser)"

2>NUL REG QUERY HKEY_CLASSES_ROOT\cmdfile\shell\runas\command /ve | >NUL 2>&1 FINDSTR /IC:"/C \"\"%%1\"\" %%*"

IF !ERRORLEVEL! NEQ 0 (

  SET "TEXT=Apply 'Run as Administrator' registry fix"

  SET "FIX= "

)

goto :EOF



:REGFIX_APPLY
ECHO @ECHO OFF>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO PUSHD "%%~dp0">>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO ^>NUL 2^>^&^1 REG QUERY "HKEY_USERS\S-1-5-19" ^&^& SET "ADMIN= ">>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO IF DEFINED ADMIN goto REG_FIX>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO SETLOCAL EnableDelayedExpansion>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO SET PS=pwsh.exe>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO ^>NUL 2^>^&^1 ^^!PS^^! /?>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO IF ^^!ERRORLEVEL^^! NEQ 0 (>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO SET PS=powershell.exe>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO ^>NUL 2^>^&^1 ^^!PS^^! /?>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO IF ^^!ERRORLEVEL^^! NEQ 0 (>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO SET "PS=%%SystemRoot%%\System32\WindowsPowerShell\v1.0\powershell.exe">>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO )>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO )>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO ^>NUL 2^>^&^1 "^!PS^!" -command Start-Process '%%~nx0' -verb runas>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO IF ^^!ERRORLEVEL^^! NEQ 0 (>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO mshta.exe "javascript: var shell = new ActiveXObject('shell.application'); shell.ShellExecute('%%~nx0', '', '', 'runas', 1); close();">>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO )>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO ENDLOCAL>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO EXIT>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO :REG_FIX>>"!PUBLIC!\reg_fix.cmd" 2>NUL
ECHO ^>NUL 2^>^&^1 REG ADD HKEY_CLASSES_ROOT\cmdfile\shell\runas\command /ve /t REG_EXPAND_SZ /d ^^"^%%%%SystemRoot^%%%%\System32\cmd.exe /C \"\"%%%%1\"\" %%%%*^" /F>>"!PUBLIC!\reg_fix.cmd" 2>NUL

IF EXIST "!PUBLIC!\reg_fix.cmd" START "" /B /WAIT "!PUBLIC!\reg_fix.cmd"

>NUL PING -n 2 0.0.0.0

DEL /A /F /Q "!PUBLIC!\reg_fix.cmd">NUL 2>&1

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
ECHO  If the problem persists, visit my website for info or message me on Discord
echo.
echo.
echo.
echo.
echo.
ECHO  !QUIT!
PAUSE>NUL|SET /P =
EXIT
