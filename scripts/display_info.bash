echo -e "\e[33m======================= WORKSPACE INFO ============================\e[0m"
echo -e "\e[33mProject Name: \e[36m$DEV_PROJECT_NAME\e[0m"
echo -e "\e[33mProject Path: \e[36m$WS_PROJECT_REPO\e[0m"
echo -e "\e[33mProject Package Path: \e[36m$WS_PROJECT_REPO/pkg\e[0m"
echo -e "\e[33mActive Workspace: \e[36m$WS_PROJECT_WORKSPACE\e[0m"
echo -e "\e[33mOS Distro: \e[36m$OS_DISTRO\e[0m"
echo -e "\e[33mROS Distro: \e[36m$ROS_DISTRO\e[0m"
echo -e "\e[33mRMW Implementation: \e[36m$RMW_IMPLEMENTATION\e[0m"
echo -e "\e[33mROS ID: \033[5m\e[31m$ROS_DOMAIN_ID\e[0m"



IPs=""; for ip in $(hostname -I); do IPs+="$ip | "; done; IPs=${IPs::-3}; echo -e "\e[33mCurrent IP: \e[36m$IPs\e[0m"

echo -e "\e[33m===================================================================\e[0m"