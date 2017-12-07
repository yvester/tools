#!/bin/bash
#echo yoyo $inc 
null > searchoutput.txt
echo enter the keyword to search 
read stringa
echo enter the path to search 
read patha
while read p; do
echo $p >> searchoutput.txt
ssh -n $p "grep -re $stringa $patha*" >> searchoutput.txt
done < serverfile.txt
cat searchoutput.txt