#!/bin/bash

if [ -z $DEPLOY_SOURCE ]  ; then
  echo "Please set absolute source path, e.g. DEPLOY_SOURCE=/var/www/html/WebACS"
  exit 1
fi

if [ -z $DEPLOY_REPO_PATH ]  ; then
  echo "Please set path of github repository URL as target for the deployment, e.g. DEPLOY_REPO_PATH=asterics/WebACS.git"
  exit 1
fi

if [ -z $DEPLOY_CNAME ]  ; then
  echo "Please set the domain name of your page, e.g. DEPLOY_CNAME=webacs.asterics.eu"
  exit 1
fi

if [ -z $DEPLOY_GH_TOKEN ]  ; then
  echo "Please set the GH_TOKEN (cleartext), e.g. DEPLOY_GH_TOKEN=xmdeljsdlfjsdlfjsdl"
  exit 1
fi


# init
DEPLOY_TMP=$(mktemp -d -t deploy-gh-XXXXXXXXXX)
echo "DEPLOY_TMP="$DEPLOY_TMP
DEPLOY_REPO=https://github.com/$DEPLOY_REPO_PATH

# debug parameters
echo "DEPLOY_SOURCE="$DEPLOY_SOURCE
echo "DEPLOY_REPO="$DEPLOY_REPO
echo "DEPLOY_CNAME="$DEPLOY_CNAME


rm -Rf $DEPLOY_TMP
mkdir -p $DEPLOY_TMP
cd $DEPLOY_TMP


#safe repo space by resetting to HEAD~1
git clone -b gh-pages --single-branch $DEPLOY_REPO gh-pages
cd $DEPLOY_TMP/gh-pages
git log -3
git reset --hard HEAD~1
git log -3

#clean previous stuff and checkin new one
rm -rf $DEPLOY_TMP/gh-pages/*
cp -r $DEPLOY_SOURCE/* .
echo $DEPLOY_CNAME >> ./CNAME
git add .
git add -u .
git -c user.name='Mr. Jenkins' -c user.email='studyathome@technikum-wien.at' commit -m 'docs: release'
git push -f https://$DEPLOY_GH_TOKEN@github.com/$DEPLOY_REPO_PATH


rm -Rf $DEPLOY_TMP
