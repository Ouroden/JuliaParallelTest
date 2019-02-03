#!/bin/bash

for i in {1..12}; do
  #printf "${i} core(s): "
  x=`cat logs/${i}.out | grep "seconds" | awk -F' ' '{print $1}'`
  y=`echo ${x}/${i} | bc -l`
  printf "${y}\n"
done
