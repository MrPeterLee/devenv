#!/usr/bin/env bash

# Environment Variables
shenv_path=$HOME/.local/opt/shenv


# A collection of Bash Functions
function list_include_item {
    # Check if a variable is inside a list
    # Example:
    #     >>> if `list_include_item "10 11 12" "1"` ; then
    #     >>>   echo "yes"
    #     >>> else

    #     >>>   echo "no"
    #     >>> fi
    local list="$1"
    local item="$2"
    if [[ $list =~ (^|[[:space:]])"$item"($|[[:space:]]) ]] ; then
      # yes, list include item
      result=0
    else
      result=1
    fi
    return $result
}

## Check the flavour of the Unix
unameStr="$(uname -s)"
case "${unameStr}" in
    Linux*)     export OS_NAME=Linux;;
    Darwin*)    export OS_NAME=Mac;;
    CYGWIN*)    export OS_NAME=Cygwin;;
    MINGW*)     export OS_NAME=MinGw;;
    *)          export OS_NAME="UNKNOWN:${unameStr}"
esac

# Without zookeeper, define a list of accounts
prod_account_list=( finclab_prod peter )  # Linux users for prod environment
paper_account_list=( finclab_paper peter )
uat_account_list=( finclab_uat peter )
dev_account_list=( finclab_dev peter )

admin_user_list=( peter )   # List of sudo accounts to install additional plugins (install to /opt)
admin_user_pod_list=( neovim tmux powerline anaconda anaconda_venv_finclab karabiner )




## Parse yaml file
## Usage: >>> parse_yaml sample.yml
parse_yaml() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}



## Replace str for all files in a folder
replace_str() {
    local target_path="$1"
    local str_source="$1"
    local str_target="$1"
    find "$target_path" \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i 's/$str_source/$str_target/g'
}
replace_str_mac() {
    local target_path="$1"
    local str_source="$1"
    local str_target="$1"
    find "$target_path" \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i '' 's/$str_source/$str_target/g'
}
