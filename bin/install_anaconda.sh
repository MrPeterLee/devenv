#!/usr/bin/env bash

pod="anaconda"
install_path=/opt/anaconda

if [[ -d $install_path ]]; then
    echo "$pod has been installed."
    exit
fi

if [[ ! "${OS_NAME}" == "Linux" && ! "${OS_NAME}" == "Mac" ]]; then
    echo "Installer of $pod does not support $OS_NAME."
    exit
fi

if [[ "${OS_NAME}" == "Linux" ]]; then
    echo "Fetch latest Anaconda from official website"
    CONTREPO=https://repo.continuum.io/archive/
    ANACONDAURL=$(wget -q -O - $CONTREPO index.html | grep "Anaconda3-" | grep "Linux" | grep "86_64" | head -n 1 | cut -d \" -f 2)
    echo "Fetching Anaconda3 installer from url $CONTREPO$ANACONDAURL"
    wget -O /tmp/anaconda.sh $CONTREPO$ANACONDAURL
    sudo su root -c "bash /tmp/anaconda.sh -bfp /opt/anaconda"
    rm /tmp/anaconda.sh
    . "/opt/anaconda/etc/profile.d/conda.sh"
fi

if [[ "${OS_NAME}" == "Mac" ]]; then
    echo "Fetch latest Anaconda from official website"
    CONTREPO=https://repo.continuum.io/archive/
    ANACONDAURL=$(wget -q -O - $CONTREPO index.html | grep "Anaconda3-" | grep "Mac" | grep "86_64" | grep "sh" | head -n 1 | cut -d \" -f 2)
    echo "Fetching Anaconda3 installer from url $CONTREPO$ANACONDAURL"
    wget -O /tmp/anaconda.sh $CONTREPO$ANACONDAURL
    chmod +x /tmp/anaconda.sh
    sudo su root -c "bash /tmp/anaconda.sh -bfp /opt/anaconda"
    #rm /tmp/anaconda.sh
    . "/opt/anaconda/etc/profile.d/conda.sh"
fi

