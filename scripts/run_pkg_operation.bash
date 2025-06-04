#!/bin/bash
# Author: Mahir Sehmi
# Date: 2024-05-17
# Usage: Run this script only after initialize with dev_init.bash. Refer to README.md for instructions.
# Recommended to run by 'source pkg_install.bash' or '. pkg_install.bash' to avoid issues with sourcing files.

# To check if dev_init.bash has been sourced.
if [[ -z "$WS_DEV_SESSION_CHECK" ]]
then
 echo -e "$BASH_ERROR Make sure dev_init.bash is sourced. Refer to README.md for instructions."
 echo -e "$BASH_ACTION PRESS [ENTER] TO EXIT"
 read
 exit 0
fi


# Import functions and variables
source $WS_DEV_MANAGER_DIR/scripts/func_git_clone.bash
source $WS_DEV_MANAGER_DIR/scripts/func_source_file.bash
source $WS_DEV_MANAGER_DIR/scripts/func_pkg_operation.bash

# Variables
PKG_OPERATION_OPTION=${1:-1}   # 1: Run all, 2: Build only, 3: Apt install only, 4: Git clone only, 5: rosdep update & install only, 6: execute command, 9: Remove build and install folders
TEMP_PKG_OPERATION_DIR=${2:-/_robot}

CLONE_DIR="$TEMP_PKG_OPERATION_DIR/src"
CURRENT_TERMINAL_DIR=$(pwd)
INVALID_CLONE_COUNT=1
LIST_GIT_REPO=()
LIST_APT_PKG=()
LIST_PYTHON_PKG=()
LIST_EXEC_CMD=()


# Verification display
echo -e "================================================="
echo -e "              \e[33mPACKAGE MANAGER\e[0m"
echo -e "================================================="
echo -e "$BASH_INFO Operation directory: \e[36m$TEMP_PKG_OPERATION_DIR\e[0m"
echo -e "$BASH_INFO Operation: \e[36m$PKG_OPERATION_OPTION\e[0m"
echo -e "================================================="

# Check for pkg_list.bash
if [ -f $TEMP_PKG_OPERATION_DIR/pkg_list.bash ]
then
    echo -e "$BASH_INFO Sourcing pkg_list.bash from \e[36m$TEMP_PKG_OPERATION_DIR\e[0m"
    source $TEMP_PKG_OPERATION_DIR/pkg_list.bash
fi



#######################
# Install apt packages
#######################
if [ $PKG_OPERATION_OPTION -eq 1 ] || [ $PKG_OPERATION_OPTION -eq 3 ]
then
    install_apt_packages -y
fi


#######################
# Install Python packages
#######################
if [ $PKG_OPERATION_OPTION -eq 1 ] || [ $PKG_OPERATION_OPTION -eq 3 ]
then
    install_python_packages -y
fi


#######################
# Clone git packages
#######################
if [ $PKG_OPERATION_OPTION -eq 1 ] || [ $PKG_OPERATION_OPTION -eq 4 ]
then
    clone_git_packages -y
fi


#######################
# Execute commands
#######################
if [ $PKG_OPERATION_OPTION -eq 1 ] || [ $PKG_OPERATION_OPTION -eq 6 ]
then
    execute_commands -y
fi


#######################
# rosdep update and install
#######################
if [ $PKG_OPERATION_OPTION -eq 1 ] || [ $PKG_OPERATION_OPTION -eq 5 ]
then
    cd $TEMP_PKG_OPERATION_DIR
    echo -e "$BASH_INFO Checking and installing dependencies"
    rosdep update
    rosdep install -y -r -q --from-paths src --ignore-src --rosdistro $ROS_DISTRO -y
    cd $CURRENT_TERMINAL_DIR
fi


#######################
# Building & installing packages
#######################
if [ $PKG_OPERATION_OPTION -eq 1 ] || [ $PKG_OPERATION_OPTION -eq 2 ]
then
    cd $TEMP_PKG_OPERATION_DIR
    echo -e "$BASH_INFO Building packages..."
    colcon build --symlink-install
    source_file $TEMP_PKG_OPERATION_DIR/install/local_setup.bash
    cd $CURRENT_TERMINAL_DIR
fi


#######################
# Remove build and install folders
#######################
if [ $PKG_OPERATION_OPTION -eq 9 ]
then
    echo -e "$BASH_ACTION Are you sure you want to delete \e[36mbuild\e[0m and \e[36minstall\e[0m directory? [y/n]"
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        echo -e "$BASH_ACTION Do you also want to delete \e[36mlog\e[0m directory? [y/n]"
        read -r response
        if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
        then
            echo -e "$BASH_INFO Deleting \e[36mbuild\e[0m, \e[36minstall\e[0m and \e[36mlog\e[0m directory from \e[36m$TEMP_PKG_OPERATION_DIR\e[0m"
            rm -rf $TEMP_PKG_OPERATION_DIR/build $TEMP_PKG_OPERATION_DIR/install $TEMP_PKG_OPERATION_DIR/log
        else
            echo -e "$BASH_INFO Deleting \e[36mbuild\e[0m and \e[36minstall\e[0m directory from \e[36m$TEMP_PKG_OPERATION_DIR\e[0m"
            rm -rf $TEMP_PKG_OPERATION_DIR/build $TEMP_PKG_OPERATION_DIR/install
        fi
        echo -e "$BASH_WARNING You may need to restart terminal for changes to take effect."
    else
        echo -e "$BASH_INFO Operation cancelled."
    fi
fi


echo -e "$BASH_INFO DONE!"