set terminal pngcairo nocrop enhanced font "verdana,8" size 640,400
set output "PBFT_result.eps"

set terminal postscript eps enhanced color font 'Times-Roman,18'

set title "PBFT Consensus for 4 to 24 nodes"

set grid ytics lc rgb "black" lw 1.5 lt 0.1
set grid xtics lc rgb "black" lw 1.5 lt 0.1


set xlabel "Input TPS"
set ylabel "Output TPS"

set yrange [0 to 25]

set key at graph 0.25, 0.95

#csv settings:
# set key autotitle columnhead
set datafile separator comma


$data << EOD
5, 5, 5, 5, 5, 5, 5
10, 10, 10, 9.3, 10, 10, 8
15, 14, 14, 13.6, 14, 13, 10
20, 17, 17, 16.1, 14, 10, 5
25, 20, 19, 18.6, 14, 9, 15
30, 20, 19, 17.2, 13, 9, 11
40, 21, 21, 18.3, 13, 14, 17
50, 25, 20, 16.9, 13, 13, 13
EOD

plot "$data" using 1:2 with linespoints lw 2 title "4 nodes", \
    "$data" using 1:3 with linespoints lw 2 title "6 nodes", \
    "$data" using 1:4 with linespoints lw 2 title "8 nodes", \
    "$data" using 1:5 with linespoints lw 2 title "12 nodes", \
    "$data" using 1:6 with linespoints lw 2 title "18 nodes", \
    "$data" using 1:7 with linespoints lw 2 title "24 nodes"