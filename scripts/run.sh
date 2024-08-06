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



# DEFINE USAGE FUNCTION
# >>>----------------------------------------------------

# FIRST ARGUMENTS
usageState1(){
    EchoRed "Usage: $0 [run|stop|debug|*.sh]"
    EchoRed "  run: DEPLOY JSBSIM CONTAINER (RUN JSBSIM)"
    EchoRed "  stop: STOP JSBSIM CONTAINER"
    EchoRed "  debug: DEBUG JSBSIM CONTAINER"
    EchoRed "  clone: CLONE JSBSIM REPOSITORY"
    EchoRed "  build: BUILD JSBSIM (-DBUILD_SHARED_LIBS=ON)"
    EchoRed "  clean: CLEAN JSBSIM (git clean -fdx && git reset --hard)" 
    EchoRed "  *.sh: RUN A SPECIFIC SCRIPT INSIDE THE CONTAINER"
    exit 1
}

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



# CHECK IF ANY INPUT ARGUMENTS ARE PROVIDED
# >>>----------------------------------------------------
if [ $# -eq 0 ]; then
    usageState1 $0
else
    if [ "$1x" != "runx" ] && \
       [ "$1x" != "stopx" ] && \
       [ "$1x" != "debugx" ] && \
       [ "$1x" != "clonex" ] && \
       [ "$1x" != "buildx" ] && \
       [ "$1x" != "cleanx" ] && \
       [[ "$1x" != *".shx" ]]; then
        EchoRed "[$(basename "$0")] INVALID INPUT \"$1\". PLEASE USE ARGUMENT AMONG:"
        EchoRed "  \"run\""
        EchoRed "  \"stop\""
        EchoRed "  \"debug\""
        EchoRed "  \"clone\""
        EchoRed "  \"*.sh\""
        exit 1
    fi
fi

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



# RUN PROCESS PER ARGUMENT
# >>>----------------------------------------------------

JSBSIM_WORKSPACE=${JSBSIM_DEPLOY_DIR}/workspace
JSBSIM_SCRIPT_DIR=${JSBSIM_WORKSPACE}/scripts


if [ "$1x" == "stopx" ]; then
    CheckFileExists ${JSBSIM_DEPLOY_DIR}/compose.yml
    CheckFileExists ${JSBSIM_DEPLOY_DIR}/jsbsim.env

    EchoYellow "[$(basename "$0")] STOPPING JSBSIM CONTAINER"

    (cd ${JSBSIM_DEPLOY_DIR} && \
    docker compose -f ${JSBSIM_DEPLOY_DIR}/compose.yml \
        --env-file ./jsbsim.env \
        down)
else
    CheckDirExists ${JSBSIM_DEPLOY_DIR} create
    CheckDirExists ${JSBSIM_WORKSPACE} create
    CheckDirExists ${JSBSIM_SCRIPT_DIR} create
    CheckDirExists ${JSBSIM_SCRIPT_DIR}/include create

    cp ${REPO_DIR}/compose.yml ${JSBSIM_DEPLOY_DIR}/compose.yml
    cp ${REPO_DIR}/jsbsim.env ${JSBSIM_DEPLOY_DIR}/jsbsim.env
    cp ${REPO_DIR}/scripts/jsbsim/* ${JSBSIM_SCRIPT_DIR}
    cp ${REPO_DIR}/scripts/include/* ${JSBSIM_SCRIPT_DIR}/include

    EchoGreen "[$(basename "$0")] SETTING JSBSIM_WORKSPACE AS ${JSBSIM_WORKSPACE}"
    sed -i "s~JSBSIM_WORKSPACE=\"\"~JSBSIM_WORKSPACE=${JSBSIM_WORKSPACE}~" ${JSBSIM_DEPLOY_DIR}/jsbsim.env


    if [ "$1x" == "runx" ]; then
        EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET"
        exit 1
    elif [ "$1x" == "debugx" ]; then
        EchoGreen "[$(basename "$0")] RUNNING JSBSIM CONTAINER AS DEBUG MODE (sleep infinity)"
    elif [[ "$1x" == *"clonex" ]]; then
        EchoGreen "[$(basename "$0")] CLONING JSBSIM REPOSITORY"
        EchoYellow "[$(basename "$0")] THE CONTAINER WILL BE STOPPED AFTER CLONING"
    elif [[ "$1x" == *"buildx" ]]; then
        EchoGreen "[$(basename "$0")] BUILDING JSBSIM"
        EchoYellow "[$(basename "$0")] THE CONTAINER WILL BE STOPPED AFTER BUILDING"
    elif [[ "$1x" == *"cleanx" ]]; then
        EchoGreen "[$(basename "$0")] CLEANING JSBSIM"
        EchoYellow "[$(basename "$0")] THE CONTAINER WILL BE STOPPED AFTER CLEANING"
    elif [[ "$1x" == *".shx" ]]; then
        # CHECK IF THE SCRIPT EXISTS
        CheckFileExists ${JSBSIM_SCRIPT_DIR}/$1
        EchoGreen "[$(basename "$0")] RUNNING JSBSIM CONTAINER WITH USER-DEFINED SCRIPT: $1"

        # REMOVE .sh FROM THE ARGUMENT
        $1=${1::-3}
    fi

    sed -i "s~JSBSIM_RUN_COMMAND=\"\"~JSBSIM_RUN_COMMAND=\'bash -c \"/home/user/workspace/scripts/$1.sh\"\'~g" ${JSBSIM_DEPLOY_DIR}/jsbsim.env

    (cd ${JSBSIM_DEPLOY_DIR} && \
    docker compose -f ${JSBSIM_DEPLOY_DIR}/compose.yml \
        --env-file ./jsbsim.env \
        up)
fi