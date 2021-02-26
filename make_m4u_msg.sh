lang=$1

IFS=$'\n'

j=0
for i in `grep -a $lang@1 hlasky.txt | sort -R | head -n5 | cut -d@ -f3`
do
    echo \\Ulozhlasku 0$j $i 
    echo
    j=$((j+1))
done


j=0
for i in `grep -a $lang@2 hlasky.txt | sort -R | head -n5 | cut -d@ -f3`
do
    echo \\Ulozhlasku 1$j $i 
    echo
    j=$((j+1))
done


j=0
for i in `grep -a $lang@3 hlasky.txt | sort -R | head -n5 | cut -d@ -f3`
do
    echo \\Ulozhlasku 2$j $i 
    echo
    j=$((j+1))
done


j=0
for i in `grep -a $lang@4 hlasky.txt | sort -R | head -n5 | cut -d@ -f3`
do
    echo \\Ulozhlasku 3$j $i 
    echo
    j=$((j+1))
done


j=0
for i in `grep -a $lang@5 hlasky.txt | sort -R | head -n5 | cut -d@ -f3`
do
    echo \\Ulozhlasku 4$j $i 
    echo
    j=$((j+1))
done


