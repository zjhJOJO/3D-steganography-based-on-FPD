#!/bin/bash

#/Applications/MATLAB_R2018a.app/bin/matlab -nodisplay -nosplash -nodesktop -r "run('test.m'); exit;"
int=1
while(( $int<=5 ))
do
    /Applications/MATLAB_R2018a.app/bin/matlab -nodisplay -nosplash -nodesktop -nojvm -r "test $int;quit;"
    let "int++"
done