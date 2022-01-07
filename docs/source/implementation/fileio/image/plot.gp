reset
{
  lx = 7.
  ly = 11.
  #
  set terminal epslatex standalone color size lx+4.,ly+2.5 font ',20'
  set output 'image1.tex'
  #
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  #
  unset xlabel
  unset ylabel
  #
  set xrange [-2.5:lx+1.5]
  set yrange [-1.5:ly+1.0]
  #
  unset xtics
  unset ytics
  #
  set style line 1 lc rgb '#000000' lw 5 dt 2
  set style line 2 lc rgb '#000000' lw 10
  #
  set style arrow 1 nohead front ls 1
  set style arrow 2 heads size 0.2,10 front ls 2
  #
  ox = 0.
  oy = 0.
  set label 'drank = 2 (two-dimensional)' center at graph 0.5, first ly+0.5
  # process 0
  set object rectangle from first ox+0., first oy+0. to first ox+lx, first oy+3. fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 0' center at first -1.25, first 1.5
  # process 1
  set object rectangle from first ox+0., first oy+3. to first ox+lx, first oy+7. fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 1' center at first -1.25, first 5.0
  # process 2
  set object rectangle from first ox+0., first oy+7. to first ox+lx, first oy+ly fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 2' center at first -1.25, first 9.0
  # horizontal
  do for [j=0:ly:1] {
    set arrow from first ox+0., first j to first ox+lx, j as 1
  }
  # vertical
  do for [i=0:lx:1] {
    set arrow from first ox+i, first 0. to first ox+i, ly as 1
  }
  # dims
  set arrow from first 0., first -0.5 to first lx, first -0.5 as 2
  set label 'dims[1]' center at first 0.5*lx,-1. front
  set arrow from first lx+0.5, first 0. to first lx+0.5, first ly as 2
  set label 'dims[0]' left at first lx+0.55, first 0.5*ly front
  # count (rank 0)
  set arrow from first 0., first 0.25 to first lx, first 0.25 as 2
  set label 'count[1]' center at first 0.5*lx,0.5 front
  set arrow from first 0.25, first 0. to first 0.25, first 3. as 2
  set label 'count[0]' left at first 0.30,1.5 front
  # count (rank 1)
  set arrow from first 0., first 3.25 to first lx, first 3.25 as 2
  set label 'count[1]' center at first 0.5*lx,3.5 front
  set arrow from first 0.25, first 3. to first 0.25, first 7. as 2
  set label 'count[0]' left at first 0.30,5.0 front
  # count (rank 2)
  set arrow from first 0., first 7.25 to first lx, first 7.25 as 2
  set label 'count[1]' center at first 0.5*lx,7.5 front
  set arrow from first 0.25, first 7. to first 0.25, first 11. as 2
  set label 'count[0]' left at first 0.30,9.0 front
  # offset (rank 1)
  set arrow from first lx-0.75, first 0. to first lx-0.75, first 3. as 2
  set label 'offset[0]' right at first lx-0.65,3.5 front
  # offset (rank 2)
  set arrow from first lx-0.50, first 0. to first lx-0.50, first 7. as 2
  set label 'offset[0]' right at first lx-0.40,7.5 front
  plot \
    NaN notitle
}

