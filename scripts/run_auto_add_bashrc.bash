#!/bin/bash
# Author: Mahir Sehmi
# Date: 2024-05-15
# Usage: Run this script only after initialize with dev_init.bash. Refer to README.md for instructions.
# Recommended to run by 'r2pkg' or 'source pkg_manager.bash' or '. pkg_manager.bash' to avoid issues with sourcing files.

# To check if dev_init.bash has been sourced.
if [[ -z "$WS_DEV_SESSION_CHECK" ]]
then
 echo -e "$BASH_ERROR Make sure dev_init.bash is sourced. Refer to README.md for instructions."
 echo -e "$BASH_ACTION PRESS [ENTER] TO EXIT"
 read
 exit 0
fi

BASHRC_LIST_PATH="${1:-$WS_PROJECT_REPO/config/bashrc_list.bash}"

auto_confirm=false
if [[ "$2" == "-y" ]]; then
    auto_confirm=true
fi

source $BASHRC_LIST_PATH

if [ ${#bashrc_list[@]} -eq 0 ]; then
    echo -e "$BASH_ERROR No aliases found in $BASHRC_LIST_PATH"
else
    # Replace spaces in $DEV_PROJET_NAME with underscores and capitalize the string
    DEV_PROJECT_NAME_VAR=$(echo $DEV_PROJECT_NAME | tr ' ' '_' | tr '[:lower:]' '[:upper:]')

    echo -e "$BASH_INFO The following lines will be added to the .bashrc file:"
    echo -e "=================================================\e[36m"
    for i in "${bashrc_list[@]}"
    do
        echo "$i"
    done
    echo -e "\e[0m================================================="

    if [ "$auto_confirm" = false ]; then
        echo -e "$BASH_ACTION  Do you want to add the above aliases to the .bashrc file? [y/n]"
        read -r response
    else
        response="y"
    fi

    if [[ ! $response =~ ^([nN][oO]|[nN])$ ]]
    then
        for i in "${bashrc_list[@]}"
        do
            # Check if the entire line is in the .bashrc file
            if ! grep -qF "$i" ~/.bashrc; then
                echo "$i" >> ~/.bashrc
                # check if the line is added
                if grep -qF "$i" ~/.bashrc; then
                    echo -e "$BASH_SUCCESS Added to .bashrc: \e[36m$i\e[0m"
                else
                    echo -e "$BASH_ERROR Could not add to .bashrc: \e[36m$i\e[0m"
                fi
            else
                echo -e "$BASH_WARNING Already in .bashrc: \e[36m$i\e[0m"
            fi
        done
        echo -e "\e[0m================================================="
    else
        echo -e "$BASH_INFO Cancelled."
        echo -e "\e[0m================================================="
    fi

    # # Check if aliases exist in the .bashrc file
    # for i in "${bashrc_list[@]}"
    # do
    #     # Extract the alias name from the string
    #     line_in_bashrc=$(echo "$i" | cut -d'=' -f1)
        
    #     if ! grep -q "^$line_in_bashrc" ~/.bashrc; then
    #         echo "$i" >> ~/.bashrc
    #         # check if the alias is added
    #         if grep -q "^$line_in_bashrc" ~/.bashrc; then
    #             echo -e "$BASH_SUCCESS Added to .bashrc: \e[36m$i\e[0m"
    #         else
    #             echo -e "$BASH_ERROR Could not add to .bashrc: \e[36m$i\e[0m"
    #         fi
    #     else
    #         # Check if the entire line matches
    #         if ! grep -qF "$i" ~/.bashrc; then
    #             echo -e "$BASH_WARNING $line_in_bashrc in .bashrc does not match expected command"
    #             echo -e "$BASH_ACTION Do you want to replace it with the new command? (y/n)"
    #             read answer
    #             if [ "$answer" == "y" ]; then
    #                 # Replace the line
    #                 sed -i "/^$line_in_bashrc/c\\$i" ~/.bashrc
    #                 echo -e "$BASH_INFO Replaced $line_in_bashrc in .bashrc with new command"
    #             else
    #                 echo -e "$BASH_WARNING $line_in_bashrc will not be replaced in .bashrc"
    #             fi
    #         else
    #             echo -e "$BASH_INFO Already in .bashrc: \e[36m$i\e[0m"
    #         fi
    #     fi
    # done

    # source the .bashrc file to apply the changes
    source ~/.bashrc
fi
