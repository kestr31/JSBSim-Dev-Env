#!/bin/bash

# INITIAL STATEMENTS
# >>>----------------------------------------------------

# SET THE BASIC ENVIRONMENT VARIABLE
export TERM=xterm-256color
JSBSIM_VERSION=v1.2.0

# SET THE BASE DIRECTORY
BASE_DIR=$(dirname $(readlink -f "$0"))

# SOURCE THE ENVIRONMENT AND FUNCTION DEFINITIONS
source ${BASE_DIR}/include/commonFcn.sh
source ${BASE_DIR}/include/commonEnv.sh

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



# MAIN STATEMENTS
# >>>----------------------------------------------------
CheckDirExists "jsbsim" git https://github.com/JSBSim-Team/jsbsim.git ${JSBSIM_VERSION}
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<