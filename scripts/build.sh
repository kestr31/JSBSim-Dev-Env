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
$(cd ${REPO_DIR} &&
    docker build -t kestr3l/jsbsim:latest .)
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<