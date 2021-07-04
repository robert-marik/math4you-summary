#! /bin/bash

echo "<?php"
for i in `ls html_un_qa/*.html`
do

    j=`grep "class='header'" $i | wc -l`
    k=`echo $i | sed s/[^0-9]*//g`
    echo "pocet ($k,$j);"
done

echo "?>"
