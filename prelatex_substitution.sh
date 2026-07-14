echo $1

sed -i "s/$(echo -ne '\u2061')/ /g" $1
sed -i "s/$(echo -ne '\u200B')/ /g" $1
sed -i "s/$(echo -ne '\u2013')/-/g" $1
sed -i "s/$(echo -ne '\u2212')/-/g" $1
sed -i "s/€/EURO/g" $1

sed -i "s/mathrm{zł}/text{z\\\\l{}}/g" $1

sed -i "s/\\\\array/\\\\PMATRIX/g" $1
perl -0pi -e 's/\\\\left *\( *\n/\\\\left (/g' $1
sed -i "s/\\\\left (\\\\PMATRIX/\\\\left( \\\\MATRIX/g" $1

# Dvojradkovy vyraz \left|\PMATRIX za \left|\ARRAY
#sed -i ':a;N;$!ba;s#\\left| *\n\\PMATRIX#\\left|\\ARRAY#g' $1
perl -0pi -e 's/\\left\|[ \t]*\n\\PMATRIX/\\left|\\ARRAY/g' $1