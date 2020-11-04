#!/usr/bin/env bash

# Bash / Zsh unix environment
# Author: Peter Lee (mr.peter.lee@hotmail.com)

# How to deploy:
#    1) Deploy shenv package to /opt/shenv
#    2) Run /opt/shenv/install

# Environment Settings
export shenv_path="/opt/shenv"

pod_list=( bash )       # List of deployed pods

# Load additional bash functions
source $shenv_path/bin/bash_functions.sh

contains () { [[ "$1" =~ (^|[[:space:]])"$2"($|[[:space:]]) ]]; }

## Selected user accounts will receive extra plugins
#if `list_include_item "$admin_user_list" "$USER"`; then
if [[ " ${admin_user_list[@]} " =~ " ${USER} " ]]; then
    # pod_list=( "${pod_list[@]}" "${admin_user_pod_list[@]}" )
    echo "Administrator mode is ON."
else
    admin_user_pod_list=(  )  # Not an admin-user; empty the installation list
fi

current_datetime=`date '+%Y-%m-%d %H:%M:%S'`

# Deployment of individual packages
## Greetings
echo "Deploying FincLab Environment to $USER@$HOSTNAME"
echo "Operating system: ${OS_NAME}" 
echo "System local time: ${current_datetime}"
echo "Standard packages to be deployed: ${pod_list[@]}"
echo "System packages to be deployed: ${admin_user_pod_list[@]}"
echo " "
echo " "

# Install System Packages (adminUser only)
for pod in "${admin_user_pod_list[@]}"; do :
    installer_path="$shenv_path/bin/install_$pod.sh"
    if [[ ! -f $installer_path ]]; then
        echo "Cannot find installer for $pod ($installer_path does not exist)."
        continue
    fi

    echo "Deploying $pod."
    (. $installer_path)
done


# Install Standard Packages
for pod in "${pod_list[@]}"; do :
    installer_path="$shenv_path/bin/install_$pod.sh"
    if [[ ! -f $installer_path ]]; then
        echo "Cannot find installer for $pod ($installer_path does not exist)."
        continue
    fi

    echo "Deploying $pod."
    (. $installer_path)
done


# Update cron jobs
rm -f /tmp/cron.tmp
## crontab -l > /tmp/cron.tmp  # write out current crontab
## Check if there is a matching cron file for the current user
cron_filepath="$shenv_path/cron/${USER}"
if [[ -f $cron_filepath ]]; then
    cat $cron_filepath >> /tmp/cron.tmp
fi

if [[ ! -z "$(cat /tmp/cron.tmp)" ]]; then
    echo "Updating the crontab to include the below jobs:"
    echo "$(cat /tmp/cron.tmp)"
    crontab /tmp/cron.tmp  # install new cron file
fi
rm -f /tmp/cron.tmp


# Update config files
install_path=$HOME/.finclab
if [[ ! -d $install_path ]]; then
    mkdir -p $install_path
fi

if [[ ! -e $HOME/.finclab/environment.yml && "${USER}" = "finclab_prod" ]]; then
    ln -sf $shenv_path/config/prod/environment.yml $HOME/.finclab/environment.yml
fi
if [[ ! -e $HOME/.finclab/environment.yml && "${USER}" = "finclab_paper" ]]; then
    ln -sf $shenv_path/config/paper/environment.yml $HOME/.finclab/environment.yml
fi
if [[ ! -e $HOME/.finclab/environment.yml && "${USER}" = "finclab_uat" ]]; then
    ln -sf $shenv_path/config/uat/environment.yml $HOME/.finclab/environment.yml
fi
if [[ ! -e $HOME/.finclab/environment.yml ]]; then
    cp $shenv_path/config/dev/environment.yml $HOME/.finclab/environment.yml
fi


# Symlink executables
install_path=$HOME/bin
if [[ ! -d $install_path ]]; then
    mkdir -p $install_path
fi
## Deploy srn - Tmux split screens
ln -sf $shenv_path/bin/srn $HOME/bin/srn
## Deploy bash functions
ln -sf $shenv_path/bin/bash_functions.sh $HOME/bin/bash_function.sh
