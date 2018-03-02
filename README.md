# Light Install
A set of shell script to install and config additional software on a fresh installed Linux system. 

It is light, portable and lightening fast.

This project target is Ubuntu/Debian system. It can be easily adpated for Redhat and other distribution.

## Ideas and Conventions

### Idea 1: Do not use apt/yum/dnf to install
- Additional software will install from tar ball(*.tar.gz), which downloaed from vendor directly.
- It will install to ```$HOME/opt```
- Create soft link to the installation

Reason:
- Install latest version software. The distribution come with older version
- Avoid dependency on packages in system
- Do NOT mixed with or override packages in the system
- Does not need root priviliges
- Most linux system are used by single user
- Portable installation, easy to copy to other similar system

Basic logic, using java as example: 
- download JDK from oracle.com
- store JDK tar ball(```jdk-8u151-linux-x64.tar.gz```) in ```$HOME/var/tmp```
- JDK will untar to ```$HOME/opt/java-1.8.0u151```
- create soft link ```$HOME/opt/java``` to this dir
- ```JAVE_HOME``` will be ```$HOME/opt/java```
- ```java``` will be in ```$HOME/opt/java/bin/java```
- ```JAVA_HOME``` and ```PATH``` will set in ```$HOME/etc/profile.d/java_env```
- ```.profile``` will include ```*_env*``` file in ```$HOME/etc/profile.d```

### Idea 2: Everything in Home dir
Create ```etc, opt, var``` in the ```$HOME``` dir, similar to ```/etc, /opt /var```.
Avoid permission issue on ```/etc, /opt /var```

```bash
$HOME
  |-/etc                        # config files
  |-/var                        # hold data, log, tmp
  |-/opt                        # additional softwares
```

Detail:
```bash
$HOME
  |-/etc                        # config files
  |---hosts                     # cp and override /etc/hosts
  |---authorized_keys                # ssh pub key, copy to $HOME/.ssh/authorized_keys
  |---profile                   # override $HOME/.profile
  |---/profile.d                # setup shell .profile
  |-----java_env                # JAVA env setting, JAVA_HOME, PATH
  |-/var                        # hold app data, log
  |---app_version               # versions of packages to install
  |---/tmp                      # downloaded packages
  |-/opt                        # additional softwares
  |---install.sh                # install script
  |---build.sh                  # build distribution tgz package
  |---java                      # softlink to jdk1.8.0
  |---go                        # softlink to go-1.9.2
  |---/jdk1.8.0                 # JDK 1.8.0
  |---/go-1.9.2                 # Go lang 1.9.2
```

Create the dirs:
```bash
// shell
cd $HOME
mkdir -p \
  etc \
  etc/profile.d \
  opt \
  var \
  var/tmp
```

## How to use
### Stage 1: Prepare
1. check out this code from github
2. update ```etc/authorized_keys``` with public key
3. put packages to install under ```var/tmp```. (i.e.: ```jdk-8u151-linux-x64.tar.gz```, etc)
### Stage 2: Build tar and distribute
1. run ```opt/build.sh```
2. scp ```build/light-install.tgz``` to remote ```/var/tmp```
### Stage 3: Install on remote host
1. login remote host to ```$HOME```
2. untar ```tar xzvf /vat/tmp/light-install.tgz```
3. run ```opt/install.sh```

## TO DO
