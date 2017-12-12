#!/bin/bash
#echo yoyo $inc 
# null > searchoutput.txt

clear

rm -f searchoutput.txt

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
# echo "${red}red text ${green}green text${reset}"

# echo "bbbbbbb" ${opt}

while getopts "u:k:o:p:h" opt; do
 case "${opt}"
 in
 u) USERA=${OPTARG};;
 k) KEYWORDA=${OPTARG};;
 o) OPTIONSA=${OPTARG};;
 p) PATHA=${OPTARG};;
 h) echo "Usage stersearch -h [-u] [user] [-k] [keyword] [-o] [options] [-p] [path]"
   echo "-u for user to search with Default : tibco "
   echo "-k for keyword to search e.g.: Rocbis ,  Default : None "
   echo "-o for options for grep e.g.: -rei , Default : None "
   echo "-p for path to search e.g.: /tmp ,  Default : None "
   echo "-h for usage "
   exit 0
   ;;
esac
done

#echo  user $USERA
#echo  keyword $KEYWORDA
#echo  options $OPTIONSA
#echo  patha $PATHA

if [ "$USERA" != "" ]; then
   echo  ${green} user : $USERA  ${reset} 
else
default=tibco
read -p "${green}Enter keyword [$default]: " USERA
echo ${reset} 
USERA=${USERA:-$default}
echo "$USERA"
fi

if [ "$KEYWORDA" != "" ]; then
   echo ${green} keyword : $KEYWORDA ${reset} 
else
default=AlturingNumberOne
read -p "${green}Enter keyword [$default]: " KEYWORDA
echo ${reset} 
KEYWORDA=${KEYWORDA:-$default}
echo "$KEYWORDA"
fi

if [ "$OPTIONSA" != "" ]; then
echo ${green} options : $OPTIONSA ${reset} 
else
default=ri
read -p "${green}Enter options [$default]: " OPTIONSA
echo ${reset} 
OPTIONSA=${OPTIONSA:-$default}
echo "$OPTIONSA"
fi

if [ "$PATHA" != "" ]; then
   echo ${green} keyword : $PATHA ${reset} 
else
default=/tmp
read -p ${green}"Enter Path [$default]: " PATHA 
echo ${reset}
PATHA=${PATHA:-$default}
echo "$PATHA"
fi

while read p; do
echo $p >> searchoutput.txt
echo ssh -n $USERA@$p "grep -$OPTIONSA $KEYWORDA $PATHA/*"  >> searchoutput.txt
echo ssh -n $USERA@$p "grep -$OPTIONSA $KEYWORDA $PATHA/*"
ssh -n $USERA@$p "grep -$OPTIONSA $KEYWORDA $PATHA/*" >> searchoutput.txt
done < serverfile.txt
#cat searchoutput.txt
echo ${green}Search results in searchoutput.txt
echo ${reset} 