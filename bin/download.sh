#!/usr/bin/env bash

###
### Download packages from official sites
###

source etc/app_version

download_go() 
{
  GO_DL="https://dl.google.com/go/go$GO_VER.linux-amd64.tar.gz"

  echo $GO_DL

  cd var/tmp
  curl -O $GO_DL
}

download_jdk()
{
  JDK_DL="http://download.oracle.com/otn-pub/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jdk-9.0.4_linux-x64_bin.tar.gz"
  cd var/tmp
  curl -H "Cookie: oraclelicense=accept-securebackup-cookie" -L -O $JDK_DL
}


download_jdk

download_go

