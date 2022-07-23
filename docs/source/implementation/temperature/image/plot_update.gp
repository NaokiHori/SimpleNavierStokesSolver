### gradient of T
{
  do for [direction in 'x y'] {
    reset
    set terminal epslatex standalone color size 15,3.5 font ',17'
    set output sprintf('update_dtd%s.tex', direction)
    unset border
    set lmargin 0.
    set rmargin 0.
    set bmargin 0.
    set tmargin 0.
    unset xlabel
    unset ylabel
    set xrange [0:15]
    set yrange [0.:3.5]
    unset xtics
    unset ytics
    set format x ''
    set format y ''
    set style line 1 lc rgb '#888888' lw 5
    if(direction eq 'x'){
      color_of_arrow = '#FF0000'
    }else{
      color_of_arrow = '#0000FF'
    }
    set style line 2 lc rgb color_of_arrow lw 10
    set style line 3 lc rgb '#000000' lw 5
    set style arrow 1 nohead front ls 1
    set style arrow 2 head  size 0.2,10 filled front linestyle 2
    set style arrow 3 heads size 0.2,10 filled front linestyle 3
    al = 0.25
    if(direction eq 'x'){
      array xf[4] = [0., 1.5, 3.5, 6.0]
    }else{
      array xf[4] = [0., 2.0, 4.0, 6.0]
    }
    array yf[2] = [0., 2.]
    array xc[3]
    do for[i=1:3:1] {
      xc[i] = 0.5*(xf[i]+xf[i+1])
    }
    yc = 0.5*(yf[1]+yf[2])
    ## left
    set label 'Math' center at graph 0.25, graph 0.92
    ox = 0.75
    oy = 0.75
    # grid
    do for [i=1:4:1] {
      set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
    }
    do for [j=1:2:1] {
      set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[4], first oy+yf[j] as 1
    }
    # grid size
    set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 3
    set arrow from first ox+xc[2], first oy-1.*al to first ox+xc[3], first oy-1.*al as 3
    if(direction eq 'x'){
      set label '$\Delta x_{i-\frac{1}{2}}$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al front
      set label '$\Delta x_{i+\frac{1}{2}}$' center at first ox+0.5*(xc[2]+xc[3]), first oy-2.*al front
    }else{
      set label '$\Delta y$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al front
      set label '$\Delta y$' center at first ox+0.5*(xc[2]+xc[3]), first oy-2.*al front
    }
    # ux / uy
    set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
    set arrow from first ox+xf[3]-al, first oy+yc to first ox+xf[3]+al, first oy+yc as 2
    # T
    if(direction eq 'x'){
      set label '$\left. T \right|_{i-1,j}$' center at first ox+xc[1],oy+yc+0.25 front
      set label '$\left. T \right|_{i  ,j}$' center at first ox+xc[2],oy+yc+0.25 front
      set label '$\left. T \right|_{i+1,j}$' center at first ox+xc[3],oy+yc+0.25 front
      set label '$\left. \frac{\delta T}{\delta x} \right|_{i-\frac{1}{2},j}$' center at first ox+xf[2],oy+yc-0.25 front
      set label '$\left. \frac{\delta T}{\delta x} \right|_{i+\frac{1}{2},j}$' center at first ox+xf[3],oy+yc-0.25 front
    }else{
      set label '$\left. T \right|_{i,j-1}$' center at first ox+xc[1],oy+yc+0.25 front
      set label '$\left. T \right|_{i,j  }$' center at first ox+xc[2],oy+yc+0.25 front
      set label '$\left. T \right|_{i,j+1}$' center at first ox+xc[3],oy+yc+0.25 front
      set label '$\left. \frac{\delta T}{\delta y} \right|_{i,j-\frac{1}{2}}$' center at first ox+xf[2],oy+yc-0.25 front
      set label '$\left. \frac{\delta T}{\delta y} \right|_{i,j+\frac{1}{2}}$' center at first ox+xf[3],oy+yc-0.25 front
    }
    # cell center
    do for [i=1:3:1] {
      set object circle center first ox+xc[i], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
    ## right
    set label 'Code' center at graph 0.75, graph 0.92
    ox = 8.25
    oy = 0.75
    # grid
    do for [i=1:4:1] {
      set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
    }
    do for [j=1:2:1] {
      set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[4], first oy+yf[j] as 1
    }
    # grid size
    set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 3
    set arrow from first ox+xc[2], first oy-1.*al to first ox+xc[3], first oy-1.*al as 3
    if(direction eq 'x'){
      set label '$DXC \left( i   \right)$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al front
      set label '$DXC \left( i+1 \right)$' center at first ox+0.5*(xc[2]+xc[3]), first oy-2.*al front
    }else{
      set label '$dy$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al front
      set label '$dy$' center at first ox+0.5*(xc[2]+xc[3]), first oy-2.*al front
    }
    # ux / uy
    set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
    set arrow from first ox+xf[3]-al, first oy+yc to first ox+xf[3]+al, first oy+yc as 2
    # T
    if(direction eq 'x'){
      set label '$T \left( i-1, j \right)$' center at first ox+xc[1],oy+yc+0.25 front
      set label '$T \left( i  , j \right)$' center at first ox+xc[2],oy+yc+0.25 front
      set label '$T \left( i+1, j \right)$' center at first ox+xc[3],oy+yc+0.25 front
      set label 'dtdx\_xm' center at first ox+xf[2],oy+yc-0.25 front
      set label 'dtdx\_xp' center at first ox+xf[3],oy+yc-0.25 front
    }else{
      set label '$T \left( i, j-1 \right)$' center at first ox+xc[1],oy+yc+0.25 front
      set label '$T \left( i, j   \right)$' center at first ox+xc[2],oy+yc+0.25 front
      set label '$T \left( i, j+1 \right)$' center at first ox+xc[3],oy+yc+0.25 front
      set label 'dtdy\_ym' center at first ox+xf[2],oy+yc-0.25 front
      set label 'dtdy\_yp' center at first ox+xf[3],oy+yc-0.25 front
    }
    # cell center
    do for [i=1:3:1] {
      set object circle center first ox+xc[i], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
    plot \
      NaN notitle
  }
}

### advection
{
  do for [direction in 'x y'] {
    reset
    if(direction eq 'x'){
      set terminal epslatex standalone color size 15,4.0 font ',17'
    }else{
      set terminal epslatex standalone color size 15,3.5 font ',17'
    }
    set output sprintf('update_adv_%s.tex', direction)
    unset border
    set lmargin 0.
    set rmargin 0.
    set bmargin 0.
    set tmargin 0.
    unset xlabel
    unset ylabel
    set xrange [0:15]
    if(direction eq 'x'){
      set yrange [-0.5:3.5]
    }else{
      set yrange [ 0.0:3.5]
    }
    unset xtics
    unset ytics
    set format x ''
    set format y ''
    set style line 1 lc rgb '#888888' lw 5
    if(direction eq 'x'){
      color_of_arrow = '#FF0000'
    }else{
      color_of_arrow = '#0000FF'
    }
    set style line 2 lc rgb color_of_arrow lw 10
    set style line 3 lc rgb '#000000' lw 5
    set style arrow 1 nohead front ls 1
    set style arrow 2 head  size 0.2,10 filled front ls 2
    set style arrow 3 heads size 0.2,10 filled front ls 3
    al = 0.25
    if(direction eq 'x'){
      array xf[4] = [0., 1.5, 3.5, 6.0]
    }else{
      array xf[4] = [0., 2.0, 4.0, 6.0]
    }
    array yf[2] = [0., 2.]
    array xc[3]
    do for[i=1:3:1] {
      xc[i] = 0.5*(xf[i]+xf[i+1])
    }
    yc = 0.5*(yf[1]+yf[2])
    ## left
    set label 'Math' center at graph 0.25, graph 0.92
    ox = 0.75
    oy = 0.75
    # grid
    do for [i=1:4:1] {
      set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
    }
    do for [j=1:2:1] {
      set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[4], first oy+yf[j] as 1
    }
    # grid size
    if(direction eq 'x'){
      set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 3
      set arrow from first ox+xc[2], first oy-1.*al to first ox+xc[3], first oy-1.*al as 3
      set arrow from first ox+xf[2], first oy-3.*al to first ox+xf[3], first oy-3.*al as 3
      set label '$\Delta x_{i-\frac{1}{2}}$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al front
      set label '$\Delta x_{i+\frac{1}{2}}$' center at first ox+0.5*(xc[2]+xc[3]), first oy-2.*al front
      set label '$\Delta x_{i  }$'           center at first ox+xc[2],             first oy-4.*al front
    }
    # ux / uy
    set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
    set arrow from first ox+xf[3]-al, first oy+yc to first ox+xf[3]+al, first oy+yc as 2
    if(direction eq 'x'){
      set label '$\left. u_x \right|_{i-\frac{1}{2},j}$' center at first ox+xf[2],oy+yc+0.25 front
      set label '$\left. u_x \right|_{i+\frac{1}{2},j}$' center at first ox+xf[3],oy+yc+0.25 front
      set label '$\left. \frac{\delta T}{\delta x} \right|_{i-\frac{1}{2},j}$' center at first ox+xf[2],oy+yc-0.25 front
      set label '$\left. \frac{\delta T}{\delta x} \right|_{i+\frac{1}{2},j}$' center at first ox+xf[3],oy+yc-0.25 front
    }else{
      set label '$\left. u_y \right|_{i,j-\frac{1}{2}}$' center at first ox+xf[2],oy+yc+0.25 front
      set label '$\left. u_y \right|_{i,j+\frac{1}{2}}$' center at first ox+xf[3],oy+yc+0.25 front
      set label '$\left. \frac{\delta T}{\delta y} \right|_{i,j-\frac{1}{2}}$' center at first ox+xf[2],oy+yc-0.25 front
      set label '$\left. \frac{\delta T}{\delta y} \right|_{i,j+\frac{1}{2}}$' center at first ox+xf[3],oy+yc-0.25 front
    }
    # cell center
    do for [i=1:3:1] {
      set object circle center first ox+xc[i], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
    ## right
    set label 'Code' center at graph 0.75, graph 0.92
    ox = 8.25
    oy = 0.75
    # grid
    do for [i=1:4:1] {
      set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
    }
    do for [j=1:2:1] {
      set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[4], first oy+yf[j] as 1
    }
    # grid size
    if(direction eq 'x'){
      set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 3
      set arrow from first ox+xc[2], first oy-1.*al to first ox+xc[3], first oy-1.*al as 3
      set arrow from first ox+xf[2], first oy-3.*al to first ox+xf[3], first oy-3.*al as 3
      set label '$DXC \left( i   \right)$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al front
      set label '$DXC \left( i+1 \right)$' center at first ox+0.5*(xc[2]+xc[3]), first oy-2.*al front
      set label '$DXF \left( i   \right)$' center at first ox+xc[2],             first oy-4.*al front
    }
    # ux / uy
    set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
    set arrow from first ox+xf[3]-al, first oy+yc to first ox+xf[3]+al, first oy+yc as 2
    if(direction eq 'x'){
      set label '$UX \left( i  , j \right)$' center at first ox+xf[2],oy+yc+0.25 front
      set label '$UX \left( i+1, j \right)$' center at first ox+xf[3],oy+yc+0.25 front
      set label 'dtdx\_xm' center at first ox+xf[2],oy+yc-0.25 front
      set label 'dtdx\_xp' center at first ox+xf[3],oy+yc-0.25 front
    }else{
      set label '$UY \left( i, j   \right)$' center at first ox+xf[2],oy+yc+0.25 front
      set label '$UY \left( i, j+1 \right)$' center at first ox+xf[3],oy+yc+0.25 front
      set label 'dtdy\_ym' center at first ox+xf[2],oy+yc-0.25 front
      set label 'dtdy\_yp' center at first ox+xf[3],oy+yc-0.25 front
    }
    # cell center
    do for [i=1:3:1] {
      set object circle center first ox+xc[i], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
    plot \
      NaN notitle
  }
}

### diffusion
{
  do for [direction in 'x y'] {
    reset
    set terminal epslatex standalone color size 15,3.5 font ',17'
    set output sprintf('update_dif_%s.tex', direction)
    unset border
    set lmargin 0.
    set rmargin 0.
    set bmargin 0.
    set tmargin 0.
    unset xlabel
    unset ylabel
    set xrange [0:15]
    set yrange [0.:3.5]
    unset xtics
    unset ytics
    set format x ''
    set format y ''
    set style line 1 lc rgb '#888888' lw 5
    if(direction eq 'x'){
      color_of_arrow = '#FF0000'
    }else{
      color_of_arrow = '#0000FF'
    }
    set style line 2 lc rgb color_of_arrow lw 10
    set style line 3 lc rgb '#000000' lw 5
    set style arrow 1 nohead front ls 1
    set style arrow 2 head  size 0.2,10 filled front linestyle 2
    set style arrow 3 heads size 0.2,10 filled front linestyle 3
    al = 0.25
    if(direction eq 'x'){
      array xf[4] = [0., 1.5, 3.5, 6.0]
    }else{
      array xf[4] = [0., 2.0, 4.0, 6.0]
    }
    array yf[2] = [0., 2.]
    array xc[3]
    do for[i=1:3:1] {
      xc[i] = 0.5*(xf[i]+xf[i+1])
    }
    yc = 0.5*(yf[1]+yf[2])
    ## left
    set label 'Math' center at graph 0.25, graph 0.92
    ox = 0.75
    oy = 0.75
    # grid
    do for [i=1:4:1] {
      set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
    }
    do for [j=1:2:1] {
      set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[4], first oy+yf[j] as 1
    }
    # grid size
    set arrow from first ox+xf[2], first oy-1.*al to first ox+xf[3], first oy-1.*al as 3
    if(direction eq 'x'){
      set label '$\Delta x_{i            }$' center at first ox+0.5*(xf[2]+xf[3]), first oy-2.*al front
    }else{
      set label '$\Delta y$' center at first ox+0.5*(xf[2]+xf[3]), first oy-2.*al front
    }
    # ux / uy
    set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
    set arrow from first ox+xf[3]-al, first oy+yc to first ox+xf[3]+al, first oy+yc as 2
    # T
    if(direction eq 'x'){
      set label '$\left. \frac{\delta T}{\delta x} \right|_{i-\frac{1}{2},j}$' center at first ox+xf[2],oy+yc-0.25 front
      set label '$\left. \frac{\delta T}{\delta x} \right|_{i+\frac{1}{2},j}$' center at first ox+xf[3],oy+yc-0.25 front
    }else{
      set label '$\left. \frac{\delta T}{\delta y} \right|_{i,j-\frac{1}{2}}$' center at first ox+xf[2],oy+yc-0.25 front
      set label '$\left. \frac{\delta T}{\delta y} \right|_{i,j+\frac{1}{2}}$' center at first ox+xf[3],oy+yc-0.25 front
    }
    # cell center
    do for [i=1:3:1] {
      set object circle center first ox+xc[i], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
    ## right
    set label 'Code' center at graph 0.75, graph 0.92
    ox = 8.25
    oy = 0.75
    # grid
    do for [i=1:4:1] {
      set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
    }
    do for [j=1:2:1] {
      set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[4], first oy+yf[j] as 1
    }
    # grid size
    set arrow from first ox+xf[2], first oy-1.*al to first ox+xf[3], first oy-1.*al as 3
    if(direction eq 'x'){
      set label '$DXF \left( i   \right)$' center at first ox+0.5*(xf[2]+xf[3]), first oy-2.*al front
    }else{
      set label '$dy$' center at first ox+0.5*(xf[2]+xf[3]), first oy-2.*al front
    }
    # ux / uy
    set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
    set arrow from first ox+xf[3]-al, first oy+yc to first ox+xf[3]+al, first oy+yc as 2
    # T
    if(direction eq 'x'){
      set label 'dtdx\_xm' center at first ox+xf[2],oy+yc-0.25 front
      set label 'dtdx\_xp' center at first ox+xf[3],oy+yc-0.25 front
    }else{
      set label 'dtdy\_ym' center at first ox+xf[2],oy+yc-0.25 front
      set label 'dtdy\_yp' center at first ox+xf[3],oy+yc-0.25 front
    }
    # cell center
    do for [i=1:3:1] {
      set object circle center first ox+xc[i], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
    plot \
      NaN notitle
  }
}

### linear system
{
  do for [direction in 'x y'] {
    reset
    set terminal epslatex standalone color size 15,4.0 font ',17'
    set output sprintf('update_linear_system_%s.tex', direction)
    unset border
    set lmargin 0.
    set rmargin 0.
    set bmargin 0.
    set tmargin 0.
    unset xlabel
    unset ylabel
    set xrange [0:15]
    set yrange [-0.5:3.5]
    unset xtics
    unset ytics
    set format x ''
    set format y ''
    set style line 1 lc rgb '#888888' lw 5
    if(direction eq 'x'){
      color_of_arrow = '#FF0000'
    }else{
      color_of_arrow = '#0000FF'
    }
    set style line 2 lc rgb color_of_arrow lw 10
    set style line 3 lc rgb '#000000' lw 5
    set style arrow 1 nohead front ls 1
    set style arrow 2 head  size 0.2,10 filled front linestyle 2
    set style arrow 3 heads size 0.2,10 filled front linestyle 3
    al = 0.25
    if(direction eq 'x'){
      array xf[4] = [0., 1.5, 3.5, 6.0]
    }else{
      array xf[4] = [0., 2.0, 4.0, 6.0]
    }
    array yf[2] = [0., 2.]
    array xc[3]
    do for[i=1:3:1] {
      xc[i] = 0.5*(xf[i]+xf[i+1])
    }
    yc = 0.5*(yf[1]+yf[2])
    ## left
    set label 'Math' center at graph 0.25, graph 0.92
    ox = 0.75
    oy = 0.75
    # grid
    do for [i=1:4:1] {
      set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
    }
    do for [j=1:2:1] {
      set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[4], first oy+yf[j] as 1
    }
    # grid size
    set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 3
    set arrow from first ox+xc[2], first oy-1.*al to first ox+xc[3], first oy-1.*al as 3
    set arrow from first ox+xf[2], first oy-3.*al to first ox+xf[3], first oy-3.*al as 3
    if(direction eq 'x'){
      set label '$\Delta x_{i-\frac{1}{2}}$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al front
      set label '$\Delta x_{i+\frac{1}{2}}$' center at first ox+0.5*(xc[2]+xc[3]), first oy-2.*al front
      set label '$\Delta x_{i            }$' center at first ox+0.5*(xf[2]+xf[3]), first oy-4.*al front
    }else{
      set label '$\Delta y$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al front
      set label '$\Delta y$' center at first ox+0.5*(xc[2]+xc[3]), first oy-2.*al front
      set label '$\Delta y$' center at first ox+0.5*(xf[2]+xf[3]), first oy-4.*al front
    }
    # ux / uy
    set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
    set arrow from first ox+xf[3]-al, first oy+yc to first ox+xf[3]+al, first oy+yc as 2
    # T
    if(direction eq 'x'){
      set label '$\left. T \right|_{i-1,j}$' center at first ox+xc[1],oy+yc+0.25 front
      set label '$\left. T \right|_{i  ,j}$' center at first ox+xc[2],oy+yc+0.25 front
      set label '$\left. T \right|_{i+1,j}$' center at first ox+xc[3],oy+yc+0.25 front
    }else{
      set label '$\left. T \right|_{i,j-1}$' center at first ox+xc[1],oy+yc+0.25 front
      set label '$\left. T \right|_{i,j  }$' center at first ox+xc[2],oy+yc+0.25 front
      set label '$\left. T \right|_{i,j+1}$' center at first ox+xc[3],oy+yc+0.25 front
    }
    # cell center
    do for [i=1:3:1] {
      set object circle center first ox+xc[i], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
    ## right
    set label 'Code' center at graph 0.75, graph 0.92
    ox = 8.25
    oy = 0.75
    # grid
    do for [i=1:4:1] {
      set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
    }
    do for [j=1:2:1] {
      set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[4], first oy+yf[j] as 1
    }
    # grid size
    set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 3
    set arrow from first ox+xc[2], first oy-1.*al to first ox+xc[3], first oy-1.*al as 3
    set arrow from first ox+xf[2], first oy-3.*al to first ox+xf[3], first oy-3.*al as 3
    if(direction eq 'x'){
      set label '$DXC \left( i   \right)$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al front
      set label '$DXC \left( i+1 \right)$' center at first ox+0.5*(xc[2]+xc[3]), first oy-2.*al front
      set label '$DXF \left( i   \right)$' center at first ox+0.5*(xf[2]+xf[3]), first oy-4.*al front
    }else{
      set label '$dy$' center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al front
      set label '$dy$' center at first ox+0.5*(xc[2]+xc[3]), first oy-2.*al front
      set label '$dy$' center at first ox+0.5*(xf[2]+xf[3]), first oy-4.*al front
    }
    # ux / uy
    set arrow from first ox+xf[2]-al, first oy+yc to first ox+xf[2]+al, first oy+yc as 2
    set arrow from first ox+xf[3]-al, first oy+yc to first ox+xf[3]+al, first oy+yc as 2
    # T
    if(direction eq 'x'){
      set label '$T \left( i-1, j \right)$' center at first ox+xc[1],oy+yc+0.25 front
      set label '$T \left( i  , j \right)$' center at first ox+xc[2],oy+yc+0.25 front
      set label '$T \left( i+1, j \right)$' center at first ox+xc[3],oy+yc+0.25 front
    }else{
      set label '$T \left( i, j-1 \right)$' center at first ox+xc[1],oy+yc+0.25 front
      set label '$T \left( i, j   \right)$' center at first ox+xc[2],oy+yc+0.25 front
      set label '$T \left( i, j+1 \right)$' center at first ox+xc[3],oy+yc+0.25 front
    }
    # cell center
    do for [i=1:3:1] {
      set object circle center first ox+xc[i], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
    plot \
      NaN notitle
  }
}

### domain decomposition
reset
{
  lx = 7.
  ly = 11.
  #
  set terminal epslatex standalone color size 2*lx+6.,ly+2. font ',20'
  set output 'update_domain_decomp.tex'
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
  # pressure
  do for [j=1:11:1] {
    do for [i=1:7:1] {
      set object circle center first ox+(i-0.5), first oy+(j-0.5) size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
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
  set label 'mpirank 1' center at first ox+3., first ly+1.0
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
  # pressure
  do for [j=1:11:1] {
    do for [i=1:7:1] {
      set object circle center first ox+(i-0.5), first oy+(j-0.5) size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
  }
  ## arrow
  set arrow from first lx+0.5, first 0.5*ly to first lx+2.5, first 0.5*ly as 2
  plot \
    NaN notitle
}

