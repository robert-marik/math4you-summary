#!/bin/bash


echo '<h1>Files with error in log after April 13, 2021</h1>'

date

echo '<br><ul>'

files=`grep -l ^! test*.log`

for i in $files
do
   t=`stat -c %y $i`
   n=`echo $i| cut -d. -f1`
   echo '<li><a href="http://msr-latex.vsb.cz/m4uproject/m4u-cache/tests/'$n'.pdf">'$n'</a> '$t''
   
 done
 
echo '<ul>'