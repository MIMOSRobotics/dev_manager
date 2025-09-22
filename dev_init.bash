#!/bin/bash
# Author: Mahir Sehmi
# Date: 2024-06-11

DEV_MANAGER_REVISION=20250101	# Functional revision. Change if any new feature is added or any existing feature is modified.

###### GLOBAL ENVIRONMENT ######
export WS_DIR="$(dirname "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")")"
export WS_DEV_INIT_PATH="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/dev_init.bash"
export WS_DEV_MANAGER_DIR_NAME="$(basename $(dirname "$(readlink -f "${BASH_SOURCE[0]}")"))"
export WS_DEV_MANAGER_DIR="$WS_DIR/$WS_DEV_MANAGER_DIR_NAME"

###### RESET PROJECT ENVIRONMENT ######
source $WS_DEV_MANAGER_DIR/scripts/reset.bash


###### PROJECT ENVIRONMENT ######
export WS_PROJECT_REPO="$WS_DIR${1:-/$WS_DEV_MANAGER_DIR_NAME/temp}"
export WS_PROJECT_DIR_NAME="$(basename $WS_PROJECT_REPO)"
export WS_PROJECT_WORKSPACE="$2"


###### DEVELOPMENT SESSION ######
if [ "$WS_PROJECT_REPO" == "$WS_DIR/$WS_DEV_MANAGER_DIR_NAME/temp" ]; then
	export WS_DEV_SESSION_CHECK=99
	source $WS_DEV_MANAGER_DIR/config/settings.bash
	source $WS_PROJECT_REPO/config/settings.bash
	source $WS_DEV_MANAGER_DIR/config/aliases.bash
	unalias r2devw
	unalias r2pkg
else
	export WS_DEV_SESSION_CHECK=1
	source $WS_DEV_MANAGER_DIR/config/settings.bash
	source $WS_PROJECT_REPO/config/settings.bash    # If contain duplicate, this will overwrite settings from dev_manager.
	source $WS_PROJECT_REPO/config/aliases.bash     # If contain duplicate, this will overwrite aliases from dev_manager.
	source $WS_DEV_MANAGER_DIR/config/aliases.bash
	source $WS_PROJECT_REPO/config/init.bash
fi

alias r2dev="source $WS_DEV_MANAGER_DIR/scripts/menu_dev_manager.bash"




###### DISPLAY ######
clear -x
source $WS_DEV_MANAGER_DIR/scripts/display_signature.bash
echo -e "\e[33m============================= INIT ================================\e[0m"
echo -e "$BASH_INFO Initializing..."
if [ "$WS_PROJECT_REPO" != "$WS_DIR/$WS_DEV_MANAGER_DIR_NAME/temp" ]; then
	if [ "$WS_DEV_MANAGER_REVISION" -lt "$DEV_MANAGER_REVISION" ]; then
		echo -e "$BASH_WARNING The current project is using development manager revision \e[36m$WS_DEV_MANAGER_REVISION\e[0m which is older than current manager revision \e[36m$DEV_MANAGER_REVISION\e[0m. You may continue using but some features may not work. Please use older version or upgrade current project repo following the latest content."
	fi

	if [ "$WS_DEV_MANAGER_REVISION" -gt "$DEV_MANAGER_REVISION" ]; then
		echo -e "$BASH_WARNING The current project is using development manager revision \e[36m$WS_DEV_MANAGER_REVISION\e[0m which is newer than current manager revision \e[36m$DEV_MANAGER_REVISION\e[0m. You may continue using but some features may not work. Please upgrade the manager."
	fi
fi

if [ $WS_DEV_SESSION_CHECK == 99 ]; then
	# source $WS_DEV_MANAGER_DIR/scripts/display_info.bash
	echo -e "\e[33m===================================================================\e[0m"
	echo -e "$BASH_INFO WELCOME TO ROS 2 DEVELOPMENT MANAGER"
	echo -e "\e[33m===================================================================\e[0m"
	echo -e "$BASH_INFO Type '\e[33mr2devp\e[0m' to create a new project."
	echo -e "$BASH_INFO Type '\e[33mr2devg\e[0m' to clone git project."
	echo -e "$BASH_INFO Type '\e[33mr2dev\e[0m' for menu."
	echo -e "$BASH_INFO Refer to README.md for more information."
	cd $WS_DEV_MANAGER_DIR
fi

if [ $WS_DEV_SESSION_CHECK == 1 ]; then
	source $WS_DEV_MANAGER_DIR/scripts/run_python_environment_setup.bash
	r2s
	echo -e "$BASH_INFO Done!"
	echo -e "$BASH_INFO Type '\e[35mr2s\e[0m' to source the files again."
	echo -e "$BASH_INFO Type '\e[35mr2info\e[0m' for workspace info."
	echo -e "$BASH_INFO Type '\e[35mr2pkg\e[0m' for package manager menu."
	r2cdw
	source $WS_DEV_MANAGER_DIR/scripts/display_info.bash && source $WS_PROJECT_REPO/config/scripts/display_info.bash
fi
