#!/bin/bash

tar -xzf R413.tar.gz


export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R

mkdir -p packages
export R_LIBS=$PWD/packages


A=$1
echo "${A##*/}" 
Rscript linearRegression.R "${A##*/}"
