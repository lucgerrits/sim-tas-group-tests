set terminal pngcairo nocrop enhanced font "verdana,8" size 640,400
set output "IBFT_result.eps"

set terminal postscript eps enhanced color font 'Times-Roman,18'

set title "IBFT Consensus for 5 to 25 nodes"

set grid ytics lc rgb "black" lw 1.5 lt 0.1
set grid xtics lc rgb "black" lw 1.5 lt 0.1


set xlabel "Input TPS"
set ylabel "Output TPS"

set key at graph 0.75, 0.95

#csv settings:
# set key autotitle columnhead
set datafile separator comma


$data << EOD
200,196,197,197,197,196,193,193
500, 450, 428, 360, 260, 235, 230, 220
1000, 225, 220, 210, 207, 205, 190, 182
1500, 215, 210, 208, 210, 208, 190, 160
EOD

plot "$data" using 1:2 with linespoints lw 2 title "4 nodes", \
    "$data" using 1:3 with  linespoints lw 2 title "5 nodes", \
    "$data" using 1:4 with  linespoints lw 2 title "7 nodes", \
    "$data" using 1:5 with  linespoints lw 2 title "8 nodes", \
    "$data" using 1:6 with  linespoints lw 2 title "10 nodes", \
    "$data" using 1:7 with  linespoints lw 2 title "20 nodes", \
    "$data" using 1:8 with  linespoints lw 2 title "25 nodes"