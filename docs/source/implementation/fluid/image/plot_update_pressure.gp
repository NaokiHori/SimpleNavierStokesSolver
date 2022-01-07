reset
{
  set terminal epslatex standalone color size 11,7 font ',17'
  set output 'update_pressure1.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:11]
  set yrange [-1:6]
  set size ratio -1
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
  ox = 0.5
  oy = 0.5
  array xf[4] = [0.0, 1.0, 2.5 ,4.5]
  array yf[4] = [0.0, 1.5, 3.0, 4.5]
  array xc[3]
  array yc[3]
  do for [i=1:3:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  do for [j=1:3:1] {
    yc[j] = 0.5*(yf[j]+yf[j+1])
  }
# grid
  # horizontal
  do for [j=1:4:1] {
    set arrow from first ox+xf[1], oy+yf[j] to first ox+xf[4], oy+yf[j] as 1
  }
  # vertical
  do for [i=1:4:1] {
    set arrow from first ox+xf[i], oy+yf[1] to first ox+xf[i], oy+yf[4] as 1
  }
  # point
  do for [j=1:3:1] {
    do for [i=1:3:1] {
      lx = ox+xc[i]
      ly = oy+yc[j]
      set object circle center first lx, first ly size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
      if(i == 1){
        stringx = 'i-1'
      }else{
        if(i == 2){
          stringx = 'i  '
        }else{
          stringx = 'i+1'
        }
      }
      if(j == 1){
        stringy = 'j-1'
      }else{
        if(j == 2){
          stringy = 'j  '
        }else{
          stringy = 'j+1'
        }
      }
      string = sprintf('$\psi_{%s,%s}$', stringx, stringy)
      set label string center at first lx, first ly front
    }
  }
# grid size
  set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 4
  set label '$\Delta x_{i-\frac{1}{2}}$' center at first ox+0.5*(xc[1]+xc[2]), first oy-1.75*al
  set arrow from first ox+xc[2], first oy-1.*al to first ox+xc[3], first oy-1.*al as 4
  set label '$\Delta x_{i+\frac{1}{2}}$' center at first ox+0.5*(xc[2]+xc[3]), first oy-1.75*al
  set arrow from first ox+xf[2], first oy-3.5*al to first ox+xf[3], first oy-3.5*al as 4
  set label '$\Delta x_i$' center at first ox+0.5*(xf[2]+xf[3]), first oy-4.25*al
## right
  set label 'Code' center at graph 0.75, graph 0.92
  ox = 6.0
  oy = 0.5
  array xf[4] = [0.0, 1.0, 2.5 ,4.5]
  array yf[4] = [0.0, 1.5, 3.0, 4.5]
  array xc[3]
  array yc[3]
  do for [i=1:3:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  do for [j=1:3:1] {
    yc[j] = 0.5*(yf[j]+yf[j+1])
  }
# grid
  # horizontal
  do for [j=1:4:1] {
    set arrow from first ox+xf[1], oy+yf[j] to first ox+xf[4], oy+yf[j] as 1
  }
  # vertical
  do for [i=1:4:1] {
    set arrow from first ox+xf[i], oy+yf[1] to first ox+xf[i], oy+yf[4] as 1
  }
  # point
  do for [j=1:3:1] {
    do for [i=1:3:1] {
      lx = ox+xc[i]
      ly = oy+yc[j]
      set object circle center first lx, first ly size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
      if(i == 1){
        stringx = 'i-1'
      }else{
        if(i == 2){
          stringx = 'i  '
        }else{
          stringx = 'i+1'
        }
      }
      if(j == 1){
        stringy = 'j-1'
      }else{
        if(j == 2){
          stringy = 'j  '
        }else{
          stringy = 'j+1'
        }
      }
      string = sprintf('$\psi \left( %s, %s \right)$', stringx, stringy)
      set label string center at first lx, first ly front
    }
  }
# grid size
  set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 4
  set label '$DXC \left( i \right)$' center at first ox+0.5*(xc[1]+xc[2]), first oy-1.75*al
  set arrow from first ox+xc[2], first oy-1.*al to first ox+xc[3], first oy-1.*al as 4
  set label '$DXC \left( i+1 \right)$' center at first ox+0.5*(xc[2]+xc[3]), first oy-1.75*al
  set arrow from first ox+xf[2], first oy-3.5*al to first ox+xf[3], first oy-3.5*al as 4
  set label '$DXF \left( i \right)$' center at first ox+0.5*(xf[2]+xf[3]), first oy-4.25*al
  plot \
    NaN notitle
}

