set terminal pngcairo nocrop enhanced font "verdana,8" size 640,400
set output "Clique_result.eps"

set terminal postscript eps enhanced color font 'Times-Roman,18'

set title "Clique Consensus for 5 to 25 nodes"

set grid ytics lc rgb "black" lw 1.5 lt 0.1
set grid xtics lc rgb "black" lw 1.5 lt 0.1


set xlabel "Input TPS"
set ylabel "Output TPS"

set key at graph 0.32, 0.95

#csv settings:
# set key autotitle columnhead
set datafile separator comma


$data << EOD
200,196,194,193,193
500,460,468,460,460
1000,880,830,820,770
1500,1200,1400,1200,1100
2000,1500,1400,1200,1100
3000,1500,1400,1200,1100
EOD

plot "$data" using 1:2 with linespoints title "5 nodes", \
    "$data" using 1:3 with linespoints title "10 nodes", \
    "$data" using 1:4 with linespoints title "20 nodes", \
    "$data" using 1:5 with linespoints title "25 nodes"