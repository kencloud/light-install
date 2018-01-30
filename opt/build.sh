
### build all-in-one tar ball
###
### the tar can be copied to remote host, and untar in $HOME dir
### the tar will located in build/

# tar output file
TARF="build/light_install.tgz"

tar czvf $TARF etc opt var
