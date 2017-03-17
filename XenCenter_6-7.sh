#!/bin/bash
# Date : (2017-03-17 08:00)
# Last revision : (2017-03-17 18:00)
# Wine version used : 2.3
# Distribution used to test : Linux Mint 18.1 x64
# Author : José Gonçalves
# Licence : Retail
# Only For : http://www.playonlinux.com
 
## Begin Note ##
# 
## End Note ##
 
[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"
 
TITLE="XenCenter 6 and 7"
PREFIX="XenCenter"
FILENAME="XenServerSetup.exe"
EDITOR="The Xen Project XenSource, Inc."
GAME_URL="https://xenserver.org/download-older-versions-of-xenserver.html"
AUTHOR="José Gonçalves"
GAME_VMS="128"
 
# Starting the script
POL_GetSetupImages "https://raw.githubusercontent.com/Tosta-Mixta/XenCenter-PlayOnLinux/master/xen_logo.png" "https://raw.githubusercontent.com/Tosta-Mixta/XenCenter-PlayOnLinux/master/left.jpg" "$TITLE"
POL_SetupWindow_Init
POL_SetupWindow_SetID 
 
# Starting debugging API
POL_Debug_Init
 
POL_SetupWindow_presentation "$TITLE" "$EDITOR" "$GAME_URL" "$AUTHOR" "$PREFIX"
 
# Setting Wine Version
WORKING_WINE_VERSION="2.3"
 
# Setting prefix path
POL_Wine_SelectPrefix "$PREFIX"
 
# Choose a 32-Bit or 64-Bit architecture
POL_SetupWindow_menu_list "$(eval_gettext 'Select architecture')" "$TITLE" "auto~x86~amd64" "~" "auto"
ARCHITECTURE="$APP_ANSWER"
 
# Downloading wine if necessary and creating prefix
POL_System_SetArch "$ARCHITECTURE"
POL_Wine_PrefixCreate "$WORKING_WINE_VERSION"

# Seems to help with random crash issue
Set_OS "win7"

# Installing additional components
POL_Call POL_install_dotnet40 
POL_Call POL_Install_ie8
POL_Call POL_Install_tahoma2

# Choose between Downloading client or using local one
POL_SetupWindow_InstallMethod "DOWNLOAD,LOCAL"
 
# Asking about memory size of graphic card
POL_SetupWindow_VMS $GAME_VMS
 
# Set Graphic Card information keys for wine
POL_Wine_SetVideoDriver

# Downloading client or choosing existing one
mkdir -p "$WINEPREFIX/drive_c/$PROGRAMFILES/XenCenter/XenCenter6"

if [ "$INSTALL_METHOD" = "DOWNLOAD" ]; then
        # Donwloading client
        cd "$WINEPREFIX/drive_c/$PROGRAMFILES/XenCenter/XenCenter6"
        if [ "$ARCHITECTURE" = "amd64" ]; then
                POL_Download "http://downloadns.citrix.com.edgesuite.net/10341/XenServer-6.5.0-SP1-XenCenterSetup.exe"
                FILENAME="XenServer-6.5.0-SP1-XenCenterSetup.exe"
        else
                POL_Download "http://downloadns.citrix.com.edgesuite.net/10341/XenServer-6.5.0-SP1-XenCenterSetup.exe"
                FILENAME="XenServer-6.5.0-SP1-XenCenterSetup.exe"
        fi
elif [ "$INSTALL_METHOD" = "LOCAL" ]; then
        # Asking for client exe
        cd "$HOME"
        POL_SetupWindow_browse "$(eval_gettext 'Please select the setup file to run')" "$TITLE"
        SETUP_EXE="$APP_ANSWER"
        cp "$SETUP_EXE" "$WINEPREFIX/drive_c/$PROGRAMFILES/XenCenter/XenCenter6/XenServer-6.5.0-SP1-XenCenterSetup.exe"
fi
 
# Making shortcut
POL_Shortcut "$FILENAME" "$TITLE" "$TITLE.png" "Accessoires;Virtualization;"

# Begin installation
cd "$WINEPREFIX/drive_c/$PROGRAMFILES/XenCenter/XenCenter6"

POL_Wine start /unix $FILENAME -repair -image
 
POL_SetupWindow_Close
exit 0