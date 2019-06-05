#!/bin/bash
# Escriba su código aquí
for i in data*;do sed '/^$/d' $i > out1$i;done
for i in out1data*; do csvstack -l -H $i > out2$i; done
csvstack -g data1.csv,data2.csv,data3.csv out2* > data.csv
sed '1d' data.csv > out
awk '{gsub(/\t/,",");gsub(/[[:space:]]+/,",");print}' out > data.csv
N="$(grep -o -E '[a-z]+:[0-9]' data.csv | wc -l)"

for i in `seq $(echo "$N")`
do
    for i in $(cat data.csv)
    do
        echo $i | awk '{print gensub(/([a-z]+[0-9]\.[a-z]+,[0-9],[A-Z])(.+)(,[a-z]+:[0-9])/,"\\1\\2""\n\\1\\3",1)}' >> temp
    done  < data.csv
    #rm data.csv
    mv temp data.csv
done
cat data.csv
rm data.csv| rm out*
