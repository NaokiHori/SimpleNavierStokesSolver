### lxx and lyy
do for [case in 'xx yy'] {
  reset
  set terminal epslatex standalone color size 12,3.5 font ',17'
  set output sprintf('update_velocity_l%s.tex', case)
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
  if(case eq 'xx'){
    set style line 2 lc rgb '#FF0000' lw 10
  }else{
    set style line 2 lc rgb '#0000FF' lw 10
  }
  set style line 3 lc rgb '#000000' lw 5
  set style arrow 1 nohead front ls 1
  set style arrow 2 head  size 0.2,10 filled front ls 2
  set style arrow 3 heads size 0.2,10 filled front ls 3
  al = 0.25
  if(case eq 'xx'){
    array xf[3] = [0., 2.,   4.5]
  }else{
    array xf[3] = [0., 2.25, 4.5]
  }
  array yf[2] = [0., 2.]
  array xc[2]
  do for[i=1:2:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  yc = 0.5*(yf[1]+yf[2])
  ## left-right
  do for [lr=1:2:1] {
    if(lr == 1){
      # top labels
      set label 'Math' center at graph 0.25, graph 0.92
      # origin
      ox = 0.75
      oy = 0.75
      # labels
      if(case eq 'xx'){
        array grid_size_labels[2] = [ \
          '$\Delta x_{i  }$', \
          '$\Delta x_{i+1}$', \
        ]
        array lij_labels[2] = [ \
          '$\left. \frac{\delta u_x}{\delta x} \right|_{i  , j}$', \
          '$\left. \frac{\delta u_x}{\delta x} \right|_{i+1, j}$', \
        ]
        array vel_labels[3] = [ \
          '$\left. u_x \right|_{i-\frac{1}{2},j}$', \
          '$\left. u_x \right|_{i+\frac{1}{2},j}$', \
          '$\left. u_x \right|_{i+\frac{3}{2},j}$', \
        ]
      }else{
        array grid_size_labels[2] = [ \
          '$\Delta y$', \
          '$\Delta y$', \
        ]
        array lij_labels[2] = [ \
          '$\left. \frac{\delta u_y}{\delta y} \right|_{i, j  }$', \
          '$\left. \frac{\delta u_y}{\delta y} \right|_{i, j+1}$', \
        ]
        array vel_labels[3] = [ \
          '$\left. u_y \right|_{i,j-\frac{1}{2}}$', \
          '$\left. u_y \right|_{i,j+\frac{1}{2}}$', \
          '$\left. u_y \right|_{i,j+\frac{3}{2}}$', \
        ]
      }
    }else{
      # top labels
      set label 'Code' center at graph 0.75, graph 0.92
      # origin
      ox = 6.75
      oy = 0.75
      # labels
      if(case eq 'xx'){
        array grid_size_labels[2] = [ \
          '$DXF \left( i-1 \right)$', \
          '$DXF \left( i   \right)$', \
        ]
        array lij_labels[2] = [ \
          'duxdx\_xm', \
          'duxdx\_xp', \
        ]
        array vel_labels[3] = [ \
          '$UX \left( i-1, j \right)$', \
          '$UX \left( i  , j \right)$', \
          '$UX \left( i+1, j \right)$', \
        ]
      }else{
        array grid_size_labels[2] = [ \
          '$dy$', \
          '$dy$', \
        ]
        array lij_labels[2] = [ \
          'duydy\_ym', \
          'duydy\_yp', \
        ]
        array vel_labels[3] = [ \
          '$UY \left( i, j-1 \right)$', \
          '$UY \left( i, j   \right)$', \
          '$UY \left( i, j+1 \right)$', \
        ]
      }
    }
    # grid edges (vertical)
    do for[i=1:3:1] {
      set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
    }
    # grid edges (horizontal)
    do for[j=1:2:1] {
      set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[3], first oy+yf[j] as 1
    }
    # grid size arrows
    do for [i=1:2:1] {
      set arrow from first ox+xf[i], first oy-1.*al to first ox+xf[i+1], first oy-1.*al as 3
    }
    # cell center markers
    do for [i=1:2:1] {
      set object circle center first ox+xc[i], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
    # velocity arrows
    do for [i=1:3:1] {
      set arrow from first ox+xf[i]-al, first oy+yc to first ox+xf[i]+al, first oy+yc as 2
    }
    # labels
    do for [i=1:2:1] {
      set label grid_size_labels[i] center at first ox+xc[i], first oy-2.*al
      set label lij_labels[i]       center at first ox+xc[i], first oy+yc-1.*al front
    }
    do for [i=1:3:1] {
      set label vel_labels[i] center at first ox+xf[i], first oy+yc+1.*al front
    }
  }
  plot \
    NaN notitle
}

### lxy and lyx
do for [case in 'xy yx'] {
  reset
  set terminal epslatex standalone color size 12,3.5 font ',17'
  set output sprintf('update_velocity_l%s.tex', case)
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
  if(case eq 'xy'){
    set style line 2 lc rgb '#FF0000' lw 10
  }else{
    set style line 2 lc rgb '#0000FF' lw 10
  }
  set style line 3 lc rgb '#000000' lw 5
  set style arrow 1 nohead front ls 1
  set style arrow 2 head  size 0.2,10 filled front ls 2
  set style arrow 3 heads size 0.2,10 filled front ls 3
  al = 0.25
  if(case eq 'yx'){
    array xf[4] = [0., 1.5, 3.5, 6.0]
  }else{
    array xf[4] = [0., 2.0, 4.0, 6.0]
  }
  array yc[2] = [0., 2.]
  array xc[3]
  do for[i=1:3:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  yf = 0.5*(yc[1]+yc[2])
  ## left-right
  do for [lr=1:2:1] {
    if(lr == 1){
      # top labels
      set label 'Math' center at graph 0.25, graph 0.92
      # origin
      ox = 0.75
      oy = 0.75
      # labels
      if(case eq 'yx'){
        array grid_size_labels[2] = [ \
          '$\Delta x_{i-\frac{1}{2}}$', \
          '$\Delta x_{i+\frac{1}{2}}$', \
        ]
        array lij_labels[2] = [ \
          '$\left. \frac{\delta u_y}{\delta x} \right|_{i-\frac{1}{2}, j+\frac{1}{2}}$', \
          '$\left. \frac{\delta u_y}{\delta x} \right|_{i+\frac{1}{2}, j+\frac{1}{2}}$', \
        ]
        array vel_labels[3] = [ \
          '$\left. u_y \right|_{i-1,j+\frac{1}{2}}$', \
          '$\left. u_y \right|_{i  ,j+\frac{1}{2}}$', \
          '$\left. u_y \right|_{i+1,j+\frac{1}{2}}$', \
        ]
      }else{
        array grid_size_labels[2] = [ \
          '$\Delta y$', \
          '$\Delta y$', \
        ]
        array lij_labels[2] = [ \
          '$\left. \frac{\delta u_x}{\delta y} \right|_{i+\frac{1}{2}, j-\frac{1}{2}}$', \
          '$\left. \frac{\delta u_x}{\delta y} \right|_{i+\frac{1}{2}, j+\frac{1}{2}}$', \
        ]
        array vel_labels[3] = [ \
          '$\left. u_x \right|_{i+\frac{1}{2},j-1}$', \
          '$\left. u_x \right|_{i+\frac{1}{2},j  }$', \
          '$\left. u_x \right|_{i+\frac{1}{2},j+1}$', \
        ]
      }
    }else{
      # top labels
      set label 'Code' center at graph 0.75, graph 0.92
      # origin
      ox = 8.25
      oy = 0.75
      if(case eq 'yx'){
        array grid_size_labels[2] = [ \
          '$DXC \left( i   \right)$', \
          '$DXC \left( i+1 \right)$', \
        ]
        array lij_labels[2] = [ \
          'duydx\_xm', \
          'duydx\_xp', \
        ]
        array vel_labels[3] = [ \
          '$UY \left( i-1, j  \right)$', \
          '$UY \left( i  , j  \right)$', \
          '$UY \left( i+1, j  \right)$', \
        ]
      }else{
        array grid_size_labels[2] = [ \
          '$dy$', \
          '$dy$', \
        ]
        array lij_labels[2] = [ \
          'duxdy\_ym', \
          'duxdy\_yp', \
        ]
        array vel_labels[3] = [ \
          '$UX \left( i, j-1 \right)$', \
          '$UX \left( i, j   \right)$', \
          '$UX \left( i, j+1 \right)$', \
        ]
      }
    }
    # grid edges (vertical)
    do for[i=1:4:1] {
      set arrow from first ox+xf[i], first oy+yc[1] to first ox+xf[i], first oy+yc[2] as 1
    }
    # grid edges (horizontal)
    set arrow from first ox+xf[1], first oy+yf to first ox+xf[4], first oy+yf as 1
    # grid size arrows
    do for [i=1:2:1] {
      set arrow from first ox+xc[i], first oy-1.*al to first ox+xc[i+1], first oy-1.*al as 3
    }
    # cell corner markers
    do for [i=2:3:1] {
      set object circle center first ox+xf[i], first oy+yf size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
    # velocity arrows
    do for [i=1:3:1] {
      set arrow from first ox+xc[i], first oy+yf-al to first ox+xc[i], first oy+yf+al as 2
    }
    # labels
    do for [i=1:2:1] {
      set label grid_size_labels[i] center at first ox+0.5*(xc[i]+xc[i+1]), first oy-2.*al
      set label lij_labels[i]       center at first ox+0.5*(xc[i]+xc[i+1]), first oy+yf-1.*al front
    }
    do for [i=1:3:1] {
      set label vel_labels[i] center at first ox+xc[i], first oy+yf+1.*al front
    }
  }
  plot \
    NaN notitle
}

### adv_x_x and adv_y_y
do for [case in 'x_x y_y'] {
  reset
  set terminal epslatex standalone color size 12,4 font ',17'
  set output sprintf('update_velocity_adv_%s.tex', case)
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
  if(case eq 'x_x'){
    set style line 2 lc rgb '#FF0000' lw 10
  }else{
    set style line 2 lc rgb '#0000FF' lw 10
  }
  set style line 3 lc rgb '#000000' lw 5
  set style arrow 1 nohead front ls 1
  set style arrow 2 head  size 0.2,10 filled front ls 2
  set style arrow 3 heads size 0.2,10 filled front ls 3
  al = 0.25
  if(case eq 'x_x'){
    array xf[3] = [0., 2.,   4.5]
  }else{
    array xf[3] = [0., 2.25, 4.5]
  }
  array yf[2] = [0., 2.]
  array xc[2]
  do for[i=1:2:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  yc = 0.5*(yf[1]+yf[2])
  ## left-right
  do for [lr=1:2:1] {
    if(lr == 1){
      # top labels
      set label 'Math' center at graph 0.25, graph 0.92
      # origin
      ox = 0.75
      oy = 0.75
      # labels
      if(case eq 'x_x'){
        array grid_size_labels[2] = [ \
          '$\Delta x_{i  }$', \
          '$\Delta x_{i+1}$', \
        ]
        grid_size_label_2 = '$\Delta x_{i+\frac{1}{2}}$'
        array lij_labels[2] = [ \
          '$\left. \frac{\delta u_x}{\delta x} \right|_{i  , j}$', \
          '$\left. \frac{\delta u_x}{\delta x} \right|_{i+1, j}$', \
        ]
        array vel_labels[3] = [ \
          '$\left. u_x \right|_{i-\frac{1}{2},j}$', \
          '$\left. u_x \right|_{i+\frac{1}{2},j}$', \
          '$\left. u_x \right|_{i+\frac{3}{2},j}$', \
        ]
      }else{
        array grid_size_labels[2] = [ \
          '$\Delta y$', \
          '$\Delta y$', \
        ]
        grid_size_label_2 = '$\Delta y$'
        array lij_labels[2] = [ \
          '$\left. \frac{\delta u_y}{\delta y} \right|_{i, j  }$', \
          '$\left. \frac{\delta u_y}{\delta y} \right|_{i, j+1}$', \
        ]
        array vel_labels[3] = [ \
          '$\left. u_y \right|_{i,j-\frac{1}{2}}$', \
          '$\left. u_y \right|_{i,j+\frac{1}{2}}$', \
          '$\left. u_y \right|_{i,j+\frac{3}{2}}$', \
        ]
      }
    }else{
      # top labels
      set label 'Code' center at graph 0.75, graph 0.92
      # origin
      ox = 6.75
      oy = 0.75
      # labels
      if(case eq 'x_x'){
        array grid_size_labels[2] = [ \
          '$DXF \left( i-1 \right)$', \
          '$DXF \left( i   \right)$', \
        ]
        grid_size_label_2 = '$DXC \left( i \right)$'
        array lij_labels[2] = [ \
          'duxdx\_xm', \
          'duxdx\_xp', \
        ]
        array vel_labels[3] = [ \
          '$UX \left( i-1, j \right)$', \
          '$UX \left( i  , j \right)$', \
          '$UX \left( i+1, j \right)$', \
        ]
      }else{
        array grid_size_labels[2] = [ \
          '$dy$', \
          '$dy$', \
        ]
        grid_size_label_2 = '$dy$'
        array lij_labels[2] = [ \
          'duydy\_ym', \
          'duydy\_yp', \
        ]
        array vel_labels[3] = [ \
          '$UY \left( i, j-1 \right)$', \
          '$UY \left( i, j   \right)$', \
          '$UY \left( i, j+1 \right)$', \
        ]
      }
    }
    # grid edges (vertical)
    do for[i=1:3:1] {
      set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
    }
    # grid edges (horizontal)
    do for[j=1:2:1] {
      set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[3], first oy+yf[j] as 1
    }
    # grid size arrows
    do for [i=1:2:1] {
      set arrow from first ox+xf[i], first oy-1.*al to first ox+xf[i+1], first oy-1.*al as 3
    }
    set arrow from first ox+xc[1], first oy-3.*al to first ox+xc[2], first oy-3.*al as 3
    # cell center markers
    do for [i=1:2:1] {
      set object circle center first ox+xc[i], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
    # velocity arrows
    do for [i=1:3:1] {
      set arrow from first ox+xf[i]-al, first oy+yc to first ox+xf[i]+al, first oy+yc as 2
    }
    # labels
    do for [i=1:2:1] {
      set label grid_size_labels[i] center at first ox+xc[i], first oy-2.*al
      set label lij_labels[i]       center at first ox+xc[i], first oy+yc-1.*al front
    }
    do for [i=1:3:1] {
      set label vel_labels[i] center at first ox+xf[i], first oy+yc+1.*al front
    }
    set label grid_size_label_2 center at first ox+0.5*(xc[1]+xc[2]), first oy-4.*al
  }
  plot \
    NaN notitle
}

### adv_x_y and adv_y_x
do for [case in 'x_y y_x'] {
  reset
  if(case eq 'x_y'){
    set terminal epslatex standalone color size 13,8   font ',17'
  }else{
    set terminal epslatex standalone color size 13,7.5 font ',17'
  }
  set output sprintf('update_velocity_adv_%s.tex', case)
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:13]
  if(case eq 'x_y'){
    set yrange [-0.5:7.5]
  }else{
    set yrange [0.:7.5]
  }
  unset xtics
  unset ytics
  set format x ''
  set format y ''
  set style line 1 lc rgb '#888888' lw 5
  if(case eq 'x_y'){
    set style line 2 lc rgb '#0000FF' lw 10
  }else{
    set style line 2 lc rgb '#FF0000' lw 10
  }
  set style line 3 lc rgb '#000000' lw 5
  set style arrow 1 nohead front ls 1
  set style arrow 2 head  size 0.2,10 filled front ls 2
  set style arrow 3 heads size 0.2,10 filled front ls 3
  al = 0.25
  if(case eq 'x_y'){
    array xf[3] = [0., 2.,   4.5]
    array yf[4] = [0., 2., 4., 6.]
  }else{
    array xf[3] = [0., 2.25, 4.5]
    array yf[4] = [0., 1.5, 3.5, 6.]
  }
  array xc[2]
  do for[i=1:2:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  array yc[3]
  do for[j=1:3:1] {
    yc[j] = 0.5*(yf[j]+yf[j+1])
  }
  ## left-right
  do for [lr=1:2:1] {
    if(lr == 1){
      # top labels
      set label 'Math' center at graph 0.25, graph 0.92
      # origin
      ox = 0.75
      oy = 0.75
      # labels
      if(case eq 'x_y'){
        array grid_size_labels_1[2] = [ \
          '$\Delta x_{i  }$', \
          '$\Delta x_{i+1}$', \
        ]
        array grid_size_labels_2[2] = [ \
          '$\Delta y$', \
          '$\Delta y$', \
        ]
        grid_size_labels_3 = '$\Delta y$'
        grid_size_labels_4 = '$\Delta x_{i+\frac{1}{2}}$'
        array lij_labels[2] = [ \
          '$\left. \frac{\delta u_x}{\delta y} \right|_{i+\frac{1}{2}, j-\frac{1}{2}}$', \
          '$\left. \frac{\delta u_x}{\delta y} \right|_{i+\frac{1}{2}, j+\frac{1}{2}}$', \
        ]
        array vel_labels_1[2] = [ \
          '$\left. u_y \right|_{i  ,j-\frac{1}{2}}$', \
          '$\left. u_y \right|_{i+1,j-\frac{1}{2}}$', \
        ]
        array vel_labels_2[2] = [ \
          '$\left. u_y \right|_{i  ,j+\frac{1}{2}}$', \
          '$\left. u_y \right|_{i+1,j+\frac{1}{2}}$', \
        ]
      }else{
        array grid_size_labels_1[2] = [ \
          '$\Delta y$', \
          '$\Delta y$', \
        ]
        array grid_size_labels_2[2] = [ \
          '$\Delta x_{i-\frac{1}{2}}$', \
          '$\Delta x_{i+\frac{1}{2}}$', \
        ]
        grid_size_labels_3 = '$\Delta x_{i  }$'
        array lij_labels[2] = [ \
          '$\left. \frac{\delta u_y}{\delta x} \right|_{i-\frac{1}{2}, j+\frac{1}{2}}$', \
          '$\left. \frac{\delta u_y}{\delta x} \right|_{i+\frac{1}{2}, j+\frac{1}{2}}$', \
        ]
        array vel_labels_1[3] = [ \
          '$\left. u_x \right|_{i-\frac{1}{2},j  }$', \
          '$\left. u_x \right|_{i-\frac{1}{2},j+1}$', \
        ]
        array vel_labels_2[3] = [ \
          '$\left. u_x \right|_{i+\frac{1}{2},j  }$', \
          '$\left. u_x \right|_{i+\frac{1}{2},j+1}$', \
        ]
      }
    }else{
      # top labels
      set label 'Code' center at graph 0.75, graph 0.92
      # origin
      ox = 7.25
      oy = 0.75
      # labels
      if(case eq 'x_y'){
        array grid_size_labels_1[2] = [ \
          '$DXF \left( i-1 \right)$', \
          '$DXF \left( i   \right)$', \
        ]
        array grid_size_labels_2[2] = [ \
          '$dy$', \
          '$dy$', \
        ]
        grid_size_labels_3 = '$dy$'
        grid_size_labels_4 = '$DXC \left( i  \right)$'
        array lij_labels[2] = [ \
          'duxdy\_ym', \
          'duxdy\_yp', \
        ]
        array vel_labels_1[2] = [ \
          '$UY \left( i-1, j   \right)$', \
          '$UY \left( i  , j   \right)$', \
        ]
        array vel_labels_2[2] = [ \
          '$UY \left( i-1, j+1 \right)$', \
          '$UY \left( i  , j+1 \right)$', \
        ]
      }else{
        array grid_size_labels_1[2] = [ \
          '$dy$', \
          '$dy$', \
        ]
        array grid_size_labels_2[2] = [ \
          '$DXC \left( i   \right)$', \
          '$DXC \left( i+1 \right)$', \
        ]
        grid_size_labels_3 = '$DXF \left( i \right)$'
        array lij_labels[2] = [ \
          'duydx\_xm', \
          'duydx\_xp', \
        ]
        array vel_labels_1[3] = [ \
          '$UX \left( i  , j-1 \right)$', \
          '$UX \left( i  , j   \right)$', \
        ]
        array vel_labels_2[3] = [ \
          '$UX \left( i+1, j-1 \right)$', \
          '$UX \left( i+1, j   \right)$', \
        ]
      }
    }
    # grid edges (vertical)
    do for[i=1:3:1] {
      set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[4] as 1
    }
    # grid edges (horizontal)
    do for[j=1:4:1] {
      set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[3], first oy+yf[j] as 1
    }
    # grid size arrows (horizontal)
    do for [i=1:2:1] {
      set arrow from first ox+xf[i], first oy-1.*al to first ox+xf[i+1], first oy-1.*al as 3
    }
    if(case eq 'x_y'){
      set arrow from first ox+xc[1], first oy-3.*al to first ox+xc[2], first oy-3.*al as 3
    }
    # grid size arrows (vertical)
    do for [j=1:2:1] {
      set arrow from first ox+xf[3]+1.*al, first oy+yc[j] to first ox+xf[3]+1.*al, first oy+yc[j+1] as 3
    }
    set arrow from first ox+xf[3]+3.*al, first oy+yf[2] to first ox+xf[3]+3.*al, first oy+yf[3] as 3
    # cell corner markers
    do for [j=2:3:1] {
      set object circle center first ox+xf[2], first oy+yf[j] size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
    # velocity arrows
    do for [i=1:2:1] {
      do for [j=2:3:1] {
        set arrow from first ox+xc[i], first oy+yf[j]-al to first ox+xc[i], first oy+yf[j]+al as 2
      }
    }
    # labels
    do for [i=1:2:1] {
      set label grid_size_labels_1[i] center at first ox+xc[i], first oy-2.*al
    }
    do for [j=1:2:1] {
      set label grid_size_labels_2[j] center at first ox+xf[3]+2.*al, first oy+0.5*(yc[j]+yc[j+1]) rotate by 90
    }
    set label grid_size_labels_3 center at first ox+xf[3]+4.*al, first oy+yc[2] rotate by 90
    if(case eq 'x_y'){
      set label grid_size_labels_4 center at first ox+0.5*(xc[1]+xc[2]), first oy-4.*al
    }
    do for [j=1:2:1] {
      set label lij_labels[j] center at first ox+xf[2], first oy+yf[j+1]-1.*al front
    }
    do for [i=1:2:1] {
      set label vel_labels_1[i] center at first ox+xc[i], first oy+yf[2]+1.*al front
      set label vel_labels_2[i] center at first ox+xc[i], first oy+yf[3]+1.*al front
    }
  }
  plot \
    NaN notitle
}

### dif_x_x and dif_y_y
do for [case in 'x_x y_y'] {
  reset
  set terminal epslatex standalone color size 12,3.5 font ',17'
  set output sprintf('update_velocity_dif_%s.tex', case)
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
  if(case eq 'x_x'){
    set style line 2 lc rgb '#FF0000' lw 10
  }else{
    set style line 2 lc rgb '#0000FF' lw 10
  }
  set style line 3 lc rgb '#000000' lw 5
  set style arrow 1 nohead front ls 1
  set style arrow 2 head  size 0.2,10 filled front ls 2
  set style arrow 3 heads size 0.2,10 filled front ls 3
  al = 0.25
  if(case eq 'x_x'){
    array xf[3] = [0., 2.,   4.5]
  }else{
    array xf[3] = [0., 2.25, 4.5]
  }
  array yf[2] = [0., 2.]
  array xc[2]
  do for[i=1:2:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  yc = 0.5*(yf[1]+yf[2])
  ## left-right
  do for [lr=1:2:1] {
    if(lr == 1){
      # top labels
      set label 'Math' center at graph 0.25, graph 0.92
      # origin
      ox = 0.75
      oy = 0.75
      # labels
      if(case eq 'x_x'){
        grid_size_label = '$\Delta x_{i+\frac{1}{2}}$'
        array lij_labels[2] = [ \
          '$\left. \frac{\delta u_x}{\delta x} \right|_{i  , j}$', \
          '$\left. \frac{\delta u_x}{\delta x} \right|_{i+1, j}$', \
        ]
      }else{
        grid_size_label = '$\Delta y$'
        array lij_labels[2] = [ \
          '$\left. \frac{\delta u_y}{\delta y} \right|_{i, j  }$', \
          '$\left. \frac{\delta u_y}{\delta y} \right|_{i, j+1}$', \
        ]
      }
    }else{
      # top labels
      set label 'Code' center at graph 0.75, graph 0.92
      # origin
      ox = 6.75
      oy = 0.75
      # labels
      if(case eq 'x_x'){
        grid_size_label = '$DXC \left( i \right)$'
        array lij_labels[2] = [ \
          'duxdx\_xm', \
          'duxdx\_xp', \
        ]
      }else{
        grid_size_label = '$dy$'
        array lij_labels[2] = [ \
          'duydy\_ym', \
          'duydy\_yp', \
        ]
      }
    }
    # grid edges (vertical)
    do for[i=1:3:1] {
      set arrow from first ox+xf[i], first oy+yf[1] to first ox+xf[i], first oy+yf[2] as 1
    }
    # grid edges (horizontal)
    do for[j=1:2:1] {
      set arrow from first ox+xf[1], first oy+yf[j] to first ox+xf[3], first oy+yf[j] as 1
    }
    # grid size arrow
    set arrow from first ox+xc[1], first oy-1.*al to first ox+xc[2], first oy-1.*al as 3
    # cell center markers
    do for [i=1:2:1] {
      set object circle center first ox+xc[i], first oy+yc size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
    # labels
    set label grid_size_label center at first ox+0.5*(xc[1]+xc[2]), first oy-2.*al
    do for [i=1:2:1] {
      set label lij_labels[i]       center at first ox+xc[i], first oy+yc-1.*al front
    }
  }
  plot \
    NaN notitle
}

### dif_x_y and dif_y_x
do for [case in 'x_y y_x'] {
  reset
  set terminal epslatex standalone color size 12,3.5 font ',17'
  set output sprintf('update_velocity_dif_%s.tex', case)
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
  if(case eq 'xy'){
    set style line 2 lc rgb '#FF0000' lw 10
  }else{
    set style line 2 lc rgb '#0000FF' lw 10
  }
  set style line 3 lc rgb '#000000' lw 5
  set style arrow 1 nohead front ls 1
  set style arrow 2 head  size 0.2,10 filled front ls 2
  set style arrow 3 heads size 0.2,10 filled front ls 3
  al = 0.25
  if(case eq 'y_x'){
    array xf[4] = [0., 1.5, 3.5, 6.0]
  }else{
    array xf[4] = [0., 2.0, 4.0, 6.0]
  }
  array yc[2] = [0., 2.]
  array xc[3]
  do for[i=1:3:1] {
    xc[i] = 0.5*(xf[i]+xf[i+1])
  }
  yf = 0.5*(yc[1]+yc[2])
  ## left-right
  do for [lr=1:2:1] {
    if(lr == 1){
      # top labels
      set label 'Math' center at graph 0.25, graph 0.92
      # origin
      ox = 0.75
      oy = 0.75
      # labels
      if(case eq 'y_x'){
        grid_size_label = '$\Delta x_i$'
        array lij_labels[2] = [ \
          '$\left. \frac{\delta u_y}{\delta x} \right|_{i-\frac{1}{2}, j+\frac{1}{2}}$', \
          '$\left. \frac{\delta u_y}{\delta x} \right|_{i+\frac{1}{2}, j+\frac{1}{2}}$', \
        ]
      }else{
        grid_size_label = '$\Delta y$'
        array lij_labels[2] = [ \
          '$\left. \frac{\delta u_x}{\delta y} \right|_{i+\frac{1}{2}, j-\frac{1}{2}}$', \
          '$\left. \frac{\delta u_x}{\delta y} \right|_{i+\frac{1}{2}, j+\frac{1}{2}}$', \
        ]
      }
    }else{
      # top labels
      set label 'Code' center at graph 0.75, graph 0.92
      # origin
      ox = 8.25
      oy = 0.75
      if(case eq 'y_x'){
        grid_size_label = '$DXF \left( i \right)$'
        array lij_labels[2] = [ \
          'duydx\_xm', \
          'duydx\_xp', \
        ]
      }else{
        grid_size_label = '$dy$'
        array lij_labels[2] = [ \
          'duxdy\_ym', \
          'duxdy\_yp', \
        ]
      }
    }
    # grid edges (vertical)
    do for[i=1:4:1] {
      set arrow from first ox+xf[i], first oy+yc[1] to first ox+xf[i], first oy+yc[2] as 1
    }
    # grid edges (horizontal)
    set arrow from first ox+xf[1], first oy+yf to first ox+xf[4], first oy+yf as 1
    # grid size arrow
    set arrow from first ox+xf[2], first oy-1.*al to first ox+xf[3], first oy-1.*al as 3
    # cell corner markers
    do for [i=2:3:1] {
      set object circle center first ox+xf[i], first oy+yf size first 0.125*al fs solid 1.0 fc rgb '#888888' lw 3
    }
    # labels
    set label grid_size_label center at first ox+0.5*(xf[2]+xf[3]), first oy-2.*al
    do for [i=1:2:1] {
      set label lij_labels[i]       center at first ox+0.5*(xc[i]+xc[i+1]), first oy+yf-1.*al front
    }
  }
  plot \
    NaN notitle
}

## domain decomposition ux
reset
{
  lx = 7.
  ly = 11.
  #
  set terminal epslatex standalone color size 2*lx+6.,ly+2. font ',20'
  set output 'update_velocity_domain_decomp_x.tex'
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

## domain decomposition uy
reset
{
  lx = 7.
  ly = 11.
  #
  set terminal epslatex standalone color size 2*lx+6.,ly+2. font ',20'
  set output 'update_velocity_domain_decomp_y.tex'
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

