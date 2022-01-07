reset

lx = 7.
ly = 11.

set terminal epslatex standalone color size 2*lx+12,ly+2 font ',20'
set output 'domain.tex'
unset border
set lmargin 0.
set rmargin 0.
set bmargin 0.
set tmargin 0.
unset xlabel
unset ylabel
set xrange [-2.5:2*lx+9.5]
set yrange [-1.5:ly+0.5]
unset xtics
unset ytics
set style line 1 lc rgb '#000000' lw 5  dt 2
set style line 2 lc rgb '#000000' lw 10
set style arrow 1 nohead front ls 1
set style arrow 2 head size graph 0.02,20. filled front ls 2
## left
ox = 0.5
oy = 0.
# whole domain
set object rectangle from first ox+0., first oy+0. to first ox+lx, first oy+ly fc rgb '#000000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
set label 'whole domain' center at first ox-1.25, first 0.5*ly
# horizontal
do for [j=0:ly:1] {
  set arrow from first ox+0., first j to first ox+lx, j as 1
}
# vertical
do for [i=0:lx:1] {
  set arrow from first ox+i, first 0. to first ox+i, ly as 1
}
# x index
set label '$1$'    center at first ox+0.5, first oy-0.5
set label '$itot$' center at first ox+6.5, first oy-0.5
# y index
set label '$1$'    center at first ox+7.7, first oy+ 0.5
set label '$jtot$' center at first ox+7.7, first oy+10.5

## right
ox = lx+7
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
# horizontal
do for [j=0:ly:1] {
  set arrow from first ox+0., first j to first ox+lx, j as 1
}
# vertical
do for [i=0:lx:1] {
  set arrow from first ox+i, first 0. to first ox+i, ly as 1
}
# x index
set label '$1$'     center at first ox+0.5, first oy-0.5
set label '$itot$'  center at first ox+6.5, first oy-0.5
# y index
set label '$1$'     center at first ox+7.7, first oy+ 0.5
set label '$jsize$' center at first ox+7.7, first oy+ 2.5
set label '$1$'     center at first ox+7.7, first oy+ 3.5
set label '$jsize$' center at first ox+7.7, first oy+ 6.5
set label '$1$'     center at first ox+7.7, first oy+ 7.5
set label '$jsize$' center at first ox+7.7, first oy+10.5

## arrow
set arrow from first lx+2.0, first 0.5*ly to first lx+4.0, first 0.5*ly as 2

plot \
  NaN notitle
