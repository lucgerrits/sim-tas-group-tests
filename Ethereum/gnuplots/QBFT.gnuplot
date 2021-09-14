set terminal pngcairo nocrop enhanced font "verdana,8" size 640,400
set output "QBFT_result.eps"

set terminal postscript eps enhanced color font 'Times-Roman,18'

set title "QBFT Consensus for 5 to 25 nodes"

set grid ytics lc rgb "black" lw 1.5 lt 0.1
set grid xtics lc rgb "black" lw 1.5 lt 0.1


set xlabel "Input TPS"
set ylabel "Output TPS"

set key at graph 0.75, 0.95

#csv settings:
# set key autotitle columnhead
set datafile separator comma


$data << EOD
200,197,196,196,196,196,196,196
500, 465, 463, 400, 380, 290, 270, 250
1000, 220, 215, 214, 213, 213, 212, 210
1500, 220, 215, 212, 211, 210, 210, 205
EOD

plot "$data" using 1:2 with linespoints lw 2 title "5 nodes", \
    "$data" using 1:3 with  linespoints lw 2 title "10 nodes", \
    "$data" using 1:4 with  linespoints lw 2 title "15 nodes", \
    "$data" using 1:5 with  linespoints lw 2 title "17 nodes", \
    "$data" using 1:6 with  linespoints lw 2 title "19 nodes", \
    "$data" using 1:7 with  linespoints lw 2 title "20 nodes", \
    "$data" using 1:8 with  linespoints lw 2 title "25 nodes"