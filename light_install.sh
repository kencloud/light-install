#!/usr/bin/env bash

###
### linux system installation
###
### additional install ancd config after install from OS images
### 
### 1. copy ssh key
### 2. create profile.d for various env profile, i.e. JAVA_HOME, PATH etc.
### 3. install to $HOME/opt, untar, create soft link
###

### remote target host, cmd parameter $1
RHOST=$1

### remote user, cmd parameter $2
if [ -e $2 ]; then
    RUSER=$2
else
    RUSER=`id -un`
fi

copy_all_files()
{
    ###
    ### copy files to remote hosts
    ###

    echo "==> Copy files"

    ### link install.sh to var/tmp
    ### install.sh should be in var/tmp on remote host
    if [ -f install.sh ]; then
        rm -f var/tmp/install.sh
        ln install.sh var/tmp/
    fi

    ### use rsync to copy
    if [ -f rsync-filter ]; then
        rsync -rv --exclude-from=rsync-filter etc var $USER@$RHOST:~/
    else
        rsync -rv etc var $USER@$RHOST:~/
    fi

    ### copy light_install to remote host
    ##  can be used to install other remote hosts in the remote cluster
    ##  copy files among the remote cluster is much faster
    
    scp light_install.sh $RHOST:~/

    ### alternative scp, if rsync is not available
    # scp -r etc var $RHOST:\$HOME
    
    ### granular copy, optional, for dev mode
    # scp var/tmp/app_version $RHOST:\$HOME/var/tmp

    # scp -r etc/profile.d $RHOST:\$HOME/etc/

}

copy_ssh_key()
{
    ###
    ### copy ssh key file to remote authorized_keys
    ### enable the login using ssh key without key in password
    ###

    echo "==> Copy authorized_keys"

    ### ssh key file
    KEY_FILE=etc/authorized_keys
    
    ### create .ssh dir
    ssh $USER@$RHOST "mkdir -p ~/.ssh && chmod og-rx .ssh"

    ### copy ssh key file
    #cat $KEY_FILE | ssh $RHOST "cat >> ~/.ssh/authorized_keys"  # append to key file
    scp $KEY_FILE $RUSER@$RHOST:~/.ssh/authorized_keys # overwrite the key file

    ### check authorized_keys file
    echo "==> Verify remote authorized_keys"
    ssh $RUSER@$RHOST "cat ~/.ssh/authorized_keys | awk '{print \$3}'"
    ssh $RUSER@$RHOST "uname -a; date"

    if [ $? -eq 0 ]; then
        echo "OK. Copy ssh key successed!"; echo
    fi
}

remote_install()
{
    ###
    ### exec install.sh on remote host
    ###

    ssh $RUSER@$RHOST "\$HOME/var/tmp/install.sh"
}

### #1 copy ssh key to remote host, comment out after success execution
copy_ssh_key

copy_all_files

remote_install

