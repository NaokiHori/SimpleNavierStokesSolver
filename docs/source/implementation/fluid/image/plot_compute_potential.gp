reset
{
  set terminal epslatex standalone color size 8,4 font ',17'
  set output 'compute_potential1.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:8]
  set yrange [0:4]
  unset xtics
  unset ytics
  set format x ''
  set format y ''
  set style line 1 lc rgb '#888888' lw 5
  set style line 2 lc rgb '#FF0000' lw 10
  set style line 3 lc rgb '#0000FF' lw 10
  set style line 4 lc rgb '#000000' lw 5
  set style arrow 1 nohead front ls 1
  set style arrow 2 head size 0.2,10 filled front ls 2
  set style arrow 3 head size 0.2,10 filled front ls 3
  set style arrow 4 heads size 0.2,10 filled front ls 4
  al = 0.25
## left
  set label 'Math' center at graph 0.25, graph 0.92
  ox = 0.75
  oy = 0.75
  lx = 2.5
  ly = 2.5
# grid
  set arrow from first ox,    first oy    to first ox+lx, first oy    as 1
  set arrow from first ox,    first oy+ly to first ox+lx, first oy+ly as 1
  set arrow from first ox,    first oy    to first ox,    first oy+ly as 1
  set arrow from first ox+lx, first oy    to first ox+lx, first oy+ly as 1
# grid size
  set arrow from first ox,    first oy-1.1*al to first ox+lx, first oy-1.1*al as 4
  set label '$\Delta x_i$' center at first ox+0.5*lx, first oy-2.2*al
# ux
  set arrow from first ox-al,     first oy+0.5*ly to first ox+al,     first oy+0.5*ly as 2
  set arrow from first ox+lx-al,  first oy+0.5*ly to first ox+lx+al,  first oy+0.5*ly as 2
  set label '$\left. u_x \right|_{i-\frac{1}{2},j}$' center at first ox,   oy+0.5*ly front
  set label '$\left. u_x \right|_{i+\frac{1}{2},j}$' center at first ox+lx,oy+0.5*ly front
# uy
  set arrow from first ox+0.5*ly, first oy-al     to first ox+0.5*ly, first oy+al     as 3
  set arrow from first ox+0.5*ly, first oy+lx-al  to first ox+0.5*ly, first oy+lx+al  as 3
  set label '$\left. u_y \right|_{i,j-\frac{1}{2}}$' center at first ox+0.5*lx,oy    front
  set label '$\left. u_y \right|_{i,j+\frac{1}{2}}$' center at first ox+0.5*lx,oy+ly front
# qrx
  set object circle center first ox+0.5*lx, first oy+0.5*ly size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set label '$\left. qrx \right|_{i,j}$' center at first ox+0.5*lx,oy+0.5*ly front
## right
  set label 'Code' center at graph 0.75, graph 0.92
  ox = 4.75
  oy = 0.75
  lx = 2.5
  ly = 2.5
# grid
  set arrow from first ox   , first oy    to first ox+lx, first oy    as 1
  set arrow from first ox   , first oy+ly to first ox+lx, first oy+ly as 1
  set arrow from first ox   , first oy    to first ox   , first oy+ly as 1
  set arrow from first ox+lx, first oy    to first ox+lx, first oy+ly as 1
# grid size
  set arrow from first ox,    first oy-1.1*al to first ox+lx, first oy-1.1*al as 4
  set label '$DXF \left( i \right)$' center at first ox+0.5*lx, first oy-2.2*al
# ux
  set arrow from first ox-al,     first oy+0.5*ly to first ox+al,     first oy+0.5*ly as 2
  set arrow from first ox+lx-al,  first oy+0.5*ly to first ox+lx+al,  first oy+0.5*ly as 2
  set label '$UX \left( i  , j   \right)$' center at first ox,   oy+0.5*ly front
  set label '$UX \left( i+1, j   \right)$' center at first ox+lx,oy+0.5*ly front
# uy
  set arrow from first ox+0.5*ly, first oy-al     to first ox+0.5*ly, first oy+al     as 3
  set arrow from first ox+0.5*ly, first oy+lx-al  to first ox+0.5*ly, first oy+lx+al  as 3
  set label '$UY \left( i  , j   \right)$' center at first ox+0.5*lx,oy    front
  set label '$UY \left( i  , j+1 \right)$' center at first ox+0.5*lx,oy+ly front
# qrx
  set object circle center first ox+0.5*lx, first oy+0.5*ly size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set label '$QRX \left( i, j \right)$' center at first ox+0.5*lx,oy+0.5*ly front
  plot \
    NaN notitle
}

reset
{
  lx = 7.
  ly = 11.
  #
  set terminal epslatex standalone color size 2*lx+6.,ly+2. font ',20'
  set output 'compute_potential2.tex'
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
  # potential positions
  do for [j=1:ly:1] {
    do for [i=1:lx:1] {
      set object circle center first ox+(i-0.5), first oy+(j-0.5) size first 1./32. fs solid 1.0 fc rgb '#888888' lw 3
    }
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
  # potential positions
  do for [j=1:ly:1] {
    do for [i=1:lx:1] {
      set object circle center first ox+(i-0.5), first oy+(j-0.5) size first 1./32. fs solid 1.0 fc rgb '#888888' lw 3
    }
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
  set terminal epslatex standalone color size 2*lx+6.,ly+2. font ',20'
  set output 'compute_potential3.tex'
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
  # potential positions
  do for [j=1:ly:1] {
    do for [i=1:lx:1] {
      set object circle center first ox+(i-0.5), first oy+(j-0.5) size first 1./32. fs solid 1.0 fc rgb '#888888' lw 3
    }
  }
  # memory alignment
  set arrow from first ox+0.5, first oy-0.5 to first ox+0.5, first oy+ly   +0.5 as 3
  set arrow from first ox+1.5, first oy-0.5 to first ox+1.5, first oy+ly/3.+0.5 as 3
  ## right
  ox = lx+3.
  oy = 0.
  # process 0
  set object rectangle from first ox+0., first oy+0. to first ox+2., first oy+6. fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 0' center at first ox+1.0, first ly+1.0
  # process 1
  set object rectangle from first ox+2., first oy+0. to first ox+4., first oy+6. fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 1' center at first ox+3.0, first ly+1.0
  # process 2
  set object rectangle from first ox+4., first oy+0. to first ox+lx, first oy+6. fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 2' center at first ox+5.5, first ly+1.0
  # horizontal
  do for [j=0:6.:1] {
    set arrow from first ox+0., first j to first ox+lx, j as 1
  }
  # vertical
  do for [i=0:lx:1] {
    set arrow from first ox+i, first 0. to first ox+i, 6. as 1
  }
  # potential positions
  do for [j=1:6:1] {
    do for [i=1:lx:1] {
      set object circle center first ox+(i-0.5), first oy+(j-0.5) size first 1./32. fs solid 1.0 fc rgb '#888888' lw 3
    }
  }
  # memory alignment
  set arrow from first ox+0.5, first oy-0.5 to first ox+0.5, first oy+6.+0.5 as 3
  set arrow from first ox+1.5, first oy-0.5 to first ox+1.5, first oy+2.+0.5 as 3
  ## arrow
  set arrow from first lx+0.5, first 0.5*ly to first lx+2.5, first 0.5*ly as 2
  plot \
    NaN notitle
}

reset
{
  array xf[4] = [0., 1.0, 2.5, 4.5]
  #
  set terminal epslatex standalone color size 13.,4.5 font ',20'
  set output 'compute_potential4.tex'
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
  set xrange [0.:13.]
  set yrange [0.:4.5]
  #
  unset xtics
  unset ytics
  #
  set style line 1 lc rgb '#000000' lw 10
  #
  set style arrow 1 nohead front ls 1
  set style arrow 2 heads size 0.1,20 filled front ls 1
  ly = 2.5
  ## left
  ox = 1.00
  oy = 0.75
  set label 'Math' center at first 3.25, first 4.25
# grid
  set arrow from first ox+xf[1], first oy    to first ox+xf[4], first oy    as 1
  set arrow from first ox+xf[1], first oy+ly to first ox+xf[4], first oy+ly as 1
  do for [i=1:4:1] {
    set arrow from first ox+xf[i], first oy to first ox+xf[i], first oy+ly as 1
  }
# pressure dots
  array strings[3] = ['$\Psi_{i-1,J}$', '$\Psi_{i,J}$', '$\Psi_{i+1,J}$']
  do for [i=1:3:1] {
    set object circle center first ox+0.5*(xf[i]+xf[i+1]), first oy+0.5*ly size first 1./32. fs solid 1.0 fc rgb '#888888' lw 3
    set label strings[i] center at first ox+0.5*(xf[i]+xf[i+1]), first oy+0.5*ly
  }
# grid size
  set arrow from first ox+0.5*(xf[1]+xf[2]), first oy+ly+0.25 to first ox+0.5*(xf[2]+xf[3]), first oy+ly+0.25 as 2
  set label '$\Delta x_{i-\frac{1}{2}}$' center at first ox+xf[2], first oy+ly+0.5
  set arrow from first ox+xf[2], first oy-0.25 to first ox+xf[3], first oy-0.25 as 2
  set label '$\Delta x_i$' center at first ox+0.5*(xf[2]+xf[3]), first oy-0.5
  set arrow from first ox+0.5*(xf[2]+xf[3]), first oy+ly+0.25 to first ox+0.5*(xf[3]+xf[4]), first oy+ly+0.25 as 2
  set label '$\Delta x_{i+\frac{1}{2}}$' center at first ox+xf[3], first oy+ly+0.5
  # ## right
  ox = 7.50
  oy = 0.75
  set label 'Code' center at first 9.75, first 4.25
# grid
  set arrow from first ox+xf[1], first oy    to first ox+xf[4], first oy    as 1
  set arrow from first ox+xf[1], first oy+ly to first ox+xf[4], first oy+ly as 1
  do for [i=1:4:1] {
    set arrow from first ox+xf[i], first oy to first ox+xf[i], first oy+ly as 1
  }
# pressure dots
  array strings[3] = ['$QCX \left( i-1, J \right)$', '$QCX \left( i, J \right)$', '$QCX \left( i+1, J \right)$']
  do for [i=1:3:1] {
    set object circle center first ox+0.5*(xf[i]+xf[i+1]), first oy+0.5*ly size first 1./32. fs solid 1.0 fc rgb '#888888' lw 3
    if(i % 2 == 0){
      set label strings[i] center at first ox+0.5*(xf[i]+xf[i+1]), first oy+0.5*ly+0.25
    }else{
      set label strings[i] center at first ox+0.5*(xf[i]+xf[i+1]), first oy+0.5*ly-0.25
    }
  }
# grid size
  set arrow from first ox+0.5*(xf[1]+xf[2]), first oy+ly+0.25 to first ox+0.5*(xf[2]+xf[3]), first oy+ly+0.25 as 2
  set label '$DXC \left( i \right)$' center at first ox+xf[2], first oy+ly+0.5
  set arrow from first ox+xf[2], first oy-0.25 to first ox+xf[3], first oy-0.25 as 2
  set label '$DXF \left( i \right)$' center at first ox+0.5*(xf[2]+xf[3]), first oy-0.5
  set arrow from first ox+0.5*(xf[2]+xf[3]), first oy+ly+0.25 to first ox+0.5*(xf[3]+xf[4]), first oy+ly+0.25 as 2
  set label '$DXC \left( i + 1 \right)$' center at first ox+xf[3], first oy+ly+0.5
  plot \
    NaN notitle
}

reset
{
  lx = 7.
  ly = 6.
  #
  set terminal epslatex standalone color size 2*lx+6.,ly+2. font ',20'
  set output 'compute_potential5.tex'
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
  ox = -2.
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
  # potential positions
  do for [j=1:6:1] {
    do for [i=1:lx:1] {
      set object circle center first ox+(i-0.5), first oy+(j-0.5) size first 1./32. fs solid 1.0 fc rgb '#888888' lw 3
    }
  }
  # memory alignment
  set arrow from first ox+0.5, first oy-0.5 to first ox+0.5, first oy+ly   +0.5 as 3
  set arrow from first ox+1.5, first oy-0.5 to first ox+1.5, first oy+ly/3.+0.5 as 3
  ## right
  ox = lx+1.
  oy = 0.
  # process 0
  set object rectangle from first ox+0., first oy+0. to first ox+lx, first oy+2. fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 0' center at first ox+lx+1.0, first oy+1.0
  # process 1
  set object rectangle from first ox+0., first oy+2. to first ox+lx, first oy+4. fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 1' center at first ox+lx+1.0, first oy+3.0
  # process 2
  set object rectangle from first ox+0., first oy+4. to first ox+lx, first oy+6. fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 2' center at first ox+lx+1.0, first oy+5.0
  # horizontal
  do for [j=0:6.:1] {
    set arrow from first ox+0., first j to first ox+lx, j as 1
  }
  # vertical
  do for [i=0:lx:1] {
    set arrow from first ox+i, first 0. to first ox+i, 6. as 1
  }
  # potential positions
  do for [j=1:6:1] {
    do for [i=1:lx:1] {
      set object circle center first ox+(i-0.5), first oy+(j-0.5) size first 1./32. fs solid 1.0 fc rgb '#888888' lw 3
    }
  }
  # memory alignment
  set arrow from first ox-0.5, first oy+0.5 to first ox+lx+0.5, first oy+0.5 as 3
  set arrow from first ox-0.5, first oy+1.5 to first ox   +2.5, first oy+1.5 as 3
  ## arrow
  set arrow from first lx-1.5, first 0.5*ly to first lx+0.5, first 0.5*ly as 2
  plot \
    NaN notitle
}

reset
{
  lx = 7.
  ly = 6.
  #
  set terminal epslatex standalone color size 2*lx+6.,ly+2. font ',20'
  set output 'compute_potential6.tex'
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
  set object rectangle from first ox+0., first oy+0. to first ox+lx, first oy+2. fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 0' center at first ox-1.0, first oy+1.0
  # process 1
  set object rectangle from first ox+0., first oy+2. to first ox+lx, first oy+4. fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 1' center at first ox-1.0, first oy+3.0
  # process 2
  set object rectangle from first ox+0., first oy+4. to first ox+lx, first oy+6. fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 2' center at first ox-1.0, first oy+5.0
  # horizontal
  do for [j=0:6.:1] {
    set arrow from first ox+0., first j to first ox+lx, j as 1
  }
  # vertical
  do for [i=0:lx:1] {
    set arrow from first ox+i, first 0. to first ox+i, 6. as 1
  }
  # potential positions
  do for [j=1:6:1] {
    do for [i=1:lx:1] {
      set object circle center first ox+(i-0.5), first oy+(j-0.5) size first 1./32. fs solid 1.0 fc rgb '#888888' lw 3
    }
  }
  # memory alignment
  set arrow from first ox-0.5, first oy+0.5 to first ox+lx+0.5, first oy+0.5 as 3
  set arrow from first ox-0.5, first oy+1.5 to first ox   +2.5, first oy+1.5 as 3
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
  # potential positions
  do for [j=1:6:1] {
    do for [i=1:lx:1] {
      set object circle center first ox+(i-0.5), first oy+(j-0.5) size first 1./32. fs solid 1.0 fc rgb '#888888' lw 3
    }
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
  set terminal epslatex standalone color size 2*lx+6.,ly+2. font ',20'
  set output 'compute_potential7.tex'
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
  set object rectangle from first ox+0., first oy+0. to first ox+2., first oy+6. fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 0' center at first ox+1.0, first ly+1.0
  # process 1
  set object rectangle from first ox+2., first oy+0. to first ox+4., first oy+6. fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 1' center at first ox+3.0, first ly+1.0
  # process 2
  set object rectangle from first ox+4., first oy+0. to first ox+lx, first oy+6. fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 2' center at first ox+5.5, first ly+1.0
  # horizontal
  do for [j=0:6.:1] {
    set arrow from first ox+0., first j to first ox+lx, j as 1
  }
  # vertical
  do for [i=0:lx:1] {
    set arrow from first ox+i, first 0. to first ox+i, 6. as 1
  }
  # potential positions
  do for [j=1:6:1] {
    do for [i=1:lx:1] {
      set object circle center first ox+(i-0.5), first oy+(j-0.5) size first 1./32. fs solid 1.0 fc rgb '#888888' lw 3
    }
  }
  # memory alignment
  set arrow from first ox+0.5, first oy-0.5 to first ox+0.5, first oy+6.+0.5 as 3
  set arrow from first ox+1.5, first oy-0.5 to first ox+1.5, first oy+2.+0.5 as 3
  ## left
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
  # potential positions
  do for [j=1:ly:1] {
    do for [i=1:lx:1] {
      set object circle center first ox+(i-0.5), first oy+(j-0.5) size first 1./32. fs solid 1.0 fc rgb '#888888' lw 3
    }
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
  set terminal epslatex standalone color size 2*lx+6.,ly+2. font ',20'
  set output 'compute_potential8.tex'
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
  set xrange [-0.5:2*lx+5.5]
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
  # potential positions
  do for [j=1:ly:1] {
    do for [i=1:lx:1] {
      set object circle center first ox+(i-0.5), first oy+(j-0.5) size first 1./32. fs solid 1.0 fc rgb '#888888' lw 3
    }
  }
  # memory alignment
  set arrow from first ox+0.5, first oy-0.5 to first ox+0.5, first oy+ly   +0.5 as 3
  set arrow from first ox+1.5, first oy-0.5 to first ox+1.5, first oy+ly/3.+0.5 as 3
  ## right
  ox = lx+3.
  oy = 0.
  # process 0
  set object rectangle from first ox+0., first oy+0. to first ox+lx, first oy+3. fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 0' center at first 2.*lx+4., first 1.5
  # process 1
  set object rectangle from first ox+0., first oy+3. to first ox+lx, first oy+7. fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 1' center at first 2.*lx+4., first 5.0
  # process 2
  set object rectangle from first ox+0., first oy+7. to first ox+lx, first oy+ly fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 2' center at first 2.*lx+4., first 9.0
  # horizontal
  do for [j=0:ly:1] {
    set arrow from first ox+0., first j to first ox+lx, j as 1
  }
  # vertical
  do for [i=0:lx:1] {
    set arrow from first ox+i, first 0. to first ox+i, ly as 1
  }
  # potential positions
  do for [j=1:ly:1] {
    do for [i=1:lx:1] {
      set object circle center first ox+(i-0.5), first oy+(j-0.5) size first 1./32. fs solid 1.0 fc rgb '#888888' lw 3
    }
  }
  # memory alignment
  set arrow from first ox-0.5, first oy+0.5 to first ox+lx   +0.5, first oy+0.5 as 3
  set arrow from first ox-0.5, first oy+1.5 to first ox+lx/3.+0.5, first oy+1.5 as 3
  ## arrow
  set arrow from first lx+0.5, first 0.5*ly to first lx+2.5, first 0.5*ly as 2
  plot \
    NaN notitle
}

