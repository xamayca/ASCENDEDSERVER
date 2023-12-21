### FRANCE SURVIVAL ARK ASCENDED SERVER SCRIPT ALL IN ONE

This script is designed to streamline the setup and maintenance of an ARK: Survival Ascended server. It automates various tasks including checking and installing necessary dependencies, configuring firewall rules, downloading and installing SteamCMD, as well as managing the game server itself.

#### Mandatory and Optional Variables

:warning: NO CERTIFICATE REQUIRED :warning:

1. **Mandatory Variables:**
   - `SessionName`: The name of your server. This will appear in the ARK server list.
   - `ServerAdminPassword`: The password for server administrators.
   - `GamePort`: The main game port. Usually 7777.
   - `SecondGamePort`: The secondary game port. Used for additional functionalities. Usually 7778.
   - `QueryPort`: The port used for server queries. Usually 27015.
   - `MaxPlayers`: The maximum number of players allowed on the server.
   - `DriveLetter`: The drive letter where the server and SteamCMD will be installed. For example, `C:\`.

2. **Optional Variables:**
   - `RCONPort` and `RCONPassword`: Port and password for RCON, used for remote server management. If not set, RCON configuration is skipped.
   - `Mods`: List of mods to use on the server, separated by commas. Leave blank if no mods are used.

#### Script Features

- **Dependency Check and Installation**: The script automatically checks for and installs Visual C++ 2013 Redistributable and DirectX if necessary.
- **Firewall Rules Configuration**: It automatically configures necessary firewall rules for game ports and, if specified, for RCON port.
- **SteamCMD Download and Installation**: The script handles the downloading and installation of SteamCMD, essential for updating and installing the game server.
- **Game Server Management**: It checks if the server is installed and up to date, and launches the server with specified configurations.

#### Usage

1. Edit the variables at the top of the script with appropriate values for your server.
2. Run the script in a PowerShell or CMD environment with administrative privileges.
3. Follow the on-screen instructions for installation and configuration.

This script greatly simplifies the process of setting up and maintaining an ARK server, making it accessible even to those with limited server administration knowledge.

Contributions Welcome: Any assistance to improve this script is highly appreciated. If you have suggestions, improvements, or any feedback, please feel free to contact me. Your contributions can help enhance the server experience for everyone.