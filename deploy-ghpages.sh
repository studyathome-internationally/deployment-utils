#!/bin/bash

if [ -z $DEPLOY_SOURCE ]  ; then
  echo "Please set source path, e.g. DEPLOY_SOURCE=WebACS"
  exit 1
fi

if [ -z $DEPLOY_REPO_PATH ]  ; then
  echo "Please set source path, e.g. DEPLOY_REPO_PATH=asterics/WebACS.git"
  exit 1
fi

if [ -z $DEPLOY_CNAME ]  ; then
  echo "Please set source path, e.g. DEPLOY_CNAME=webacs.asterics.eu"
  exit 1
fi

if [ -z $DEPLOY_GH_TOKEN ]  ; then
  echo "Please set source path, e.g. DEPLOY_GH_TOKEN=xmdeljsdlfjsdlfjsdl"
  exit 1
fi


DEPLOY_TMP=/tmp/deploy
DEPLOY_REPO=https://github.com/$DEPLOY_REPO_PATH

rm -Rf $DEPLOY_TMP
mkdir -p $DEPLOY_TMP
cd $DEPLOY_TMP


#safe repo space by resetting to HEAD~1
git clone -b gh-pages --single-branch $DEPLOY_REPO gh-pages
cd gh-pages
git log
git reset --hard HEAD~1
git log

#clean previous stuff and checkin new one
rm -rf ./*
cp -r $DEPLOY_SOURCE/* .
echo $DEPLOY_CNAME >> ./CNAME
git add .
git add -u .
git -c user.name='Mr. Jenkins' -c user.email='studyathome@technikum-wien.at' commit -m 'docs: release'
git push -f https://$DEPLOY_GH_TOKEN@github.com/$DEPLOY_REPO_PATH
