for i in 0 1 2 3 4 5
do
  for j in 1 2
  do 
    hlaska=`grep $i$j hlasky.txt| cut -d: -f2` 
    echo $hlaska
    echo "\def\a{$i}\def\b{$hlaska}" > data.tex
    pdflatex hlasky.tex
    mv hlasky.pdf tpb_hod$i$j.pdf
  done
done