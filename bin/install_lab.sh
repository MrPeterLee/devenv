#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This installer must be run as root. Please add sudo." 
   exit 1
fi

##############################################################################
#######################    Create Lab Folder Structure   #####################
##############################################################################

# This script should be placed in:
# /lab/bin/install

# Output folder structure
# -----------------------
# /lab/master     : the master branch (latest from dev); user finclab_uat
# /lab/uat        : the uat lab; user finclab_uat, finclab_paper
# /lab/paper      : paper trading lab; user finclab_paper, finclab_prod
# /lab/prod       : production lab; user finclab_prod

# Deployment pipeline
# -------------------
# dev commits should be pushed to master at least daily
# upon new releases in master, uat testing is triggered (ID by the SHA)
# once UAT tests completes successfully, auto deployed to paper
# Paper release to prod is set to End of Day.

# Apps to be deployed
# -------------------
# Add more lines to the below in the format:
#     git_app[folder_of_the_app]=git URL
#     where the folder_of_the_app is relative path on /lab/master/
declare -A git_apps
git_apps["lib/python"]="git@github.com:MrPeterLee/FincLab.git"

# Clarify the group ownership
## Group labmaster: access to /lab/master, incl user: finclab_uat
## Group labuat: access to /lab/uat, incl user: finclab_uat, finclab_paper
## Group labpaper: access to /lab/paper, incl user: finclab_paper, finclab_prod
## Group labprod: access to /lab/prod, incl user: finclab_prod
## separate usernames by delimiter ','
declare -A group_users
group_users["labmaster"]="lab_deploy_bot,finclab_uat,finclab_paper,finclab_prod,finclab_dev,peter"
group_users["labuat"]="lab_deploy_bot,finclab_uat,finclab_paper,peter"
group_users["labpaper"]="lab_deploy_bot,finclab_paper,finclab_prod,peter"
group_users["labprod"]="lab_deploy_bot,finclab_prod,peter"


##############################################################################
#######################             Deployment           #####################
##############################################################################
# Do not modify the lines below
# username: lab_deploy_bot -- folder creation and deployment
user=lab_deploy_bot
if ! id "$user" >/dev/null 2>&1; then
    useradd -m $user
    echo "Created user '${user}'."
fi


# Clarify the group ownership
## Group labmaster: access to /lab/master
##     incl user: finclab_uat, peter
## Group labuat: access to /lab/uat
## Group labprod: access to /lab/prod

for group in "${!group_users[@]}"
do
    # Create this group if not exists
    getent group $group || groupadd $group

    # Convert string usernames to bash array
    IFS=',' read -r -a users <<< "${group_users[$group]}"
    for user in "${users[@]}"
    do
        # Create this user if not exists
        if ! id "$user" >/dev/null 2>&1; then
            useradd -m $user
            echo "Created user '${user}'."
        fi
        # Assign this user to the group
        usermod -a -G $group $user
    done

    # List the members of the group. 
    # Remove if a member is not in the user_list.
    IFS=' ' read -r -a members <<< "$(members $group)"
    for member in "${members[@]}"
    do
        # if user_list does not conain member --> get hacked?
        if [[ ! " ${users[@]} " =~ " ${member} " ]]; then
            echo "Unauthorized user account '$member' is in '$group' group."
            deluser $member $group
            echo "'$member' removed from '$group' group."
        fi

    done
done

# Create env folders
dirs=( "/lab" "/lab/master" "/lab/uat" "/lab/paper" "/lab/prod" )
for dir in "${dirs[@]}"
do
    if [ ! -d "$dir" ] 
    then
        echo "Directory ${dir} does not exists. Creating this path." 
        mkdir -p "${dir}"
        chown lab_deploy_bot:lab_deploy_bot "${dir}"
        chmod 770 "${dir}"
    fi
done

chgrp labmaster /lab/master
chgrp labuat /lab/uat
chgrp labpaper /lab/paper
chgrp labprod /lab/prod


# Deploy apps
for app in "${!git_apps[@]}"
do
    echo " "
    echo "----- Installing $app from git: ${git_apps[$app]} -----"
    echo " "

    # master
    app_path="/lab/master/${app}"
    if [[ ! -d $app_path ]]; then
        runuser -l lab_deploy_bot -c "git clone ${git_apps[$app]} $app_path"
        runuser -l lab_deploy_bot -c "chgrp -R labmaster $app_path"
        runuser -l lab_deploy_bot -c "chmod -R 770 $app_path"
        echo "Deployed $app to /lab/master"
    fi
    repoMasterPath=$app_path


    # uat branch (remote origin/uat)
    app_path="/lab/uat/${app}"
    if [[ ! -d $app_path ]]; then
        runuser -l lab_deploy_bot -c "cd $repoMasterPath && git worktree add -b uat $app_path origin/uat"
        runuser -l lab_deploy_bot -c "chgrp -R labuat $app_path"
        runuser -l lab_deploy_bot -c "chmod -R 770 $app_path"
        echo "Deployed $app to /lab/uat"
    fi

    # Paper
    app_path="/lab/paper/${app}"
    if [[ ! -d $app_path ]]; then
        runuser -l lab_deploy_bot -c "cd $repoMasterPath && git worktree add -b paper $app_path origin/paper"
        runuser -l lab_deploy_bot -c "chgrp labmaster $repoMasterPath/.git/config"  # Re-run to ensure .git/config is having the correct permission
        runuser -l lab_deploy_bot -c "chgrp -R labpaper $app_path"
        runuser -l lab_deploy_bot -c "chmod -R 770 $app_path"
        echo "Deployed $app to /lab/paper"
    fi

    # Prod
    app_path="/lab/prod/${app}"
    if [[ ! -d $app_path ]]; then
        runuser -l lab_deploy_bot -c "cd $repoMasterPath && git worktree add -b prod $app_path origin/prod"
        runuser -l lab_deploy_bot -c "chgrp labmaster $repoMasterPath/.git/config"  # Re-run to ensure .git/config is having the correct permission
        runuser -l lab_deploy_bot -c "chgrp -R labprod $app_path"
        runuser -l lab_deploy_bot -c "chmod -R 770 $app_path"
        echo "Deployed $app to /lab/prod"
    fi

done


# Special folders
chmod 770 /lab/master/lib
chgrp labmaster /lab/master/lib
chmod 770 /lab/prod/lib
chgrp labprod /lab/prod/lib
chmod 770 /lab/uat/lib
chgrp labuat /lab/uat/lib
chmod 770 /lab/paper/lib
chgrp labpaper /lab/paper/lib
