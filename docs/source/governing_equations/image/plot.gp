reset

xmin = 0
xmax = 3
ymin = 0
ymax = 2

lx = xmax-xmin
ly = ymax-ymin

set terminal epslatex standalone color size lx,ly font ',17.28'
set output 'schematic.tex'

set lmargin 0
set rmargin 0
set bmargin 0
set tmargin 0

unset border

unset xlabel
unset ylabel

set xrange [xmin:xmax]
set yrange [ymin:ymax]

unset xtics
unset ytics

set style line 1 lc rgb '#FF0000' lw 10
set style line 2 lc rgb '#0000FF' lw 10
set style line 3 lc rgb '#000000' lw 5
set style line 4 lc rgb '#000000' lw 5

set style arrow 1 nohead front ls 1
set style arrow 2 nohead front ls 2
set style arrow 3 head  size 0.1,10 filled front ls 3
set style arrow 4 heads size 0.1,10 filled front ls 4

set arrow from first 0.5, first 0.5 to first 2.5, first 0.5 as 1
set arrow from first 0.5, first 1.5 to first 2.5, first 1.5 as 2
set arrow from first 0.4, first 1.2 to first 0.4, first 0.8 as 3
set arrow from first 2.3, first 0.6 to first 2.3, first 1.4 as 4
set arrow from first 0.6, first 0.7 to first 2.4, first 0.7 as 4

set label '$g$'   left   at first 0.5, first 1.0
set label '$l_x$' left   at first 2.4, first 1.0
set label '$l_y$' center at first 1.5, first 0.9

set label '$T_{H}$' center at first 1.5, first 0.3
set label '$T_{L}$' center at first 1.5, first 1.7

plot \
  NaN notitle

