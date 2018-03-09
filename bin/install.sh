#!/usr/bin/env bash

###
### install script execute on remote host
###

### profile.d dir
PFD=$HOME/etc/profile.d

### get application version
source etc/app_version

### create $HOME/opt dir, make sure it exists
mkdir -p $HOME/opt

### install unzip
install_unzip()
{
    echo "==> Install unzip"
    sudo apt install -y unzip
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
    mkdir -p ~/.ssh && chmod og-rx .ssh

    ### copy ssh key file
    #cat $KEY_FILE | ssh $RHOST "cat >> ~/.ssh/authorized_keys"  # append to key file
    cat $KEY_FILE >> ~/.ssh/authorized_keys # append to the key file, NOT overwrite

    ### check authorized_keys file
    echo "==> check authorized_keys"
    cat ~/$KEY_FILE
}

setup_profiled()
{
    ###
    ### create .profile to include env profiles in profile.d
    ### i.e: java_env, python_env, go_env
    ###

    echo "==> Create .profile"
    cp $HOME/etc/profile $HOME/.profile
    ls -l $HOME/.profile

    if [ $? -eq 0 ]; then
        echo "==) Done."
        echo
    fi
}

install_any()
{
    ###
    ### Install TAR to HOME dir, and create soft LINK
    ###

    STAR=$1
    SHOME=$2
    SLINK=$3

    ### create dir
    rm -rf $SHOME
    mkdir -p $SHOME

    ### untar/unzip
    cd $SHOME
    file $STAR| grep "gzip compress"
    if [ $? -eq 0 ]; then
        tar xzf $STAR --strip 1
    fi

    file $STAR | grep "Zip archive"
    if [ $? -eq 0 ]; then
        ### test if unzip installed
        unzip -h > /dev/null
        if [ $? -eq 0 ]; then
            unzip -q $STAR
            ### move unzipped dir one level up
            SUBDIR=`ls`
            mv $SUBDIR/* .
            rm -r $SUBDIR
        else
            echo "!!! unzip is not installed"
        fi
    fi

    ### create link
    rm -f $SLINK
    ln -s $SHOME $SLINK

}

install_java()
{
    ###
    ### install java jdk to $HOME/opt
    ###

    # JAVA_VER is from app_version, sourced at the beggining
    
    for TAR in `ls $HOME/var/tmp/jdk* | tail -1`; do
        JAVA_HOME="$HOME/opt/java-$JAVA_VER"
        JAVA_LINK="$HOME/opt/java"

        echo "==> Install Java"    
        echo "Install $TAR to $JAVA_HOME"

        install_any $TAR $JAVA_HOME $JAVA_LINK

        $JAVA_LINK/bin/java -version
        if [ $? -eq 0 ]; then
            sleep 1
            echo "==) Done"
            echo
        fi
    done
}

install_scala()
{
    ###
    ### install scala to $HOME/opt
    ###

    # SCALA_VER is from app_version, sourced at the beggining
    
    for TAR in `ls $HOME/var/tmp/scala* | tail -1`; do
        SCALA_HOME="$HOME/opt/scala-$SCALA_VER"
        SCALA_LINK="$HOME/opt/scala"

        echo "==> Install Scala"    
        echo "Install $TAR to $SCALA_HOME"

        install_any $TAR $SCALA_HOME $SCALA_LINK

        source $HOME/.profile
        $SCALA_LINK/bin/scala -version
        if [ $? -eq 0 ]; then
            sleep 1
            echo "==) Done"
            echo
        fi
    done
}

install_sbt()
{
    ###
    ### install SBT to $HOME/opt
    ###

    # SBT_VER is from app_version, sourced at the beggining
    
    for TAR in `ls $HOME/var/tmp/sbt* | tail -1`; do
        SBT_HOME="$HOME/opt/sbt-$SBT_VER"
        SBT_LINK="$HOME/opt/sbt"

        echo "==> Install SBT"    
        echo "Install $TAR to $SBT_HOME"

        install_any $TAR $SBT_HOME $SBT_LINK

        source $HOME/.profile
        sbt about
        # rm -r project   ### remove temp project dir generate by sbt
        if [ $? -eq 0 ]; then
            sleep 1
            echo "==) Done"
            echo
        fi
    done
}

install_go()
{
    ###
    ### install golang to $HOME/opt
    ###


    # GO_VER is from app_version, sourced at the beggining
    
    for TAR in `ls $HOME/var/tmp/go* | tail -1`; do
        GO_HOME="$HOME/opt/go-$GO_VER"
        GO_LINK="$HOME/opt/go"

        echo "==> Install Golang"    
        echo "Install $TAR to $GO_HOME"

        install_any $TAR $GO_HOME $GO_LINK

        $GO_LINK/bin/go version
        if [ $? -eq 0 ]; then
            sleep 1
            echo "==) Done"
            echo
        fi
    done
}

install_gradle()
{
    ###
    ### install gradle to $HOME/opt
    ###


    # GRADLE_VER is from app_version, sourced at the beggining
    
    for TAR in `ls $HOME/var/tmp/gradle* | tail -1`; do
        GRADLE_HOME="$HOME/opt/gradle-$GRADLE_VER"
        GRADLE_LINK="$HOME/opt/gradle"

        echo "==> Install Gradle"    
        echo "Install $TAR to $GRADLE_HOME"

        install_any $TAR $GRADLE_HOME $GRADLE_LINK

        ### check gradle version
        $GRADLE_LINK/bin/gradle --version
        if [ $? -eq 0 ]; then
            sleep 1
            echo "==) Done"
            echo
        fi
    done
}

install_spark()
{
    ###
    ### install spark to $HOME/opt
    ###


    # SPARK_VER is from app_version, sourced at the beggining
    
    for TAR in `ls $HOME/var/tmp/spark* | tail -1`; do
        SPARK_HOME="$HOME/opt/spark-$SPARK_VER"
        SPARK_LINK="$HOME/opt/spark"

        echo "==> Install Spark"    
        echo "Install $TAR to $SPARK_HOME"

        install_any $TAR $SPARK_HOME $SPARK_LINK

        ### check spark version
        $SPARK_LINK/bin/spark-shell --version
        if [ $? -eq 0 ]; then
            sleep 1
            echo "==) Done"
            echo
        fi
    done
}

main()
{
    install_unzip

    copy_ssh_key

    setup_profiled

    install_java

    install_go

    install_scala

    install_sbt

    install_gradle

    install_spark
}

main
