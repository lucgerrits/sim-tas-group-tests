#!/bin/bash


for f in *.gnuplot;
do
    echo "$f"
    gnuplot -p "$f"
done