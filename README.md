# Light Install
A set of shell script to install and config additional software on a fresh installed Linux system. 

It is light, portable and lightening fast.

This project target is Ubuntu/Debian system. It can be easily adpated for Redhat and other distribution.

## Ideas and Conventions

### Idea 1: Do not use apt/yum/dnf to install
- Additional software will install from tar ball(*.tar.gz), which downloaed from vendor directly.
- It will install to **$HOME/opt**, or **/opt**

Why?
- Install latest version software. The distribution come with older version
- Avoid dependency on packages in system
- Do NOT mixed with or override packages in the system
- Portable installation, easy to copy to other similar system


### Idea 2: Home dir structure
```bash
$HOME
  |-/etc                        # config files
  |---hosts                     # cp and override /etc/hosts
  |---/profile.d                # setup shell .profile
  |-----java_env                # JAVA env setting, JAVA_HOME, PATH
  |---/ssh                      # ssh keys and config
  |-----id_rsa.pub              # ssh pub key, copy to $HOME/.ssh/authorized_keys
  |-/var                        # hold data, log
  |---/tmp                      # downloaded packages
  |-/opt                        # additional softwares
  |---java                      # softlink to jdk1.8.0
  |---go                        # softlink to go-1.9.2
  |---/jdk1.8.0                 # JDK 1.8.0
  |---/go-1.9.2                 # Go lang 1.9.2
```

Create the dirs:
```bash
mkdir -p etc etc/profile.d
mkdir -p ssh opt var var/tmp
```
