rem -- FRANCE SURVIVAL ARK: SURVIVAL ASCENDED | SERVER SCRIPT ALL IN ONE | --
rem -- Configuration variables --
set "SessionName=YOUR_SERVER_NAME_HERE"
set "ServerAdminPassword=YOUR_SERVER_PASSWORD_HERE"
set "GamePort=7777"
set "SecondGamePort=7778"
set "QueryPort=27015"
set "RCONPort="
set "RCONPassword="
set "MaxPlayers=20"
set "Mods="
set "DriveLetter=C:\"
set "SteamCMD_Dir=%DriveLetter%STEAMCMD"
set "Server_Dir=%DriveLetter%SERVER"
set "Server_Executable=ArkAscendedServer.exe"
set "Executable_Dir=%Server_Dir%\ShooterGame\Binaries\Win64"
set "SteamCMD_URL=https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
set "SteamCMD_Zip=%SteamCMD_Dir%\steamcmd.zip"

@echo off
cls
color 0A
title FRANCE SURVIVAL SERVERS SCRIPT

echo.
echo -----------------------------------
echo CHECKING VC REDIST AND DIRECTX
echo -----------------------------------
color 0E

rem -- Check and install VC Redist 2013 if necessary --
echo Checking for Visual C++ 2013 Redistributable x64...
powershell -command "& { if (Get-ItemProperty 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\12.0\VC\Runtimes\x64' -ErrorAction SilentlyContinue) { echo 'Visual C++ 2013 Redistributable x64 already installed.' } else { echo 'Visual C++ 2013 Redistributable x64 not found. Downloading...'; (New-Object System.Net.WebClient).DownloadFile('https://aka.ms/vs/16/release/vc_redist.x64.exe', '%VCRedistInstaller%'); echo 'Installing Visual C++ Redistributable...'; Start-Process -FilePath '%VCRedistInstaller%' -ArgumentList '/install', '/quiet', '/norestart' -Wait } }"

rem -- Check if DirectX is already installed --
echo Checking for DirectX installation...
powershell -command "& { if (Test-Path 'HKLM:\SOFTWARE\Microsoft\DirectX') { echo 'DirectX is already installed.' } else { echo 'DirectX is not installed. Downloading...'; (New-Object System.Net.WebClient).DownloadFile('%DirectX_URL%', '%DirectX_Installer%'); echo 'Installing DirectX...'; Start-Process -FilePath '%DirectX_Installer%' -ArgumentList '/Q' -Wait } }"
echo VC Redist and DirectX check and installation complete.


rem -- Configuration of firewall rules for RCON ports --
echo.
echo -----------------------------------
echo CONFIGURING FIREWALL RULES FOR RCON PORTS
echo -----------------------------------
color 0C
rem -- Check if RCONPort is set and not empty --
if not "%RCONPort%"=="" (
    echo Configuring firewall rules for RCON Ports...

    rem -- Checking and creating firewall rules for RCON port --
    powershell -command "& { if ((Get-NetFirewallRule -DisplayName 'ARK ASCENDED SERVER RCON PORT TCP IN' -ErrorAction SilentlyContinue) -eq $null) { New-NetFirewallRule -DisplayName 'ARK ASCENDED SERVER RCON PORT TCP IN' -Direction Inbound -LocalPort %RCONPort% -Protocol TCP -Action Allow; echo 'RCON TCP IN RULE CREATED.' } else { echo 'RCON TCP IN RULE ALREADY EXISTS.' } }"
    powershell -command "& { if ((Get-NetFirewallRule -DisplayName 'ARK ASCENDED SERVER RCON PORT TCP OUT' -ErrorAction SilentlyContinue) -eq $null) { New-NetFirewallRule -DisplayName 'ARK ASCENDED SERVER RCON PORT TCP OUT' -Direction Outbound -LocalPort %RCONPort% -Protocol TCP -Action Allow; echo 'RCON TCP OUT RULE CREATED.' } else { echo 'RCON TCP OUT RULE ALREADY EXISTS.' } }"
    echo Firewall rules for RCON ports configured.
) else (
    echo RCONPort is NOT SET. Skipping configuration of RCON firewall rules...
)
rem -- Checking firewall rules for the GAME port --
powershell -command "& { if ((Get-NetFirewallRule -DisplayName 'ARK ASCENDED SERVER GAME PORT & QUERY TCP IN' -ErrorAction SilentlyContinue) -eq $null) { New-NetFirewallRule -DisplayName 'ARK ASCENDED SERVER GAME PORT & QUERY TCP IN' -Direction Inbound -LocalPort %GamePort%,%SecondGamePort%,%QueryPort% -Protocol TCP -Action Allow; echo 'GAME & QUERY TCP IN RULES CREATED.' } else { echo 'GAME & QUERY TCP IN RULES ALREADY EXISTS.' } }"
powershell -command "& { if ((Get-NetFirewallRule -DisplayName 'ARK ASCENDED SERVER GAME PORT & QUERY UDP IN' -ErrorAction SilentlyContinue) -eq $null) { New-NetFirewallRule -DisplayName 'ARK ASCENDED SERVER GAME PORT & QUERY UDP IN' -Direction Inbound -LocalPort %GamePort%,%SecondGamePort%,%QueryPort% -Protocol UDP -Action Allow; echo 'GAME & QUERY UDP IN RULES CREATED.' } else { echo 'GAME & QUERY UDP IN RULES ALREADY EXISTS.' } }"
powershell -command "& { if ((Get-NetFirewallRule -DisplayName 'ARK ASCENDED SERVER GAME PORT & QUERY TCP OUT' -ErrorAction SilentlyContinue) -eq $null) { New-NetFirewallRule -DisplayName 'ARK ASCENDED SERVER GAME PORT & QUERY TCP OUT' -Direction Outbound -LocalPort %GamePort%,%SecondGamePort%,%QueryPort% -Protocol TCP -Action Allow; echo 'GAME & QUERY TCP OUT RULES CREATED.' } else { echo 'GAME & QUERY TCP OUT RULES ALREADY EXISTS.' } }"
powershell -command "& { if ((Get-NetFirewallRule -DisplayName 'ARK ASCENDED SERVER GAME PORT & QUERY UDP OUT' -ErrorAction SilentlyContinue) -eq $null) { New-NetFirewallRule -DisplayName 'ARK ASCENDED SERVER GAME PORT & QUERY UDP OUT' -Direction Outbound -LocalPort %GamePort%,%SecondGamePort%,%QueryPort% -Protocol UDP -Action Allow; echo 'GAME & QUERY UDP OUT RULES CREATED.' } else { echo 'GAME & QUERY UDP OUT RULES ALREADY EXISTS.' } }"
echo Firewall rules for Game and Query ports configured.

echo.
echo -----------------------------------
echo CHECKING DRIVE INSTALLATION
echo -----------------------------------
color 0E

:CheckDrive
rem -- Check if specified drive exists --
powershell -command "if (Test-Path '%DriveLetter%') { exit 0 } else { exit 1 }"

if errorlevel 1 (
    echo Drive %DriveLetter% not found.
    echo Please verify the drive letter and press any key to retry...
    pause
    goto CheckDrive
)

echo Drive %DriveLetter% found.

echo.
echo -----------------------------------
echo CREATING DIRECTORIES
echo -----------------------------------
color 0B
rem -- Check and create \STEAMCMD directory if it doesn't exist --
if not exist "%SteamCMD_Dir%" (
    mkdir "%SteamCMD_Dir%"
    echo Created directory: %SteamCMD_Dir%
) else (
    echo Directory %SteamCMD_Dir% already exists.
)
rem -- Check and create \SERVER directory if it doesn't exist --
if not exist "%Server_Dir%" (
    mkdir "%Server_Dir%"
    echo Created directory: %Server_Dir%
) else (
    echo Directory %Server_Dir% already exists.
)

echo.
echo -----------------------------------
echo DOWNLOADING AND EXTRACTING STEAMCMD
echo -----------------------------------
color 0C
rem -- Download and Extract SteamCMD --
if not exist "%SteamCMD_Zip%" (
    echo Downloading SteamCMD...
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%SteamCMD_URL%', '%SteamCMD_Zip%')"
    echo Download complete.
    echo Extracting SteamCMD...
    powershell -Command "Expand-Archive -LiteralPath '%SteamCMD_Zip%' -DestinationPath '%SteamCMD_Dir%'"
    echo SteamCMD installed successfully.
) else (
    echo SteamCMD already downloaded.
)

echo.
echo -----------------------------------
echo CHECKING SERVER INSTALLATION
echo -----------------------------------
color 0A
rem -- Check if the server is already installed --
if exist "%Executable_Dir%\%Server_Executable%" (
    echo Server already installed.
) else (
    echo Installing server using SteamCMD...
    "%SteamCMD_Dir%\steamcmd.exe" +force_install_dir "%Server_Dir%" +login anonymous +app_update 2430930 validate +quit
    echo Server installation complete.
)

echo.
echo -----------------------------------
echo CHECKING FOR SERVER FILES
echo -----------------------------------
color 0F
rem -- Check if the ShooterGame\Saved directory exists --
if exist "%Server_Dir%\ShooterGame\Saved" (
    echo Server files already exist.
) else (
    echo Creating initial server files...
    start "" "%Executable_Dir%\%Server_Executable%" -NoBattlEye
    echo Server process started, waiting for 10 seconds...
    timeout /t 10
    echo Terminating server process...
    taskkill /im "%Server_Executable%" /f /t
)

echo.
echo -----------------------------------
echo SERVER MAINTENANCE AND MONITORING
echo -----------------------------------
color 09
:start
rem -- Checking server process --
tasklist /nh /fi "Imagename eq %Server_Executable%" | find /i "%Server_Executable%" >nul
if ERRORLEVEL 1 goto update
if ERRORLEVEL 0 goto close

:update
color 0D

echo.
echo -----------------------------------
echo SEARCHING FOR GAME UPDATES, PLEASE WAIT...
echo -----------------------------------
start "" /b /w /high "%SteamCMD_Dir%\steamcmd.exe" +force_install_dir "%Server_Dir%" +login anonymous +app_update 2430930 validate +quit
echo Server should now be running! Check in the task manager.

echo.
rem -- Server startup with different configurations --
rem -- Define base server launch command --
set "LaunchCommand=start "" /w /high "%Executable_Dir%\%Server_Executable%" TheIsland_WP?listen?SessionName="%SessionName%"?ServerAdminPassword=%ServerAdminPassword%?Port=%GamePort%?QueryPort=%QueryPort%"

rem -- Add RCON options if both RCONPort and RCONPassword are set --
if not "%RCONPort%"=="" if not "%RCONPassword%"=="" (
    set "LaunchCommand=%LaunchCommand%?RCONEnabled=True?RCONPort=%RCONPort%?RCONPassword=%RCONPassword%"
    echo RCON options added to the launch command...
)

rem -- Add Mods options if set --
if not "%Mods%"=="" (
    set "LaunchCommand=%LaunchCommand% -AutoManagedMods -mods=%Mods%"
    echo Mods options added to the launch command...
)

rem -- Add remaining launch options --
set "LaunchCommand=%LaunchCommand% -NoTransferFromFiltering -WinLiveMaxPlayers=%MaxPlayers% -forcerespawndinos -crossplay-enable-pc -crossplay-enable-wingdk -crossplay-enable-xsx -crossplay-enable-ps5"

rem -- Launch the server with the configured options --
%LaunchCommand%
echo Server launched with the configured options.

color 0C
echo Crash detected!
echo.
echo Press CTRL+C to interrupt before restarting
timeout /t 15
goto start

:close
color 0E
echo.
echo !ERROR! SERVER IS ALREADY RUNNING! STOPPING THE SERVER
taskkill /im "%Server_Executable%" /f /t
timeout /t 3
goto start

color 07
pause