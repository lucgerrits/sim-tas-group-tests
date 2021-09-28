# set terminal pngcairo size 600,400
set output "finished_and_invalid_rate.eps"

set terminal postscript eps enhanced color font 'Times-Roman,18' size 9,10

set multiplot layout 4,1 

######################################

set title "Finished rate for 5 to 10 nodes"

set grid ytics lc rgb "black" lw 1.5 lt 0.1
set grid xtics lc rgb "black" lw 1.5 lt 0.1


set xlabel "Input TPS"
set ylabel "Finished TPS"

# set yrange [0 to 2500]
set xtics ("200" 200, "400" 400, "600" 600, "800" 800, "1000" 1000, "1200" 1200, "1400" 1400, "1600" 1600, "2000" 2000, "2500" 2500)

set key at graph 0.25, 0.95

#csv settings:
set datafile separator ","


$data << EOD
200,129.9,125,121.6,120.9
400,320.2,318.5,321.2,321.3
600,387.6,388.7,394,395.8
800,442.3,443.6,463.8,476
1000,563.3,675.5,753,714.3
1200,777.4,834.6,855.4,902.4
1400,774,881.4,861.6,817
1600,682,776.2,777.9,939
2000,630.8,767.1,811.3,728.1
2500,544.6,626.8,763.7,736
EOD

plot "$data" using 1:2 with linespoints lw 2 title "5 nodes", \
    "$data" using 1:3 with linespoints lw 2 title "7 nodes", \
    "$data" using 1:4 with linespoints lw 2 title "9 nodes", \
    "$data" using 1:5 with linespoints lw 2 title "10 nodes"
unset key 


######################################

set title "Invalid rate for 5 to 10 nodes"

set grid ytics lc rgb "black" lw 1.5 lt 0.1
set grid xtics lc rgb "black" lw 1.5 lt 0.1


set xlabel "Input TPS"
set ylabel "Invalid TPS"

# set yrange [0 to 2500]
set xtics ("200" 200, "400" 400, "600" 600, "800" 800, "1000" 1000, "1200" 1200, "1400" 1400, "1600" 1600, "2000" 2000, "2500" 2500)

set key at graph 0.25, 0.95

#csv settings:
set datafile separator ","

$data << EOD
200,0,0,0,0
400,0,0,0,0
600,0,0,0,0
800,0,0,0,0.3
1000,0,1.1,2.8,2.1
1200,3.7,7,7.4,9.3
1400,5.8,7.2,9,6.9
1600,5,6.6,8,12.1
2000,1.3,7.9,8.8,6.6
2500,0.8,4.6,6.4,5.8
EOD

plot "$data" using 1:2 with linespoints lw 2 title "5 nodes", \
    "$data" using 1:3 with linespoints lw 2 title "7 nodes", \
    "$data" using 1:4 with linespoints lw 2 title "9 nodes", \
    "$data" using 1:5 with linespoints lw 2 title "10 nodes"


######################################

set title "Finished rate variance for 5 to 10 nodes"

set grid ytics lc rgb "black" lw 1.5 lt 0.1
set grid xtics lc rgb "black" lw 1.5 lt 0.1


set xlabel "Input TPS"
set ylabel "Finished Rate Variance"

# set yrange [0 to 2500]
set xtics ("200" 200, "400" 400, "600" 600, "800" 800, "1000" 1000, "1200" 1200, "1400" 1400, "1600" 1600, "2000" 2000, "2500" 2500)

set key at graph 0.25, 0.95

#csv settings:
set datafile separator ","

$data << EOD
200,13625.1,12685.7,12146.5,12023.2
400,160784.2,162361,163510.1,163522.3
600,336682.5,340711.4,346612.7,346336.7
800,529533.1,541444.4,569816,639358.6
1000,882013.6,1136822.7,1277317.5,1165240.2
1200,1454155.4,1527706.2,1451325.2,1503156.4
1400,1418642.5,1595332.3,1510776.9,1320889.7
1600,1259843.6,1347674,1242400,1690867.6
2000,1086383.1,1327598.4,1477678.8,1216336.5
2500,871805.8,1011058.4,1273422.8,1174852.8
EOD

plot "$data" using 1:2 with linespoints lw 2 title "5 nodes", \
    "$data" using 1:3 with linespoints lw 2 title "7 nodes", \
    "$data" using 1:4 with linespoints lw 2 title "9 nodes", \
    "$data" using 1:5 with linespoints lw 2 title "10 nodes"



######################################

set title "Max finished rate for 5 to 10 nodes"

set grid ytics lc rgb "black" lw 1.5 lt 0.1
set grid xtics lc rgb "black" lw 1.5 lt 0.1


set xlabel "Input TPS"
set ylabel "Max Finished Rate"

# set yrange [0 to 2500]
set xtics ("200" 200, "400" 400, "600" 600, "800" 800, "1000" 1000, "1200" 1200, "1400" 1400, "1600" 1600, "2000" 2000, "2500" 2500)

set key at graph 0.25, 0.95

#csv settings:
set datafile separator ","

$data << EOD
200,262.8,247.3,245.7,241.2
400,934.4,940.9,951,956.4
600,1500.2,1545.1,1565.6,1556.6
800,2138,2153.4,2199.2,2438.4
1000,2946.3,3085.2,3363.2,3225.3
1200,3441.4,3684.2,3519.6,3674.7
1400,3480.6,3796.5,3725.3,3400.8
1600,3375.9,3402.8,3206.9,3818.7
2000,3092.5,3409.8,3609.6,3449.7
2500,2926.5,3013.1,3234.7,3168.2

EOD

plot "$data" using 1:2 with linespoints lw 2 title "5 nodes", \
    "$data" using 1:3 with linespoints lw 2 title "7 nodes", \
    "$data" using 1:4 with linespoints lw 2 title "9 nodes", \
    "$data" using 1:5 with linespoints lw 2 title "10 nodes"



######################################


unset multiplot 
