reset
{
  set terminal epslatex standalone color size 10,3.5 font ',17'
  set output 'correct_velocity1.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:10]
  set yrange [0:3.5]
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
  oy = 0.75
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
  }
  set arrow from first ox+xf[1], first oy+yf[1] to first ox+xf[3], first oy+yf[1] as 1
  set arrow from first ox+xf[1], first oy+yf[2] to first ox+xf[3], first oy+yf[2] as 1
# grid size
  set arrow from first ox+xc[1], first oy-1.1*al to first ox+xc[2], first oy-1.1*al as 4
  set label '$\Delta x_{i+\frac{1}{2}}$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.2*al
# ux
  set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
  set label '$\left. u_x \right|_{i+\frac{1}{2},j}$' center at first ox+xf[2],oy+yc front
# psi
  set object circle center first ox+xc[1], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set label '$\left. \psi \right|_{i,j}$' center at first ox+xc[1],oy+yc front
  set object circle center first ox+xc[2], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set label '$\left. \psi \right|_{i+1,j}$' center at first ox+xc[2],oy+yc front
# ## right
  set label 'Code' center at graph 0.75, graph 0.92
  ox = 5.25
  oy = 0.75
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
  }
  set arrow from first ox+xf[1], first oy+yf[1] to first ox+xf[3], first oy+yf[1] as 1
  set arrow from first ox+xf[1], first oy+yf[2] to first ox+xf[3], first oy+yf[2] as 1
# grid size
  set arrow from first ox+xc[1], first oy-1.1*al to first ox+xc[2], first oy-1.1*al as 4
  set label '$DXC \left( i \right)$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.2*al
# ux
  set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
  set label '$UX \left( i, j \right)$' center at first ox+xf[2],oy+yc front
# psi
  set object circle center first ox+xc[1], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set label '$\psi \left( i-1, j \right)$' center at first ox+xc[1],oy+yc front
  set object circle center first ox+xc[2], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set label '$\psi \left( i  , j \right)$' center at first ox+xc[2],oy+yc front
  plot \
    NaN notitle
}

reset
{
  set terminal epslatex standalone color size 10,5 font ',17'
  set output 'correct_velocity2.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:10]
  set yrange [0:5]
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
  array xf[2] = [0., 2.]
  array yf[3] = [0., 2., 4.]
  xc = 0.5*(xf[1]+xf[2])
  array yc[2]
  do for[j=1:2:1] {
    yc[j] = 0.5*(yf[j]+yf[j+1])
  }
## left
  set label 'Math' center at graph 0.25, graph 0.92
  ox = 1.5
  oy = 0.25
# grid
  set arrow from first ox+xf[1], first oy+yf[1] to first ox+xf[1], first oy+yf[3] as 1
  set arrow from first ox+xf[2], first oy+yf[1] to first ox+xf[2], first oy+yf[3] as 1
  do for[j=1:3:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[2], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[1]-0.1, first oy+yc[1] to first ox+xf[1]-0.1, first oy+yc[2] as 4
  set label '$\Delta y$' right at first ox+xf[1]-0.2, first oy+yf[2]
# uy
  set arrow from first ox+xc, first oy+yf[2]-al to first ox+xc, first oy+yf[2]+al as 3
  set label '$\left. u_y \right|_{i,j+\frac{1}{2}}$' center at first ox+xc,oy+yf[2] front
# psi
  set object circle center first ox+xc, first oy+yc[1] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set label '$\left. \psi \right|_{i,j}$' center at first ox+xc,oy+yc[1] front
  set object circle center first ox+xc, first oy+yc[2] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set label '$\left. \psi \right|_{i,j+1}$' center at first ox+xc,oy+yc[2] front
## right
  set label 'Code' center at graph 0.75, graph 0.92
  ox = 6.5
  oy = 0.25
# grid
  set arrow from first ox+xf[1], first oy+yf[1] to first ox+xf[1], first oy+yf[3] as 1
  set arrow from first ox+xf[2], first oy+yf[1] to first ox+xf[2], first oy+yf[3] as 1
  do for[j=1:3:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[2], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[1]-0.1, first oy+yc[1] to first ox+xf[1]-0.1, first oy+yc[2] as 4
  set label '$dy$' right at first ox+xf[1]-0.2, first oy+yf[2]
# uy
  set arrow from first ox+xc, first oy+yf[2]-al to first ox+xc, first oy+yf[2]+al as 3
  set label '$UY \left( i, j \right)$' center at first ox+xc,oy+yf[2] front
# psi
  set object circle center first ox+xc, first oy+yc[1] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set label '$\psi \left( i,j-1 \right)$' center at first ox+xc,oy+yc[1] front
  set object circle center first ox+xc, first oy+yc[2] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set label '$\psi \left( i,j   \right)$' center at first ox+xc,oy+yc[2] front
  plot \
    NaN notitle
}

