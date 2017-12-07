#!/bin/bash

domainname=$1
echo $domainname

if [ $# -eq 0 ]
then echo "Saisir un domaine"
exit 1 
fi

ROOTSCRIPT=/tmp/versionapp
TARGET=/tmp/versionapp/$domainname/targets
SOURCES=/tmp/versionapp/$domainname/sources

rm -rf $ROOTSCRIPT

mkdir -p $SOURCES
mkdir -p $TARGET

echo enter the tibco admin user 
read tibcouser

echo enter the tibco admin password 
read tibcopass

DIRTRA58=/opt/tibco/tra/5.8
DIRTRA510=/opt/tibco/tra/5.10
TIBCOTRA=""

if [ -d "$DIRTRA58" ]; then
  TIBCOTRA=5.8
fi
if [ -d "$DIRTRA510" ]; then
  TIBCOTRA=5.10
fi
echo  $TIBCOTRA
if [ $TIBCOTRA == "" ]; then 
exit
fi 

cd /opt/tibco/tra/$TIBCOTRA/bin
./AppManage -batchExport -max -user $tibcouser -pw $tibcopass -domain $domainname -dir $SOURCES

cd $SOURCES
FILES=$SOURCES/*.ear
rm -rf $TARGET/*

cd $SOURCES
find . -name '*.ear' | while IFS=$'\n' read -r f; do
	name=$(echo $f | cut -d '.' -f 2)
	mkdir -p $TARGET/$name
	cp $SOURCES/$name.ear $TARGET/$name.zip
	unzip $TARGET/$name.zip -d $TARGET/$name/
	string1=`grep \<version\> $TARGET/$name/*.xml`  
	echo  $name $string1  >> $ROOTSCRIPT/$domainname.txt
	sed -i 's/<version>/ /g' $ROOTSCRIPT/$domainname.txt
	sed -i 's/<\/version>/ /g' $ROOTSCRIPT/$domainname.txt
done

sort $ROOTSCRIPT/$domainname.txt -o $ROOTSCRIPT/$domainname.txt

rm -rf $ROOTSCRIPT/$domainname
rm -rf $SOURCES
rm -rf $TARGET

echo Output available @ $ROOTSCRIPT/$domainname.txt
