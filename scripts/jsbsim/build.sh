#!/bin/bash

# INITIAL STATEMENTS
# >>>----------------------------------------------------

# SET THE BASIC ENVIRONMENT VARIABLE
export TERM=xterm-256color
JSBSIM_VERSION=v1.2.0

# SET THE BASE DIRECTORY
BASE_DIR=$(dirname $(readlink -f "$0"))
WORKSPACE_DIR=$(dirname $(dirname $(readlink -f "$0")))

# SOURCE THE ENVIRONMENT AND FUNCTION DEFINITIONS
source ${BASE_DIR}/include/commonFcn.sh
source ${BASE_DIR}/include/commonEnv.sh

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# MAIN STATEMENTS
# >>>----------------------------------------------------

CheckDirExists "jsbsim" git https://github.com/JSBSim-Team/jsbsim.git ${JSBSIM_VERSION}

if [ -d ${WORKSPACE_DIR}/jsbsim/build ]; then
    EchoYellow "[$(basename "$0")] PREVIOUS BUILD DIRECTORY EXISTS. DELETING IT."
    rm -rf ${WORKSPACE_DIR}/jsbsim/build
fi

mkdir -p ${WORKSPACE_DIR}/jsbsim/build

cmake -DBUILD_SHARED_LIBS=ON -S ${WORKSPACE_DIR}/jsbsim -B ${WORKSPACE_DIR}/jsbsim/build
make -C ${WORKSPACE_DIR}/jsbsim/build

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<