reset
{
  set terminal epslatex standalone color size 10,3 font ',17'
  set output 'force.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:10]
  set yrange [0:3]
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
  array xf[3] = [0., 2., 4.5]
  array yf[2] = [0., 2.]
  array xc[2]
  do for[i=1:2:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  yc = 0.5*(yf[1]+yf[2])
## left
  set label 'Math' center at graph 0.25, graph 0.92
  ox = 0.25
  oy = 0.25
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
  }
  set arrow from first ox+xf[1], first oy+yf[1] to first ox+xf[3], first oy+yf[1] as 1
  set arrow from first ox+xf[1], first oy+yf[2] to first ox+xf[3], first oy+yf[2] as 1
# ux
  set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
  set label '$\left. u_x \right|_{i+\frac{1}{2},j}$' center at first ox+xf[2],oy+yc-0.25 front
# T
  set object circle center first ox+xc[1], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set object circle center first ox+xc[2], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set label '$\left. T \right|_{i  ,j}$' center at first ox+xc[1],oy+yc+0.25 front
  set label '$\left. T \right|_{i+1,j}$' center at first ox+xc[2],oy+yc+0.25 front
# ## right
  set label 'Code' center at graph 0.75, graph 0.92
  ox = 5.25
  oy = 0.25
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
  }
  set arrow from first ox+xf[1], first oy+yf[1] to first ox+xf[3], first oy+yf[1] as 1
  set arrow from first ox+xf[1], first oy+yf[2] to first ox+xf[3], first oy+yf[2] as 1
# ux
  set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
  set label '$UX \left( i, j \right)$' center at first ox+xf[2],oy+yc-0.25 front
# T
  set object circle center first ox+xc[1], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set object circle center first ox+xc[2], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set label '$T \left( i-1, j \right)$' center at first ox+xc[1],oy+yc+0.25 front
  set label '$T \left( i  , j \right)$' center at first ox+xc[2],oy+yc+0.25 front
  plot \
    NaN notitle
}

