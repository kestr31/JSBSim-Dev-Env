#!/bin/bash

# SCRIPT TO RUN CONTAINER FOR TESTING

# INITIAL STATEMENTS
# >>>----------------------------------------------------

# SET THE BASE DIRECTORY
BASE_DIR=$(dirname $(readlink -f "$0"))
REPO_DIR=$(dirname $(dirname $(readlink -f "$0")))

# SOURCE THE ENVIRONMENT AND FUNCTION DEFINITIONS
source ${BASE_DIR}/include/commonFcn.sh
source ${BASE_DIR}/include/commonEnv.sh

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



# RUN PROCESS PER ARGUMENT
# >>>----------------------------------------------------
# CHECK IF USER OS IS UBUNTU 22.04
if [ "$(lsb_release -cs)" != "focal" ] && \
   [ "$(lsb_release -cs)" != "jammy" ]; then
    EchoRed "[$(basename "$0")] THIS SCRIPT IS FOR UBUNTU 20.04 OR 22.04"
    exit 1
fi

# CHECK IF docker IS INSTALLED
if ! [ -x "$(command -v docker)" ]; then
    EchoRed "[$(basename "$0")] DOCKER IS NOT INSTALLED"
    EchoYellow "[$(basename "$0")] INSTALLING DOCKER..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    
    EchoYellow "[$(basename "$0")] ADDING USER TO DOCKER GROUP..."
    sudo usermod -aG docker $USER

    # ASK USRE FOR REBOOT
    EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO REBOOT THE SYSTEM TO APPLY THE CHANGES"

    read -p "[$(basename "$0")] DO YOU WANT TO REBOOT THE SYSTEM? [y/n]: " REBOOT_SYSTEM

    # SET REBOOT SYSTEM TO LOWERCASE
    REBOOT_SYSTEM=$(echo $REBOOT_SYSTEM | tr '[:upper:]' '[:lower:]')

    # REPEAT UNTIL USER ENTERS y OR n
    while [ "$REBOOT_SYSTEM" != "y" ] && [ "$REBOOT_SYSTEM" != "n" ]; do
        EchoRed "[$(basename "$0")] INVALID INPUT \"$REBOOT_SYSTEM\". PLEASE ENTER y OR n"
        read -p "[$(basename "$0")] DO YOU WANT TO REBOOT THE SYSTEM? [y/n]: " REBOOT_SYSTEM
        REBOOT_SYSTEM=$(echo $REBOOT_SYSTEM | tr '[:upper:]' '[:lower:]')
    done

    # REBOOT THE SYSTEM ON THE USER REQUEST
    if [ "$REBOOT_SYSTEM" == "y" ]; then
        sudo reboot -h now
    elif [ "$REBOOT_SYSTEM" == "n" ]; then
        EchoYellow "[$(basename "$0")] REBOOT THE SYSTEM LATER TO APPLY THE CHANGES"
        EchoYellow "[$(basename "$0")] BEFORE REBOOTING, YOU NEED sudo COMMAND TO USE docker cli"
        exit 0
    else
        EchoRed "[$(basename "$0")] INVALID INPUT \"$REBOOT_SYSTEM\". PLEASE ENTER y OR n"
        exit 1
    fi
else
    EchoGreen "[$(basename "$0")] DOCKER IS INSTALLED ON THE SYSTEM"
    EchoGreen "[$(basename "$0")] NO ACTION REQUIRED"
    exit 0
fi