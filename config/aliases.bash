#!/bin/bash

# General
alias r2s="source $WS_DEV_MANAGER_DIR/scripts/run_source_files.bash"
alias r2sros="echo -e '$BASH_INFO Sourcing \e[36m/opt/ros/$ROS_DISTRO/setup.bash\e[0m' && source /opt/ros/$ROS_DISTRO/setup.bash"
alias r2info="source $WS_DEV_MANAGER_DIR/scripts/display_signature.bash && source $WS_DEV_MANAGER_DIR/scripts/display_info.bash && source $WS_PROJECT_REPO/config/scripts/display_info.bash"
alias r2alias="alias | grep r2"

# Project Workspace Specific
alias r2b="source $WS_DEV_MANAGER_DIR/scripts/run_pkg_operation.bash 2 $WS_PROJECT_REPO$WS_PROJECT_WORKSPACE"
alias r2bf="source $WS_DEV_MANAGER_DIR/scripts/run_pkg_operation.bash 5 $WS_PROJECT_REPO$WS_PROJECT_WORKSPACE && source $WS_DEV_MANAGER_DIR/scripts/run_pkg_operation.bash 2 $WS_PROJECT_REPO$WS_PROJECT_WORKSPACE"
alias r2del="source $WS_DEV_MANAGER_DIR/scripts/run_pkg_operation.bash 9 $WS_PROJECT_REPO$WS_PROJECT_WORKSPACE"
alias r2cdw="cd $WS_PROJECT_REPO$WS_PROJECT_WORKSPACE"
alias r2cdr="cd $WS_PROJECT_REPO"

# Development Manager Specific
alias r2pkg="source $WS_DEV_MANAGER_DIR/scripts/menu_pkg_manager.bash"
alias r2devp="source $WS_DEV_MANAGER_DIR/scripts/run_create_project_workspace.bash"
alias r2devg="source $WS_DEV_MANAGER_DIR/scripts/run_clone_project_repo.bash"
alias r2devw="source $WS_DEV_MANAGER_DIR/scripts/run_create_project_workspace.bash create_workspace_only"