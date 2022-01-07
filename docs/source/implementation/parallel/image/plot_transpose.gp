reset
{
  lx = 7.
  ly = 11.
  #
  set terminal epslatex standalone color size 2*lx+6.,ly+2. font ',20'
  set output 'transpose1.tex'
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
  set xrange [-2.5:2*lx+3.5]
  set yrange [-0.5:ly+1.5]
  #
  unset xtics
  unset ytics
  #
  set style line 1 lc rgb '#000000' lw 5  dt 2
  set style line 2 lc rgb '#000000' lw 10
  set style line 3 lc rgb '#FF0000' lw 10
  #
  set style arrow 1 nohead front ls 1
  set style arrow 2 head size graph 0.02,20. filled front ls 2
  set style arrow 3 head size graph 0.02,20. filled front ls 3
  #
  ## left
  ox = 0.
  oy = 0.
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
  # memory alignment
  set arrow from first ox-0.5, first oy+0.5 to first ox+lx   +0.5, first oy+0.5 as 3
  set arrow from first ox-0.5, first oy+1.5 to first ox+lx/3.+0.5, first oy+1.5 as 3
  ## right
  ox = lx+3.
  oy = 0.
  # process 0
  set object rectangle from first ox+0., first oy+0. to first ox+2., first oy+ly fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 0' center at first ox+1.0, first ly+1.0
  # process 1
  set object rectangle from first ox+2., first oy+0. to first ox+4., first oy+ly fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 1' center at first ox+3.0, first ly+1.0
  # process 2
  set object rectangle from first ox+4., first oy+0. to first ox+lx, first oy+ly fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 2' center at first ox+5.5, first ly+1.0
  # horizontal
  do for [j=0:ly:1] {
    set arrow from first ox+0., first j to first ox+lx, j as 1
  }
  # vertical
  do for [i=0:lx:1] {
    set arrow from first ox+i, first 0. to first ox+i, ly as 1
  }
  # memory alignment
  set arrow from first ox+0.5, first oy-0.5 to first ox+0.5, first oy+ly   +0.5 as 3
  set arrow from first ox+1.5, first oy-0.5 to first ox+1.5, first oy+ly/3.+0.5 as 3
  ## arrow
  set arrow from first lx+0.5, first 0.5*ly to first lx+2.5, first 0.5*ly as 2
  plot \
    NaN notitle
}

reset
{
  lx = 7.
  ly = 11.
  #
  set terminal epslatex standalone color size lx+3.,ly+1. font ',20'
  set output 'transpose2.tex'
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
  set xrange [-2.5:lx+0.5]
  set yrange [-0.5:ly+0.5]
  #
  unset xtics
  unset ytics
  #
  set style line 1 lc rgb '#000000' lw 5 dt 2
  #
  set style arrow 1 nohead front ls 1
  #
  ## left
  ox = 0.
  oy = 0.
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
  do for [j=0:ly-1:1] {
    do for [i=0:lx-1:1] {
      set label sprintf('$%2d - %2d$', j, i) center at first i+0.5, first j+0.5 front
    }
  }
  plot \
    NaN notitle
}

reset
{
  lx = 7.
  ly = 11.
  #
  set terminal epslatex standalone color size 2*lx+6.,ly+2. font ',20'
  set output 'transpose3.tex'
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
  set xrange [-2.5:2*lx+3.5]
  set yrange [-0.5:ly+1.5]
  #
  unset xtics
  unset ytics
  #
  set style line 1 lc rgb '#000000' lw 5  dt 2
  set style line 2 lc rgb '#000000' lw 10
  set style line 3 lc rgb '#FF0000' lw 10
  #
  set style arrow 1 nohead front ls 1
  set style arrow 2 head size graph 0.02,20. filled front ls 2
  set style arrow 3 head size graph 0.02,20. filled front ls 3
  #
  ## left
  ox = 0.
  oy = 0.
  # process 0
  set object rectangle from first ox+0., first oy+0. to first ox+lx, first oy+3. fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 0' center at first -1.25, first 1.5
  # process 1
  set object rectangle from first ox+0., first oy+3. to first ox+lx, first oy+7. fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 1' center at first -1.25, first 5.0
  # process 2
  set object rectangle from first ox+0., first oy+7. to first ox+lx, first oy+ly fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 2' center at first -1.25, first 9.0
  # vertical
  set arrow from first ox+2., first 0. to first ox+2., ly as 1
  set arrow from first ox+4., first 0. to first ox+4., ly as 1
  # A
  set label '$A_{00}$' center at first ox+1.0, first oy+1.5 front
  set label '$A_{01}$' center at first ox+3.0, first oy+1.5 front
  set label '$A_{02}$' center at first ox+5.5, first oy+1.5 front
  set label '$A_{10}$' center at first ox+1.0, first oy+5.0 front
  set label '$A_{11}$' center at first ox+3.0, first oy+5.0 front
  set label '$A_{12}$' center at first ox+5.5, first oy+5.0 front
  set label '$A_{20}$' center at first ox+1.0, first oy+9.0 front
  set label '$A_{21}$' center at first ox+3.0, first oy+9.0 front
  set label '$A_{22}$' center at first ox+5.5, first oy+9.0 front
  ## right
  ox = lx+3.
  oy = 0.
  # process 0
  set object rectangle from first ox+0., first oy+0. to first ox+2., first oy+ly fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 0' center at first ox+1.0, first ly+1.0
  # process 1
  set object rectangle from first ox+2., first oy+0. to first ox+4., first oy+ly fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 1' center at first ox+3.0, first ly+1.0
  # process 2
  set object rectangle from first ox+4., first oy+0. to first ox+lx, first oy+ly fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 2' center at first ox+5.5, first ly+1.0
  # horizontal
  set arrow from first ox+0., first 3. to first ox+lx, 3. as 1
  set arrow from first ox+0., first 7. to first ox+lx, 7. as 1
  # A
  set label '$A_{00}$' center at first ox+1.0, first oy+1.5 front
  set label '$A_{01}$' center at first ox+3.0, first oy+1.5 front
  set label '$A_{02}$' center at first ox+5.5, first oy+1.5 front
  set label '$A_{10}$' center at first ox+1.0, first oy+5.0 front
  set label '$A_{11}$' center at first ox+3.0, first oy+5.0 front
  set label '$A_{12}$' center at first ox+5.5, first oy+5.0 front
  set label '$A_{20}$' center at first ox+1.0, first oy+9.0 front
  set label '$A_{21}$' center at first ox+3.0, first oy+9.0 front
  set label '$A_{22}$' center at first ox+5.5, first oy+9.0 front
  ## arrow
  set arrow from first lx+0.5, first 0.5*ly to first lx+2.5, first 0.5*ly as 2
  plot \
    NaN notitle
}

reset
{
  lx = 7.
  ly = 11.
  #
  set terminal epslatex standalone color size lx+2.,ly+2. font ',20'
  set output 'transpose4.tex'
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
  set xrange [-0.5:lx+1.5]
  set yrange [-1.5:ly+0.5]
  #
  unset xtics
  unset ytics
  #
  set style line 1 lc rgb '#000000' lw 5 dt 2
  set style line 2 lc rgb '#FF0000' lw 10
  set style line 3 lc rgb '#000000' lw 20
  set style line 4 lc rgb '#0000FF' lw 10
  set style line 5 lc rgb '#000000' lw 7.5
  #
  set style arrow 1 nohead                            front ls 1
  set style arrow 2 head   size graph 0.02,20. filled front ls 2
  set style arrow 3 nohead                            front ls 3
  set style arrow 4 head   size graph 0.020,20. filled front ls 4
  set style arrow 5 heads  size graph 0.015,15. filled front ls 5
  #
  ox = 0.
  oy = 0.
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
  # memory alignment
  set arrow from first ox+2.5, first oy+0.25 to first ox+lx+0.5, first oy+0.25 as 2
  set arrow from first ox-0.5, first oy+1.25 to first ox+2.5,    first oy+1.25 as 2
  set arrow from first ox+2.5, first oy-0.5  to first ox+2.5,    first oy+3.5  as 4
  do for [j=0:2:1] {
    do for [i=2:3:1] {
      set label sprintf('$%2d - %2d$', j, i) center at first i+0.5, first j+0.5 front
    }
  }
  # variables
  set arrow from first ox+lx+0.25, first oy to first ox+lx+0.25, first oy+3. as 5
  set label 'count' left at ox+lx+0.5, oy+1.5
  set arrow from first ox+2., first oy-0.25 to first ox+3., first oy-0.25 as 5
  set label 'blocklength' center at ox+2.5, oy-0.75
  set label '{\textcolor{red}{stride}}' left at ox+lx+1., oy+0.25
  plot \
    NaN notitle
}

reset
{
  lx = 7.
  ly = 11.
  #
  set terminal epslatex standalone color size 2.*lx+4.,ly+2. font ',20'
  set output 'transpose5.tex'
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
  set xrange [-0.5:2.*lx+3.5]
  set yrange [-1.5:ly+0.5]
  #
  unset xtics
  unset ytics
  #
  set style line 1 lc rgb '#000000' lw 5 dt 2
  set style line 2 lc rgb '#FF0000' lw 10
  set style line 3 lc rgb '#000000' lw 20
  set style line 4 lc rgb '#0000FF' lw 10
  set style line 5 lc rgb '#000000' lw 7.5
  set style line 6 lc rgb '#0000FF' lw 7.5
  #
  set style arrow 1 nohead                             front ls 1
  set style arrow 2 head   size graph 0.020,20. filled front ls 2
  set style arrow 3 nohead                             front ls 3
  set style arrow 4 head   size graph 0.020,20. filled front ls 4
  set style arrow 5 heads  size graph 0.015,15. filled front ls 5
  set style arrow 6 heads  size graph 0.015,15. filled front ls 6
  #
  ## left
  ox = 0.
  oy = 0.
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
  # memory alignment
  set arrow from first ox+2.5, first oy+0.25 to first ox+3.5, first oy+0.25 as 2
  do for [j=0:2:1] {
    do for [i=2:3:1] {
      set label sprintf('$%2d - %2d$', j, i) center at first i+0.5, first j+0.5 front
    }
  }
  # blue rectangles
  set object rectangle from first ox+2.1, first oy+0.1 to first ox+2.9, first oy+2.9 fc rgb '#0000FF' fillstyle empty border lc rgb '#0000FF' lw 10 back
  set object rectangle from first ox+3.1, first oy+0.1 to first ox+3.9, first oy+2.9 fc rgb '#0000FF' fillstyle empty border lc rgb '#0000FF' lw 10 back
  # variables
  set arrow from first ox+2., first oy-0.25 to first ox+4., first oy-0.25 as 5
  set label 'count' center at ox+3., oy-0.75 front
  set arrow from first ox+2., first oy+3.25 to first ox+3., first oy+3.25 as 6
  set label '{\textcolor{blue}{blocklength}}' center at ox+2.5, oy+3.75 front
  set label '{\textcolor{red}{stride}}' left at first ox+4.5, first oy+0.25 front
  ## right
  ox = lx+2.
  oy = 0.5*ly-0.5
  do for [i=0:6:1] {
    if(i == 0 || i == 6){
      set arrow from first ox+i, first oy to first ox+i, oy+1. as 3
    }else{
      set arrow from first ox+i, first oy to first ox+i, oy+1. as 1
    }
  }
  set label '(virtual) buffer' center at first ox+3., first oy+1.5
  set arrow from first ox, first oy    to first ox+6., oy    as 3
  set arrow from first ox, first oy+1. to first ox+6., oy+1. as 3
  set label sprintf('$%2d - %2d$', 0, 2) center at first ox+0.5, first oy+0.5
  set label sprintf('$%2d - %2d$', 1, 2) center at first ox+1.5, first oy+0.5
  set label sprintf('$%2d - %2d$', 2, 2) center at first ox+2.5, first oy+0.5
  set label sprintf('$%2d - %2d$', 0, 3) center at first ox+3.5, first oy+0.5
  set label sprintf('$%2d - %2d$', 1, 3) center at first ox+4.5, first oy+0.5
  set label sprintf('$%2d - %2d$', 2, 3) center at first ox+5.5, first oy+0.5
  set arrow from first ox-0.5, first oy+0.25 to first ox+6.5, first oy+0.25 as 4
  plot \
    NaN notitle
}

reset
{
  lx = 7.
  ly = 11.
  #
  set terminal epslatex standalone color size 2.*lx+4.,ly+3. font ',20'
  set output 'transpose6.tex'
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
  set xrange [-0.5:2.*lx+3.5]
  set yrange [-1.5:ly+1.5]
  #
  unset xtics
  unset ytics
  #
  set style line 1 lc rgb '#000000' lw 5 dt 2
  set style line 2 lc rgb '#FF0000' lw 10
  set style line 3 lc rgb '#000000' lw 20
  set style line 4 lc rgb '#0000FF' lw 10
  set style line 5 lc rgb '#000000' lw 7.5
  set style line 6 lc rgb '#0000FF' lw 7.5
  #
  set style arrow 1 nohead                            front ls 1
  set style arrow 2 head   size graph 0.02,20. filled front ls 2
  set style arrow 3 nohead                            front ls 3
  set style arrow 4 head   size graph 0.020,20. filled front ls 4
  set style arrow 5 heads  size graph 0.015,15. filled front ls 5
  set style arrow 6 heads  size graph 0.015,15. filled front ls 6
  #
  ## right
  ox = 0.5
  oy = 0.5*ly-0.5
  do for [i=0:6:1] {
    if(i == 0 || i == 6){
      set arrow from first ox+i, first oy to first ox+i, oy+1. as 3
    }else{
      set arrow from first ox+i, first oy to first ox+i, oy+1. as 1
    }
  }
  set arrow from first ox, first oy    to first ox+6., oy    as 3
  set arrow from first ox, first oy+1. to first ox+6., oy+1. as 3
  set label sprintf('$%2d - %2d$', 0, 2) center at first ox+0.5, first oy+0.5
  set label sprintf('$%2d - %2d$', 1, 2) center at first ox+1.5, first oy+0.5
  set label sprintf('$%2d - %2d$', 2, 2) center at first ox+2.5, first oy+0.5
  set label sprintf('$%2d - %2d$', 0, 3) center at first ox+3.5, first oy+0.5
  set label sprintf('$%2d - %2d$', 1, 3) center at first ox+4.5, first oy+0.5
  set label sprintf('$%2d - %2d$', 2, 3) center at first ox+5.5, first oy+0.5
  set arrow from first ox-0.5, first oy+0.25 to first ox+6.5, first oy+0.25 as 4
  ## left
  ox = 8.
  oy = 0.
  # process 0
  set object rectangle from first ox+0., first oy+0. to first ox+2., first oy+ly fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 0' center at first ox+1.0, first oy+ly+1.0
  # process 1
  set object rectangle from first ox+2., first oy+0. to first ox+4., first oy+ly fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 1' center at first ox+3.0, first oy+ly+1.0
  # process 2
  set object rectangle from first ox+4., first oy+0. to first ox+lx, first oy+ly fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 2' center at first ox+5.5, first oy+ly+1.0
  # horizontal
  do for [j=0:ly:1] {
    set arrow from first ox+0., first j to first ox+lx, j as 1
  }
  # vertical
  do for [i=0:lx:1] {
    set arrow from first ox+i, first 0. to first ox+i, ly as 1
  }
  # memory alignment
  set arrow from first ox+2.75, first oy-0.5 to first ox+2.75, first oy+ly+0.5 as 2
  set arrow from first ox+3.75, first oy-0.5 to first ox+3.75, first oy   +0.5 as 2
  do for [j=0:2:1] {
    do for [i=2:3:1] {
      set label sprintf('$%2d - %2d$', j, i) center at first ox+i+0.5, first oy+j+0.5 front
    }
  }
  # variables
  set arrow from first ox+2., first oy-0.25 to first ox+4., first oy-0.25 as 5
  set label 'count' center at ox+3., oy-0.75 front
  set arrow from first ox+1.75, first oy to first ox+1.75, first oy+4. as 5
  set label 'blocklength' right at ox+1.5, oy+1.5 front
  set label '{\textcolor{red}{stride}}' left at first ox+4.5, first oy+0.25 front
  plot \
    NaN notitle
}

