#!/usr/bin/env bash

###
### Download packages from official sites
###

source etc/app_version

download_go() 
{
  GO_DL="https://dl.google.com/go/go$GO_VER.linux-amd64.tar.gz"

  echo $GO_DL
  curl -O $GO_DL
}

download_jdk()
{
  JDK9_DL="http://download.oracle.com/otn-pub/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jdk-9.0.4_linux-x64_bin.tar.gz"
  JDK8_DL="http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jdk-8u162-linux-x64.tar.gz"

  JDK_DL=$JDK8_DL # download JDK 8
  echo $JDK_DL
  curl -H "Cookie: oraclelicense=accept-securebackup-cookie" -L -O $JDK_DL
}

main()
{
  cd var/tmp

  download_jdk

  download_go
}

