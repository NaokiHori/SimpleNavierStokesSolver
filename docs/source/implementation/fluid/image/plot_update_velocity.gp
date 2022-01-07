
### compute_src_ux

reset
{
  set terminal epslatex standalone color size 12,4 font ',17'
  set output 'update_velocity1.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:12]
  set yrange [-0.5:3.5]
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
  ox = 0.75
  oy = 0.75
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
  }
  set arrow from first ox+xf[1], first oy+yf[1] to first ox+xf[3], first oy+yf[1] as 1
  set arrow from first ox+xf[1], first oy+yf[2] to first ox+xf[3], first oy+yf[2] as 1
# grid size
  set arrow from first ox+xf[1], first oy-1.*al to first ox+xf[2], first oy-1.*al as 4
  set label '$\Delta x_i$' center at first ox+xc[1], first oy-2.*al
  set arrow from first ox+xf[2], first oy-1.*al to first ox+xf[3], first oy-1.*al as 4
  set label '$\Delta x_{i+1}$' center at first ox+xc[2], first oy-2.*al
  set arrow from first ox+xc[1], first oy-3.*al to first ox+xc[2], first oy-3.*al as 4
  set label '$\Delta x_{i+\frac{1}{2}}$' center at first ox+0.5*(xc[1]+xc[2]), first oy-4.*al
# ux
  set arrow from first ox+xf[1]-al, first oy+yc to first ox+xf[1]+al, first oy+yc as 2
  set label '$\left. u_x \right|_{i-\frac{1}{2},j}$' center at first ox+xf[1],oy+yc front
  set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
  set label '$\left. u_x \right|_{i+\frac{1}{2},j}$' center at first ox+xf[2],oy+yc front
  set arrow from first ox+xf[3]-al, first oy+yc to first ox+xf[3]+al, first oy+yc as 2
  set label '$\left. u_x \right|_{i+\frac{3}{2},j}$' center at first ox+xf[3],oy+yc front
# cell center
  set object circle center first ox+xc[1], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set object circle center first ox+xc[2], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
## right
  set label 'Code' center at graph 0.75, graph 0.92
  ox = 6.75
  oy = 0.75
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
  }
  set arrow from first ox+xf[1], first oy+yf[1] to first ox+xf[3], first oy+yf[1] as 1
  set arrow from first ox+xf[1], first oy+yf[2] to first ox+xf[3], first oy+yf[2] as 1
# grid size
  set arrow from first ox+xf[1], first oy-1.*al to first ox+xf[2], first oy-1.*al as 4
  set label '$DXF \left( i-1 \right)$' center at first ox+xc[1], first oy-2.*al
  set arrow from first ox+xf[2], first oy-1.*al to first ox+xf[3], first oy-1.*al as 4
  set label '$DXF \left( i   \right)$' center at first ox+xc[2], first oy-2.*al
  set arrow from first ox+xc[1], first oy-3.*al to first ox+xc[2], first oy-3.*al as 4
  set label '$DXC \left( i   \right)$' center at first ox+0.5*(xc[1]+xc[2]), first oy-4.*al
# ux
  set arrow from first ox+xf[1]-al, first oy+yc to first ox+xf[1]+al, first oy+yc as 2
  set label '$UX \left( i-1, j \right)$' center at first ox+xf[1],oy+yc front
  set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
  set label '$UX \left( i  , j \right)$' center at first ox+xf[2],oy+yc front
  set arrow from first ox+xf[3]-al, first oy+yc to first ox+xf[3]+al, first oy+yc as 2
  set label '$UX \left( i+1, j \right)$' center at first ox+xf[3],oy+yc front
# cell center
  set object circle center first ox+xc[1], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set object circle center first ox+xc[2], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  plot \
    NaN notitle
}

reset
{
  set terminal epslatex standalone color size 12,8 font ',17'
  set output 'update_velocity2.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:12]
  set yrange [-0.5:7.5]
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
  array yf[4] = [0., 2., 4., 6.]
  array xc[2]
  array yc[3]
  do for[i=1:2:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  do for[j=1:3:1] {
    yc[j] = 0.5*(yf[j]+yf[j+1])
  }
## left
  set label 'Math' center at graph 0.25, graph 0.94
  ox = 0.75
  oy = 0.75
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[4] as 1
  }
  do for[j=1:4:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[3], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[1], first oy-1.*al to first ox+xf[2], first oy-1.*al as 4
  set label '$\Delta x_i$' center at first ox+xc[1], first oy-2.*al
  set arrow from first ox+xf[2], first oy-1.*al to first ox+xf[3], first oy-1.*al as 4
  set label '$\Delta x_{i+1}$' center at first ox+xc[2], first oy-2.*al
  set arrow from first ox+xc[1], first oy-3.*al to first ox+xc[2], first oy-3.*al as 4
  set label '$\Delta x_{i+\frac{1}{2}}$' center at first ox+0.5*(xc[1]+xc[2]), first oy-4.*al
  set arrow from first ox+xf[3]+0.5*al, first oy+yf[2] to first ox+xf[3]+0.5*al, first oy+yf[3] as 4
  set label '$\Delta y$' left at first ox+xf[3]+1.*al, first oy+yc[2] front
# ux
  set arrow from first ox+xf[2]-al, first oy+yc[1] to first ox+xf[2]+al, first oy+yc[1] as 2
  set label '$\left. u_x \right|_{i+\frac{1}{2},j-1}$' center at first ox+xf[2],oy+yc[1] front
  set arrow from first ox+xf[2]-al, first oy+yc[2] to first ox+xf[2]+al, first oy+yc[2] as 2
  set label '$\left. u_x \right|_{i+\frac{1}{2},j  }$' center at first ox+xf[2],oy+yc[2] front
  set arrow from first ox+xf[2]-al, first oy+yc[3] to first ox+xf[2]+al, first oy+yc[3] as 2
  set label '$\left. u_x \right|_{i+\frac{1}{2},j+1}$' center at first ox+xf[2],oy+yc[3] front
# uy
  set arrow from first ox+xc[1], first oy+yf[2]-al to first ox+xc[1], first oy+yf[2]+al as 3
  set label '$\left. u_y \right|_{i  ,j-\frac{1}{2}}$' center at first ox+xc[1], first oy+yf[2] front
  set arrow from first ox+xc[2], first oy+yf[2]-al to first ox+xc[2], first oy+yf[2]+al as 3
  set label '$\left. u_y \right|_{i+1,j-\frac{1}{2}}$' center at first ox+xc[2], first oy+yf[2] front
  set arrow from first ox+xc[1], first oy+yf[3]-al to first ox+xc[1], first oy+yf[3]+al as 3
  set label '$\left. u_y \right|_{i  ,j+\frac{1}{2}}$' center at first ox+xc[1], first oy+yf[3] front
  set arrow from first ox+xc[2], first oy+yf[3]-al to first ox+xc[2], first oy+yf[3]+al as 3
  set label '$\left. u_y \right|_{i+1,j+\frac{1}{2}}$' center at first ox+xc[2], first oy+yf[3] front
# cell center
  do for [j=1:3:1] {
    set object circle center first ox+xc[1], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    set object circle center first ox+xc[2], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  }
## right
  set label 'Code' center at graph 0.75, graph 0.94
  ox = 6.75
  oy = 0.75
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[4] as 1
  }
  do for[j=1:4:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[3], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[1], first oy-1.*al to first ox+xf[2], first oy-1.*al as 4
  set label '$DXF \left( i-1 \right)$' center at first ox+xc[1], first oy-2.*al
  set arrow from first ox+xf[2], first oy-1.*al to first ox+xf[3], first oy-1.*al as 4
  set label '$DXF \left( i   \right)$' center at first ox+xc[2], first oy-2.*al
  set arrow from first ox+xc[1], first oy-3.*al to first ox+xc[2], first oy-3.*al as 4
  set label '$DXC \left( i   \right)$' center at first ox+0.5*(xc[1]+xc[2]), first oy-4.*al
  set arrow from first ox+xf[3]+0.5*al, first oy+yf[2] to first ox+xf[3]+0.5*al, first oy+yf[3] as 4
  set label '$dy$' left at first ox+xf[3]+1.*al, first oy+yc[2] front
# ux
  set arrow from first ox+xf[2]-al, first oy+yc[1] to first ox+xf[2]+al, first oy+yc[1] as 2
  set arrow from first ox+xf[2]-al, first oy+yc[2] to first ox+xf[2]+al, first oy+yc[2] as 2
  set arrow from first ox+xf[2]-al, first oy+yc[3] to first ox+xf[2]+al, first oy+yc[3] as 2
  set label '$UX \left( i, j-1 \right)$' center at first ox+xf[2],oy+yc[1] front
  set label '$UX \left( i, j   \right)$' center at first ox+xf[2],oy+yc[2] front
  set label '$UX \left( i, j+1 \right)$' center at first ox+xf[2],oy+yc[3] front
# uy
  set arrow from first ox+xc[1], first oy+yf[2]-al to first ox+xc[1], first oy+yf[2]+al as 3
  set arrow from first ox+xc[2], first oy+yf[2]-al to first ox+xc[2], first oy+yf[2]+al as 3
  set arrow from first ox+xc[1], first oy+yf[3]-al to first ox+xc[1], first oy+yf[3]+al as 3
  set arrow from first ox+xc[2], first oy+yf[3]-al to first ox+xc[2], first oy+yf[3]+al as 3
  set label '$UY \left( i-1, j   \right)$' center at first ox+xc[1], first oy+yf[2] front
  set label '$UY \left( i  , j   \right)$' center at first ox+xc[2], first oy+yf[2] front
  set label '$UY \left( i-1, j+1 \right)$' center at first ox+xc[1], first oy+yf[3] front
  set label '$UY \left( i  , j+1 \right)$' center at first ox+xc[2], first oy+yf[3] front
# cell center
  do for [j=1:3:1] {
    set object circle center first ox+xc[1], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    set object circle center first ox+xc[2], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  }
  plot \
    NaN notitle
}

reset
{
  set terminal epslatex standalone color size 12,7.5 font ',17'
  set output 'update_velocity3.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:12]
  set yrange [0.:7.5]
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
  array yf[4] = [0., 2., 4., 6.]
  array xc[2]
  array yc[3]
  do for[i=1:2:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  do for[j=1:3:1] {
    yc[j] = 0.5*(yf[j]+yf[j+1])
  }
## left
  set label 'Math' center at graph 0.25, graph 0.94
  ox = 0.75
  oy = 0.75
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[4] as 1
  }
  do for[j=1:4:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[3], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[3]+0.5*al, first oy+yf[2] to first ox+xf[3]+0.5*al, first oy+yf[3] as 4
  set label '$\Delta y$' left at first ox+xf[3]+1.*al, first oy+yc[2] front
# ux
  set arrow from first ox+xf[2]-al, first oy+yc[1] to first ox+xf[2]+al, first oy+yc[1] as 2
  set label '$\left. u_x \right|_{i+\frac{1}{2},j-1}$' center at first ox+xf[2],oy+yc[1] front
  set arrow from first ox+xf[2]-al, first oy+yc[2] to first ox+xf[2]+al, first oy+yc[2] as 2
  set label '$\left. u_x \right|_{i+\frac{1}{2},j  }$' center at first ox+xf[2],oy+yc[2] front
  set arrow from first ox+xf[2]-al, first oy+yc[3] to first ox+xf[2]+al, first oy+yc[3] as 2
  set label '$\left. u_x \right|_{i+\frac{1}{2},j+1}$' center at first ox+xf[2],oy+yc[3] front
# cell center
  do for [j=1:3:1] {
    set object circle center first ox+xc[1], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    set object circle center first ox+xc[2], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  }
## right
  set label 'Code' center at graph 0.75, graph 0.94
  ox = 6.75
  oy = 0.75
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[4] as 1
  }
  do for[j=1:4:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[3], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[3]+0.5*al, first oy+yf[2] to first ox+xf[3]+0.5*al, first oy+yf[3] as 4
  set label '$dy$' left at first ox+xf[3]+1.*al, first oy+yc[2] front
# ux
  set arrow from first ox+xf[2]-al, first oy+yc[1] to first ox+xf[2]+al, first oy+yc[1] as 2
  set arrow from first ox+xf[2]-al, first oy+yc[2] to first ox+xf[2]+al, first oy+yc[2] as 2
  set arrow from first ox+xf[2]-al, first oy+yc[3] to first ox+xf[2]+al, first oy+yc[3] as 2
  set label '$UX \left( i, j-1 \right)$' center at first ox+xf[2],oy+yc[1] front
  set label '$UX \left( i, j   \right)$' center at first ox+xf[2],oy+yc[2] front
  set label '$UX \left( i, j+1 \right)$' center at first ox+xf[2],oy+yc[3] front
# cell center
  do for [j=1:3:1] {
    set object circle center first ox+xc[1], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    set object circle center first ox+xc[2], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  }
  plot \
    NaN notitle
}

reset
{
  set terminal epslatex standalone color size 12,3.5 font ',17'
  set output 'update_velocity4.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:12]
  set yrange [0.:3.5]
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
  ox = 0.75
  oy = 0.75
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
  }
  set arrow from first ox+xf[1], first oy+yf[1] to first ox+xf[3], first oy+yf[1] as 1
  set arrow from first ox+xf[1], first oy+yf[2] to first ox+xf[3], first oy+yf[2] as 1
# grid size
  set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 4
  set label '$\Delta x_{i+\frac{1}{2}}$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al
# ux
  set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
  set label '$\left. u_x \right|_{i+\frac{1}{2},j}$' center at first ox+xf[2],oy+yc front
# pressure
  set object circle center first ox+xc[1], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set object circle center first ox+xc[2], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set label '$\left. p \right|_{i  ,j}$' center at first ox+xc[1], first oy+yc front
  set label '$\left. p \right|_{i+1,j}$' center at first ox+xc[2], first oy+yc front
## right
  set label 'Code' center at graph 0.75, graph 0.92
  ox = 6.75
  oy = 0.75
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
  }
  set arrow from first ox+xf[1], first oy+yf[1] to first ox+xf[3], first oy+yf[1] as 1
  set arrow from first ox+xf[1], first oy+yf[2] to first ox+xf[3], first oy+yf[2] as 1
# grid size
  set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 4
  set label '$DXC \left( i   \right)$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al
# ux
  set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
  set label '$UX \left( i  , j \right)$' center at first ox+xf[2],oy+yc front
# pressure
  set object circle center first ox+xc[1], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set object circle center first ox+xc[2], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set label '$P \left( i-1, j \right)$' center at first ox+xc[1], first oy+yc front
  set label '$P \left( i  , j \right)$' center at first ox+xc[2], first oy+yc front
  plot \
    NaN notitle
}

### compute_src_uy

reset
{
  set terminal epslatex standalone color size 15,5.5 font ',17'
  set output 'update_velocity5.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:15]
  set yrange [0.:5.5]
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
  array xf[4] = [0., 1.5, 3.5, 6.0]
  array yf[3] = [0., 2., 4.]
  array xc[3]
  array yc[2]
  do for[i=1:3:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  do for[j=1:2:1] {
    yc[j] = 0.5*(yf[j]+yf[j+1])
  }
## left
  set label 'Math' center at graph 0.25, graph 0.92
  ox = 0.75
  oy = 0.75
# grid
  do for [i=1:4:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[3] as 1
  }
  do for [j=1:3:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[4], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[2], first oy-1.*al to first ox+xf[3], first oy-1.*al as 4
  set label '$\Delta x_{i  }$' center at first ox+xc[2], first oy-2.*al front
  set arrow from first ox+xf[4]+0.5*al, first oy+yc[1] to ox+xf[4]+0.5*al, first oy+yc[2] as 4
  set label '$\Delta y$' left at first ox+xf[4]+1.*al, oy+yf[2] front
# ux
  set arrow from first ox+xf[2]-al, first oy+yc[1] to first ox+xf[2]+al, first oy+yc[1] as 2
  set arrow from first ox+xf[3]-al, first oy+yc[1] to first ox+xf[3]+al, first oy+yc[1] as 2
  set arrow from first ox+xf[2]-al, first oy+yc[2] to first ox+xf[2]+al, first oy+yc[2] as 2
  set arrow from first ox+xf[3]-al, first oy+yc[2] to first ox+xf[3]+al, first oy+yc[2] as 2
  set label '$\left. u_x \right|_{i-\frac{1}{2},j  }$' center at first ox+xf[2],oy+yc[1] front
  set label '$\left. u_x \right|_{i+\frac{1}{2},j  }$' center at first ox+xf[3],oy+yc[1] front
  set label '$\left. u_x \right|_{i-\frac{1}{2},j+1}$' center at first ox+xf[2],oy+yc[2] front
  set label '$\left. u_x \right|_{i+\frac{1}{2},j+1}$' center at first ox+xf[3],oy+yc[2] front
# uy
  set arrow from first ox+xc[1], first oy+yf[2]-al to first ox+xc[1], first oy+yf[2]+al as 3
  set arrow from first ox+xc[2], first oy+yf[2]-al to first ox+xc[2], first oy+yf[2]+al as 3
  set arrow from first ox+xc[3], first oy+yf[2]-al to first ox+xc[3], first oy+yf[2]+al as 3
  set label '$\left. u_y \right|_{i-1,j+\frac{1}{2}}$' center at first ox+xc[1],oy+yf[2] front
  set label '$\left. u_y \right|_{i  ,j+\frac{1}{2}}$' center at first ox+xc[2],oy+yf[2] front
  set label '$\left. u_y \right|_{i+1,j+\frac{1}{2}}$' center at first ox+xc[3],oy+yf[2] front
# cell center
  do for [j=1:2:1] {
    do for [i=1:3:1] {
      set object circle center first ox+xc[i], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
  }
## right
  set label 'Code' center at graph 0.75, graph 0.92
  ox = 8.25
  oy = 0.75
# grid
  do for [i=1:4:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[3] as 1
  }
  do for [j=1:3:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[4], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[2], first oy-1.*al to first ox+xf[3], first oy-1.*al as 4
  set label '$DXF \left( i \right)$' center at first ox+xc[2], first oy-2.*al front
  set arrow from first ox+xf[4]+0.5*al, first oy+yc[1] to ox+xf[4]+0.5*al, first oy+yc[2] as 4
  set label '$dy$' left at first ox+xf[4]+1.*al, oy+yf[2] front
# ux
  set arrow from first ox+xf[2]-al, first oy+yc[1] to first ox+xf[2]+al, first oy+yc[1] as 2
  set arrow from first ox+xf[3]-al, first oy+yc[1] to first ox+xf[3]+al, first oy+yc[1] as 2
  set arrow from first ox+xf[2]-al, first oy+yc[2] to first ox+xf[2]+al, first oy+yc[2] as 2
  set arrow from first ox+xf[3]-al, first oy+yc[2] to first ox+xf[3]+al, first oy+yc[2] as 2
  set label '$UX \left( i  , j-1 \right)$' center at first ox+xf[2],oy+yc[1] front
  set label '$UX \left( i+1, j-1 \right)$' center at first ox+xf[3],oy+yc[1] front
  set label '$UX \left( i  , j   \right)$' center at first ox+xf[2],oy+yc[2] front
  set label '$UX \left( i+1, j   \right)$' center at first ox+xf[3],oy+yc[2] front
# uy
  set arrow from first ox+xc[1], first oy+yf[2]-al to first ox+xc[1], first oy+yf[2]+al as 3
  set arrow from first ox+xc[2], first oy+yf[2]-al to first ox+xc[2], first oy+yf[2]+al as 3
  set arrow from first ox+xc[3], first oy+yf[2]-al to first ox+xc[3], first oy+yf[2]+al as 3
  set label '$UY \left( i-1, j \right)$' center at first ox+xc[1],oy+yf[2] front
  set label '$UY \left( i  , j \right)$' center at first ox+xc[2],oy+yf[2] front
  set label '$UY \left( i+1, j \right)$' center at first ox+xc[3],oy+yf[2] front
# cell center
  do for [j=1:2:1] {
    do for [i=1:3:1] {
      set object circle center first ox+xc[i], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
  }
  plot \
    NaN notitle
}

reset
{
  set terminal epslatex standalone color size 7,6 font ',17'
  set output 'update_velocity6.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:7]
  set yrange [0:6]
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
  array yc[2]
  xc = 0.5*(xf[1]+xf[2])
  do for[j=1:2:1] {
    yc[j] = 0.5*(yf[j]+yf[j+1])
  }
## left
  set label 'Math' center at graph 0.25, graph 0.92
  ox = 0.75
  oy = 0.75
# grid
  do for [i=1:2:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[3] as 1
  }
  do for [j=1:3:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[2], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[2]+0.5*al, first oy+yc[1] to ox+xf[2]+0.5*al, first oy+yc[2] as 4
  set label '$\Delta y$' left at first ox+xf[2]+1.*al, oy+yf[2] front
# uy
  set arrow from first ox+xc, first oy+yf[1]-al to first ox+xc, first oy+yf[1]+al as 3
  set arrow from first ox+xc, first oy+yf[2]-al to first ox+xc, first oy+yf[2]+al as 3
  set arrow from first ox+xc, first oy+yf[3]-al to first ox+xc, first oy+yf[3]+al as 3
  set label '$\left. u_y \right|_{i,j-\frac{1}{2}}$' center at first ox+xc,oy+yf[1] front
  set label '$\left. u_y \right|_{i,j+\frac{1}{2}}$' center at first ox+xc,oy+yf[2] front
  set label '$\left. u_y \right|_{i,j+\frac{3}{2}}$' center at first ox+xc,oy+yf[3] front
# cell center
  do for [j=1:2:1] {
    set object circle center first ox+xc, first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  }
## right
  set label 'Code' center at graph 0.75, graph 0.92
  ox = 4.25
  oy = 0.75
# grid
  do for [i=1:2:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[3] as 1
  }
  do for [j=1:3:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[2], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[2]+0.5*al, first oy+yc[1] to ox+xf[2]+0.5*al, first oy+yc[2] as 4
  set label '$dy$' left at first ox+xf[2]+1.*al, oy+yf[2] front
# uy
  set arrow from first ox+xc, first oy+yf[1]-al to first ox+xc, first oy+yf[1]+al as 3
  set arrow from first ox+xc, first oy+yf[2]-al to first ox+xc, first oy+yf[2]+al as 3
  set arrow from first ox+xc, first oy+yf[3]-al to first ox+xc, first oy+yf[3]+al as 3
  set label '$UY \left( i, j-1 \right)$' center at first ox+xc,oy+yf[1] front
  set label '$UY \left( i, j   \right)$' center at first ox+xc,oy+yf[2] front
  set label '$UY \left( i, j+1 \right)$' center at first ox+xc,oy+yf[3] front
# cell center
  do for [j=1:2:1] {
    set object circle center first ox+xc, first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  }
  plot \
    NaN notitle
}

reset
{
  set terminal epslatex standalone color size 15,6 font ',17'
  set output 'update_velocity7.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:15]
  set yrange [-0.5:5.5]
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
  array xf[4] = [0., 1.5, 3.5, 6.0]
  array yf[3] = [0., 2., 4.]
  array xc[3]
  array yc[2]
  do for[i=1:3:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  do for[j=1:2:1] {
    yc[j] = 0.5*(yf[j]+yf[j+1])
  }
## left
  set label 'Math' center at graph 0.25, graph 0.92
  ox = 0.75
  oy = 0.75
# grid
  do for [i=1:4:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[3] as 1
  }
  do for [j=1:3:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[4], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 4
  set arrow from first ox+xc[2], first oy-1.*al to first ox+xc[3], first oy-1.*al as 4
  set arrow from first ox+xf[2], first oy-3.*al to first ox+xf[3], first oy-3.*al as 4
  set label '$\Delta x_{i-\frac{1}{2}}$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al front
  set label '$\Delta x_{i+\frac{1}{2}}$' center at first ox+0.5*(xc[2]+xc[3]), first oy-2.*al front
  set label '$\Delta x_{i  }$'           center at first ox+xc[2], first oy-4.*al front
# uy
  set arrow from first ox+xc[1], first oy+yf[2]-al to first ox+xc[1], first oy+yf[2]+al as 3
  set arrow from first ox+xc[2], first oy+yf[2]-al to first ox+xc[2], first oy+yf[2]+al as 3
  set arrow from first ox+xc[3], first oy+yf[2]-al to first ox+xc[3], first oy+yf[2]+al as 3
  set label '$\left. u_y \right|_{i-1,j+\frac{1}{2}}$' center at first ox+xc[1],oy+yf[2] front
  set label '$\left. u_y \right|_{i  ,j+\frac{1}{2}}$' center at first ox+xc[2],oy+yf[2] front
  set label '$\left. u_y \right|_{i+1,j+\frac{1}{2}}$' center at first ox+xc[3],oy+yf[2] front
# cell center
  do for [j=1:2:1] {
    do for [i=1:3:1] {
      set object circle center first ox+xc[i], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
  }
## right
  set label 'Code' center at graph 0.75, graph 0.92
  ox = 8.25
  oy = 0.75
# grid
  do for [i=1:4:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[3] as 1
  }
  do for [j=1:3:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[4], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 4
  set arrow from first ox+xc[2], first oy-1.*al to first ox+xc[3], first oy-1.*al as 4
  set arrow from first ox+xf[2], first oy-3.*al to first ox+xf[3], first oy-3.*al as 4
  set label '$DXC \left( i   \right)$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al front
  set label '$DXC \left( i+1 \right)$' center at first ox+0.5*(xc[2]+xc[3]), first oy-2.*al front
  set label '$DXF \left( i \right)$'           center at first ox+xc[2], first oy-4.*al front
# uy
  set arrow from first ox+xc[1], first oy+yf[2]-al to first ox+xc[1], first oy+yf[2]+al as 3
  set arrow from first ox+xc[2], first oy+yf[2]-al to first ox+xc[2], first oy+yf[2]+al as 3
  set arrow from first ox+xc[3], first oy+yf[2]-al to first ox+xc[3], first oy+yf[2]+al as 3
  set label '$UY \left( i-1, j \right)$' center at first ox+xc[1],oy+yf[2] front
  set label '$UY \left( i  , j \right)$' center at first ox+xc[2],oy+yf[2] front
  set label '$UY \left( i+1, j \right)$' center at first ox+xc[3],oy+yf[2] front
# cell center
  do for [j=1:2:1] {
    do for [i=1:3:1] {
      set object circle center first ox+xc[i], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
  }
  plot \
    NaN notitle
}

reset
{
  set terminal epslatex standalone color size 7,6 font ',17'
  set output 'update_velocity8.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:7]
  set yrange [0:6]
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
  array yc[2]
  xc = 0.5*(xf[1]+xf[2])
  do for[j=1:2:1] {
    yc[j] = 0.5*(yf[j]+yf[j+1])
  }
## left
  set label 'Math' center at graph 0.25, graph 0.92
  ox = 0.75
  oy = 0.75
# grid
  do for [i=1:2:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[3] as 1
  }
  do for [j=1:3:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[2], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[2]+0.5*al, first oy+yc[1] to ox+xf[2]+0.5*al, first oy+yc[2] as 4
  set label '$\Delta y$' left at first ox+xf[2]+1.*al, oy+yf[2] front
# uy
  set arrow from first ox+xc, first oy+yf[2]-al to first ox+xc, first oy+yf[2]+al as 3
  set label '$\left. u_y \right|_{i,j+\frac{1}{2}}$' center at first ox+xc,oy+yf[2] front
# p
  set label '$\left. p \right|_{i,j  }$' center at first ox+xc, first oy+yc[1] front
  set label '$\left. p \right|_{i,j+1}$' center at first ox+xc, first oy+yc[2] front
# cell center
  do for [j=1:2:1] {
    set object circle center first ox+xc, first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  }
## right
  set label 'Code' center at graph 0.75, graph 0.92
  ox = 4.25
  oy = 0.75
# grid
  do for [i=1:2:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[3] as 1
  }
  do for [j=1:3:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[2], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[2]+0.5*al, first oy+yc[1] to ox+xf[2]+0.5*al, first oy+yc[2] as 4
  set label '$dy$' left at first ox+xf[2]+1.*al, oy+yf[2] front
# uy
  set arrow from first ox+xc, first oy+yf[2]-al to first ox+xc, first oy+yf[2]+al as 3
  set label '$UY \left( i, j   \right)$' center at first ox+xc,oy+yf[2] front
# p
  set label '$P \left( i,j-1 \right)$' center at first ox+xc, first oy+yc[1] front
  set label '$P \left( i,j   \right)$' center at first ox+xc, first oy+yc[2] front
# cell center
  do for [j=1:2:1] {
    set object circle center first ox+xc, first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  }
  plot \
    NaN notitle
}

### update_ux

reset
{
  set terminal epslatex standalone color size 12,4 font ',17'
  set output 'update_velocity9.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:12]
  set yrange [-0.5:3.5]
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
  ox = 0.75
  oy = 0.75
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
  }
  set arrow from first ox+xf[1], first oy+yf[1] to first ox+xf[3], first oy+yf[1] as 1
  set arrow from first ox+xf[1], first oy+yf[2] to first ox+xf[3], first oy+yf[2] as 1
# grid size
  set arrow from first ox+xf[1], first oy-1.*al to first ox+xf[2], first oy-1.*al as 4
  set label '$\Delta x_i$' center at first ox+xc[1], first oy-2.*al
  set arrow from first ox+xf[2], first oy-1.*al to first ox+xf[3], first oy-1.*al as 4
  set label '$\Delta x_{i+1}$' center at first ox+xc[2], first oy-2.*al
  set arrow from first ox+xc[1], first oy-3.*al to first ox+xc[2], first oy-3.*al as 4
  set label '$\Delta x_{i+\frac{1}{2}}$' center at first ox+0.5*(xc[1]+xc[2]), first oy-4.*al
# ux
  set arrow from first ox+xf[1]-al, first oy+yc to first ox+xf[1]+al, first oy+yc as 2
  set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
  set arrow from first ox+xf[3]-al, first oy+yc to first ox+xf[3]+al, first oy+yc as 2
  set label '$\left. \delta u_x \right|_{i-\frac{1}{2},j}$' center at first ox+xf[1],oy+yc front
  set label '$\left. \delta u_x \right|_{i+\frac{1}{2},j}$' center at first ox+xf[2],oy+yc front
  set label '$\left. \delta u_x \right|_{i+\frac{3}{2},j}$' center at first ox+xf[3],oy+yc front
# cell center
  set object circle center first ox+xc[1], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set object circle center first ox+xc[2], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
## right
  set label 'Code' center at graph 0.75, graph 0.92
  ox = 6.75
  oy = 0.75
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
  }
  set arrow from first ox+xf[1], first oy+yf[1] to first ox+xf[3], first oy+yf[1] as 1
  set arrow from first ox+xf[1], first oy+yf[2] to first ox+xf[3], first oy+yf[2] as 1
# grid size
  set arrow from first ox+xf[1], first oy-1.*al to first ox+xf[2], first oy-1.*al as 4
  set arrow from first ox+xf[2], first oy-1.*al to first ox+xf[3], first oy-1.*al as 4
  set arrow from first ox+xc[1], first oy-3.*al to first ox+xc[2], first oy-3.*al as 4
  set label '$DXF \left( i-1 \right)$' center at first ox+xc[1], first oy-2.*al
  set label '$DXF \left( i   \right)$' center at first ox+xc[2], first oy-2.*al
  set label '$DXC \left( i   \right)$' center at first ox+0.5*(xc[1]+xc[2]), first oy-4.*al
# ux
  set arrow from first ox+xf[1]-al, first oy+yc to first ox+xf[1]+al, first oy+yc as 2
  set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
  set arrow from first ox+xf[3]-al, first oy+yc to first ox+xf[3]+al, first oy+yc as 2
  set label '$QX \left( i-1, j \right)$' center at first ox+xf[1],oy+yc front
  set label '$QX \left( i  , j \right)$' center at first ox+xf[2],oy+yc front
  set label '$QX \left( i+1, j \right)$' center at first ox+xf[3],oy+yc front
# cell center
  set object circle center first ox+xc[1], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  set object circle center first ox+xc[2], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  plot \
    NaN notitle
}

reset
{
  lx = 7.
  ly = 11.
  #
  set terminal epslatex standalone color size 2*lx+6.,ly+2. font ',20'
  set output 'update_velocity10.tex'
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
  set style line 4 lc rgb '#000000' lw 10
  #
  set style arrow 1 nohead front ls 1
  set style arrow 2 head size graph 0.02,20. filled front ls 2
  set style arrow 3 head size graph 0.02,20. filled front ls 3
  set style arrow 4 head size 0.2,10 filled front ls 4
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
  # ux
  do for [j=1:11:1] {
    do for [i=1:8:1] {
      set arrow from first ox+(i-1)-1.*al, first oy+j-0.5 to first ox+(i-1)+1.*al, first oy+j-0.5 as 4
    }
  }
  ## right
  ox = lx+3.
  oy = 0.
  # process 0
  set object rectangle from first ox+0., first oy+0. to first ox+1.5, first oy+ly fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 0' center at first ox+0.75, first ly+1.0
  # process 1
  set object rectangle from first ox+1.5, first oy+0. to first ox+4.5, first oy+ly fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 1' center at first ox+3.0, first ly+1.0
  # process 2
  set object rectangle from first ox+4.5, first oy+0. to first ox+lx, first oy+ly fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 2' center at first ox+5.75, first ly+1.0
  # horizontal
  do for [j=0:ly:1] {
    set arrow from first ox+0., first j to first ox+lx, j as 1
  }
  # vertical
  do for [i=0:lx:1] {
    set arrow from first ox+i, first 0. to first ox+i, ly as 1
  }
  # ux
  do for [j=1:11:1] {
    do for [i=1:8:1] {
      set arrow from first ox+(i-1)-1.*al, first oy+j-0.5 to first ox+(i-1)+1.*al, first oy+j-0.5 as 4
    }
  }
  ## arrow
  set arrow from first lx+0.5, first 0.5*ly to first lx+2.5, first 0.5*ly as 2
  plot \
    NaN notitle
}

reset
{
  set terminal epslatex standalone color size 12,7.5 font ',17'
  set output 'update_velocity11.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:12]
  set yrange [0.:7.5]
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
  array yf[4] = [0., 2., 4., 6.]
  array xc[2]
  array yc[3]
  do for[i=1:2:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  do for[j=1:3:1] {
    yc[j] = 0.5*(yf[j]+yf[j+1])
  }
## left
  set label 'Math' center at graph 0.25, graph 0.94
  ox = 0.75
  oy = 0.75
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[4] as 1
  }
  do for[j=1:4:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[3], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[3]+0.5*al, first oy+yf[2] to first ox+xf[3]+0.5*al, first oy+yf[3] as 4
  set label '$\Delta y$' left at first ox+xf[3]+1.*al, first oy+yc[2] front
# ux
  set arrow from first ox+xf[2]-al, first oy+yc[1] to first ox+xf[2]+al, first oy+yc[1] as 2
  set arrow from first ox+xf[2]-al, first oy+yc[2] to first ox+xf[2]+al, first oy+yc[2] as 2
  set arrow from first ox+xf[2]-al, first oy+yc[3] to first ox+xf[2]+al, first oy+yc[3] as 2
  set label '$\left. \delta u_x^{\prime} \right|_{i+\frac{1}{2},j-1}$' center at first ox+xf[2],oy+yc[1] front
  set label '$\left. \delta u_x^{\prime} \right|_{i+\frac{1}{2},j  }$' center at first ox+xf[2],oy+yc[2] front
  set label '$\left. \delta u_x^{\prime} \right|_{i+\frac{1}{2},j+1}$' center at first ox+xf[2],oy+yc[3] front
# cell center
  do for [j=1:3:1] {
    set object circle center first ox+xc[1], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    set object circle center first ox+xc[2], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  }
## right
  set label 'Code' center at graph 0.75, graph 0.94
  ox = 6.75
  oy = 0.75
# grid
  do for[i=1:3:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[4] as 1
  }
  do for[j=1:4:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[3], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[3]+0.5*al, first oy+yf[2] to first ox+xf[3]+0.5*al, first oy+yf[3] as 4
  set label '$dy$' left at first ox+xf[3]+1.*al, first oy+yc[2] front
# ux
  set arrow from first ox+xf[2]-al, first oy+yc[1] to first ox+xf[2]+al, first oy+yc[1] as 2
  set arrow from first ox+xf[2]-al, first oy+yc[2] to first ox+xf[2]+al, first oy+yc[2] as 2
  set arrow from first ox+xf[2]-al, first oy+yc[3] to first ox+xf[2]+al, first oy+yc[3] as 2
  set label '$QY \left( i, j-1 \right)$' center at first ox+xf[2],oy+yc[1] front
  set label '$QY \left( i, j   \right)$' center at first ox+xf[2],oy+yc[2] front
  set label '$QY \left( i, j+1 \right)$' center at first ox+xf[2],oy+yc[3] front
# cell center
  do for [j=1:3:1] {
    set object circle center first ox+xc[1], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    set object circle center first ox+xc[2], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  }
  plot \
    NaN notitle
}

### update_uy

reset
{
  set terminal epslatex standalone color size 15,6 font ',17'
  set output 'update_velocity12.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:15]
  set yrange [-0.5:5.5]
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
  array xf[4] = [0., 1.5, 3.5, 6.0]
  array yf[3] = [0., 2., 4.]
  array xc[3]
  array yc[2]
  do for[i=1:3:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  do for[j=1:2:1] {
    yc[j] = 0.5*(yf[j]+yf[j+1])
  }
## left
  set label 'Math' center at graph 0.25, graph 0.92
  ox = 0.75
  oy = 0.75
# grid
  do for [i=1:4:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[3] as 1
  }
  do for [j=1:3:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[4], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 4
  set arrow from first ox+xc[2], first oy-1.*al to first ox+xc[3], first oy-1.*al as 4
  set arrow from first ox+xf[2], first oy-3.*al to first ox+xf[3], first oy-3.*al as 4
  set label '$\Delta x_{i-\frac{1}{2}}$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al front
  set label '$\Delta x_{i+\frac{1}{2}}$' center at first ox+0.5*(xc[2]+xc[3]), first oy-2.*al front
  set label '$\Delta x_{i  }$'           center at first ox+xc[2], first oy-4.*al front
# uy
  set arrow from first ox+xc[1], first oy+yf[2]-al to first ox+xc[1], first oy+yf[2]+al as 3
  set arrow from first ox+xc[2], first oy+yf[2]-al to first ox+xc[2], first oy+yf[2]+al as 3
  set arrow from first ox+xc[3], first oy+yf[2]-al to first ox+xc[3], first oy+yf[2]+al as 3
  set label '$\left. \delta u_y \right|_{i-1,j+\frac{1}{2}}$' center at first ox+xc[1],oy+yf[2] front
  set label '$\left. \delta u_y \right|_{i  ,j+\frac{1}{2}}$' center at first ox+xc[2],oy+yf[2] front
  set label '$\left. \delta u_y \right|_{i+1,j+\frac{1}{2}}$' center at first ox+xc[3],oy+yf[2] front
# cell center
  do for [j=1:2:1] {
    do for [i=1:3:1] {
      set object circle center first ox+xc[i], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
  }
## right
  set label 'Code' center at graph 0.75, graph 0.92
  ox = 8.25
  oy = 0.75
# grid
  do for [i=1:4:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[3] as 1
  }
  do for [j=1:3:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[4], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 4
  set arrow from first ox+xc[2], first oy-1.*al to first ox+xc[3], first oy-1.*al as 4
  set arrow from first ox+xf[2], first oy-3.*al to first ox+xf[3], first oy-3.*al as 4
  set label '$DXC \left( i   \right)$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al front
  set label '$DXC \left( i+1 \right)$' center at first ox+0.5*(xc[2]+xc[3]), first oy-2.*al front
  set label '$DXF \left( i \right)$'           center at first ox+xc[2], first oy-4.*al front
# uy
  set arrow from first ox+xc[1], first oy+yf[2]-al to first ox+xc[1], first oy+yf[2]+al as 3
  set arrow from first ox+xc[2], first oy+yf[2]-al to first ox+xc[2], first oy+yf[2]+al as 3
  set arrow from first ox+xc[3], first oy+yf[2]-al to first ox+xc[3], first oy+yf[2]+al as 3
  set label '$QX \left( i-1, j \right)$' center at first ox+xc[1],oy+yf[2] front
  set label '$QX \left( i  , j \right)$' center at first ox+xc[2],oy+yf[2] front
  set label '$QX \left( i+1, j \right)$' center at first ox+xc[3],oy+yf[2] front
# cell center
  do for [j=1:2:1] {
    do for [i=1:3:1] {
      set object circle center first ox+xc[i], first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
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
  set output 'update_velocity13.tex'
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
  set style line 4 lc rgb '#000000' lw 10
  #
  set style arrow 1 nohead front ls 1
  set style arrow 2 head size graph 0.02,20. filled front ls 2
  set style arrow 3 head size graph 0.02,20. filled front ls 3
  set style arrow 4 head size 0.2,10 filled front ls 4
  #
  ## left
  ox = 0.
  oy = 0.
  # process 0
  set object rectangle from first ox+0., first oy+0. to first ox+lx, first oy+2.5 fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 0' center at first -1.25, first 1.25
  # process 1
  set object rectangle from first ox+0., first oy+2.5 to first ox+lx, first oy+6.5 fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 1' center at first -1.25, first 4.5
  # process 2
  set object rectangle from first ox+0., first oy+6.5 to first ox+lx, first oy+ly fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 2' center at first -1.25, first 8.75
  # horizontal
  do for [j=0:ly:1] {
    set arrow from first ox+0., first j to first ox+lx, j as 1
  }
  # vertical
  do for [i=0:lx:1] {
    set arrow from first ox+i, first 0. to first ox+i, ly as 1
  }
  # uy
  do for [j=1:11:1] {
    do for [i=1:7:1] {
      set arrow from first ox+(i-0.5), first oy+(j-1.)-1.*al to first ox+(i-0.5), first oy+(j-1.)+1.*al as 4
    }
  }
  ## right
  ox = lx+3.
  oy = 0.
  # process 0
  set object rectangle from first ox+0., first oy+0. to first ox+2., first oy+ly fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#000000' lw 20 back
  set label 'mpirank 0' center at first ox+1., first ly+1.0
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
  # uy
  do for [j=1:11:1] {
    do for [i=1:7:1] {
      set arrow from first ox+(i-0.5), first oy+(j-1.)-1.*al to first ox+(i-0.5), first oy+(j-1.)+1.*al as 4
    }
  }
  ## arrow
  set arrow from first lx+0.5, first 0.5*ly to first lx+2.5, first 0.5*ly as 2
  plot \
    NaN notitle
}

reset
{
  set terminal epslatex standalone color size 7,6 font ',17'
  set output 'update_velocity14.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:7]
  set yrange [0:6]
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
  array yc[2]
  xc = 0.5*(xf[1]+xf[2])
  do for[j=1:2:1] {
    yc[j] = 0.5*(yf[j]+yf[j+1])
  }
## left
  set label 'Math' center at graph 0.25, graph 0.92
  ox = 0.75
  oy = 0.75
# grid
  do for [i=1:2:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[3] as 1
  }
  do for [j=1:3:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[2], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[2]+0.5*al, first oy+yc[1] to ox+xf[2]+0.5*al, first oy+yc[2] as 4
  set label '$\Delta y$' left at first ox+xf[2]+1.*al, oy+yf[2] front
# uy
  set arrow from first ox+xc, first oy+yf[1]-al to first ox+xc, first oy+yf[1]+al as 3
  set arrow from first ox+xc, first oy+yf[2]-al to first ox+xc, first oy+yf[2]+al as 3
  set arrow from first ox+xc, first oy+yf[3]-al to first ox+xc, first oy+yf[3]+al as 3
  set label '$\left. \delta u_y^{\prime} \right|_{i,j-\frac{1}{2}}$' center at first ox+xc,oy+yf[1] front
  set label '$\left. \delta u_y^{\prime} \right|_{i,j+\frac{1}{2}}$' center at first ox+xc,oy+yf[2] front
  set label '$\left. \delta u_y^{\prime} \right|_{i,j+\frac{3}{2}}$' center at first ox+xc,oy+yf[3] front
# cell center
  do for [j=1:2:1] {
    set object circle center first ox+xc, first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  }
## right
  set label 'Code' center at graph 0.75, graph 0.92
  ox = 4.25
  oy = 0.75
# grid
  do for [i=1:2:1] {
    set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[3] as 1
  }
  do for [j=1:3:1] {
    set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[2], first oy+yf[j] as 1
  }
# grid size
  set arrow from first ox+xf[2]+0.5*al, first oy+yc[1] to ox+xf[2]+0.5*al, first oy+yc[2] as 4
  set label '$dy$' left at first ox+xf[2]+1.*al, oy+yf[2] front
# uy
  set arrow from first ox+xc, first oy+yf[1]-al to first ox+xc, first oy+yf[1]+al as 3
  set arrow from first ox+xc, first oy+yf[2]-al to first ox+xc, first oy+yf[2]+al as 3
  set arrow from first ox+xc, first oy+yf[3]-al to first ox+xc, first oy+yf[3]+al as 3
  set label '$QY \left( i, j-1 \right)$' center at first ox+xc,oy+yf[1] front
  set label '$QY \left( i, j   \right)$' center at first ox+xc,oy+yf[2] front
  set label '$QY \left( i, j+1 \right)$' center at first ox+xc,oy+yf[3] front
# cell center
  do for [j=1:2:1] {
    set object circle center first ox+xc, first oy+yc[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
  }
  plot \
    NaN notitle
}

