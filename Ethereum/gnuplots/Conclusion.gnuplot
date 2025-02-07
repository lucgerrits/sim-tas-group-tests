set terminal pngcairo nocrop enhanced font "verdana,8" size 640,400
set output "Conclusion_result.eps"

set terminal postscript eps enhanced color font 'Times-Roman,18'

set title "BFT Consensus Behaviour"

set grid ytics lc rgb "black" lw 1.5 lt 0.1
set grid xtics lc rgb "black" lw 1.5 lt 0.1


set xlabel "No of Nodes"
set ylabel "Output TPS"

set xtics (4,5,6,7,8,10,12,15,17,18,19,20,24,25)
# set xrange [0 to 25]
set yrange [0 to 1.1]

set key at graph 0.98, 0.3

#csv settings:
# set key autotitle columnhead
set datafile separator comma


plot "conclusion.csv" using 1:2 with linespoints lw 2 title "Clique (max=1500)", \
    "conclusion.csv" using 1:3 with  linespoints lw 2 title "IBFT (max=450)", \
    "conclusion.csv" using 1:4 with  linespoints lw 2 title "QBFT (max=465)", \
    "conclusion.csv" using 1:5 with  linespoints lw 2 title "PBFT (max=25)"