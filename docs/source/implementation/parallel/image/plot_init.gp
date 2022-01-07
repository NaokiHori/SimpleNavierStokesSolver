reset

lx = 7.
ly = 11.

set terminal epslatex standalone color size lx+4.5,ly+3 font ',20'
set output 'init.tex'
unset border
set lmargin 0.
set rmargin 0.
set bmargin 0.
set tmargin 0.
unset xlabel
unset ylabel
set xrange [-2.5:lx+2.0]
set yrange [-1.5:ly+1.5]
unset xtics
unset ytics
set style line 1 lc rgb '#000000' lw 5  dt 2
set style line 2 lc rgb '#000000' lw 10
set style arrow 1 nohead front ls 1
set style arrow 2 heads size graph 0.02,20. filled front ls 2
ox = 0.
oy = 0.
# process 0
set object rectangle from first ox+0., first oy+0. to first ox+lx, first oy+3. fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
set label 'mpirank 0' center at first ox-1.25, first 1.5
# process 1
set object rectangle from first ox+0., first oy+3. to first ox+lx, first oy+7. fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
set label 'mpirank 1' center at first ox-1.25, first 5.0
# process 2
set object rectangle from first ox+0., first oy+7. to first ox+lx, first oy+ly fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
set label 'mpirank 2' center at first ox-1.25, first 9.0
# process 0 (repeated)
set object rectangle from first ox+0., first oy+ly to first ox+lx, first oy+ly+1. fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
set label 'mpirank 0' center at first ox-1.25, first oy+ly+0.5
# process 2 (repeated)
set object rectangle from first ox+0., first oy-1. to first ox+lx, first oy    fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
set label 'mpirank 2' center at first ox-1.25, first oy-0.5
# horizontal
do for [j=-1:ly+1:1] {
  set arrow from first ox+0., first j to first ox+lx, j as 1
}
# vertical
do for [i=0:lx:1] {
  set arrow from first ox+i, first -1. to first ox+i, ly+1. as 1
}

set arrow from first ox+lx+0.5,oy to first ox+lx+0.5,oy+ly as 2
set label 'Repeated' left at first ox+lx+1., oy+0.5*ly rotate by 90

plot \
  NaN notitle
