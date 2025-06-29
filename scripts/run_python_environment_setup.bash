#!/bin/bash
# Author: Mahir Sehmi
# Date: 2025-02-02

# To check if dev_init.bash has been sourced.
if [[ -z "$WS_DEV_SESSION_CHECK" ]]
then
 echo -e "$BASH_ERROR Make sure dev_init.bash is sourced. Refer to README.md for instructions."
 echo -e "$BASH_ACTION PRESS [ENTER] TO EXIT"
 read
 exit 0
fi

 echo -e "$BASH_INFO Setting up Python environment..."

# check if WS_PYTHON_ENV_NAME is not set else run the script
if [[ -z "$WS_PYTHON_ENV_NAME" ]]
then
 echo -e "$BASH_WARNING \e[36mWS_PYTHON_ENV_NAME\e[0m is not set. Using this instead: \e[36m$(which python3)\e[0m"
else
    # check if python3-venv is installed, if not install it
    if ! dpkg -s python3-venv &> /dev/null
    then
        echo -e "$BASH_INFO Installing python3-venv"
        sudo apt-get install python3-venv
    fi

    # check if the directory for python environment exists, if not create it
    if [ ! -d "$WS_PROJECT_REPO/pkg/pyenv" ]
    then
        echo -e "$BASH_INFO Creating directory for python environment in \e[36m$WS_PROJECT_REPO/pkg/pyenv\e[0m"
        mkdir -p $WS_PROJECT_REPO/pkg/pyenv
    fi

    # check if the python environment exists, if not create it
    if [ -d "$WS_PROJECT_REPO/pkg/pyenv/$WS_PYTHON_ENV_NAME" ]
    then
        echo -e "$BASH_INFO Using \e[36m$WS_PYTHON_ENV_NAME\e[0m python environment: \e[36m$WS_PROJECT_REPO/pkg/pyenv/$WS_PYTHON_ENV_NAME\e[0m"
        source $WS_PROJECT_REPO/pkg/pyenv/$WS_PYTHON_ENV_NAME/bin/activate
    else
        # create a venv with access to system-wide packages (critical for ROS 2)
        echo -e "$BASH_INFO Creating python environment \e[36m$WS_PYTHON_ENV_NAME\e[0m in \e[36m$WS_PROJECT_REPO/pkg/pyenv/$WS_PYTHON_ENV_NAME\e[0m"
        python3 -m venv --system-site-packages $WS_PROJECT_REPO/pkg/pyenv/$WS_PYTHON_ENV_NAME
        # activate the venv
        source $WS_PROJECT_REPO/pkg/pyenv/$WS_PYTHON_ENV_NAME/bin/activate
    fi

    # get the python version (e.g., python3.8)
    PYTHON_VERSION=$(python3 -c "import sys; print(f'python{sys.version_info.major}.{sys.version_info.minor}')")
    PYTHON_SITE_PACKAGES="$WS_PROJECT_REPO/pkg/pyenv/$WS_PYTHON_ENV_NAME/lib/$PYTHON_VERSION/site-packages"
    
    # check if the python environment path has been added to PYTHONPATH, if not add it
    if [[ ":$PYTHONPATH:" != *":$PYTHON_SITE_PACKAGES:"* ]]
    then
        echo -e "$BASH_INFO Adding \e[36m$PYTHON_SITE_PACKAGES\e[0m to PYTHONPATH"
        export PYTHONPATH="$PYTHON_SITE_PACKAGES:$PYTHONPATH"
    else
        echo -e "$BASH_INFO \e[36m$PYTHON_SITE_PACKAGES\e[0m already in PYTHONPATH"
    fi
fi

