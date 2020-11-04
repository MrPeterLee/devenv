#!/bin/bash

pod="finclab"

############################################################
####################      Git Repos     ####################
############################################################
# If dev accounts, deploy
#   - master branch
#   - dev branch (local)
# Daily commits in dev to be pushed to master

# If uat accounts, deploy
#   - master branch
#   - uat branch (local)
# Changes in master trigger UAT tests, and if passed release to UAT branch.

# Periodically UAT releases to be pushed to paper branch
# Periodically paper releases to be pushed to prod branch

# Master Branch
repoMasterPath=$HOME/master/finclab
if [[ ! -d $repoMasterPath ]]; then
    echo "Deploying FincLab master branch..."
    mkdir -p $repoMasterPath
    git clone git@github.com:MrPeterLee/FincLab.git $repoMasterPath
fi

if [[ " ${dev_account_list[@]} " =~ " ${USER} " ]]; then
    # dev branch (remote origin/master)
    repoPath=$HOME/dev/finclab
    if [[ ! -d $repoPath ]]; then
        echo "Deploying FincLab dev branch..."
        mkdir -p $repoPath
        cd $repoMasterPath
        git worktree add -b dev $repoPath origin/master
    fi
fi

if [[ " ${uat_account_list[@]} " =~ " ${USER} " ]]; then
    # uat branch (remote origin/uat)
    repoPath=$HOME/uat/finclab
    if [[ ! -d $repoPath ]]; then
        echo "Deploying FincLab uat branch..."
        mkdir -p $repoPath
        cd $repoMasterPath
        git worktree add -b uat $repoPath origin/uat
    fi
fi

if [[ " ${paper_account_list[@]} " =~ " ${USER} " ]]; then
    repoPath=$HOME/paper/finclab
    if [[ ! -d $repoPath ]]; then
        echo "Deploying FincLab paper branch..."
        mkdir -p $repoPath
        cd $repoMasterPath
        git worktree add -b paper $repoPath origin/paper
    fi
fi

if [[ " ${paper_account_list[@]} " =~ " ${USER} " ]]; then
    repoPath=$HOME/prod/finclab
    if [[ ! -d $repoPath ]]; then
        echo "Deploying FincLab prod branch..."
        mkdir -p $repoPath
        cd $repoMasterPath
        git worktree add -b prod $repoPath origin/prod
    fi
fi

############################################################
####################   $HOME/.finclab   ####################
############################################################

