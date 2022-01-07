ox = 0.5
oy = 0.75
lx = 7.
ly = 1.

numx = 11
str = 0.15
array xf[numx+1]
xf[1] = ox
do for [i=1:numx:1] {
  xf[i+1] = xf[i] + lx/numx*(1.-str*cos(2.*pi*(2*i-1)/(2*numx)))
}

reset
{
  set terminal epslatex standalone color size 8,2 font ',8'
  set output 'grid1.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:8]
  set yrange [0:2]
  unset xtics
  unset ytics
  set format x ''
  set format y ''
  set style line 1 lc rgb '#888888' lw 5
  set style line 2 lc rgb '#888888' lw 5 dt 2
  set style line 3 lc rgb '#FF0000' lw 5
  set style arrow 1 nohead front ls 1
  set style arrow 2 nohead front ls 2
  set style arrow 3 nohead front ls 3
  array strings[numx+1] = [ \
    '$XF \left( 1 \right)$', \
    '$XF \left( 2 \right)$', \
    '$XF \left( 3 \right)$', \
    '$XF \left( 4 \right)$', \
    '$XF \left( i-1 \right)$', \
    '$XF \left( i   \right)$', \
    '$XF \left( i+1 \right)$', \
    '$XF \left( i+2 \right)$', \
    '$XF \left( itot-2 \right)$', \
    '$XF \left( itot-1 \right)$', \
    '$XF \left( itot   \right)$', \
    '$XF \left( itot+1 \right)$' \
  ]
  # vertical lines
  do for [i=1:numx+1:1] {
    set arrow from first xf[i], first oy to first xf[i], first oy+ly as 3
  }
  # horizontal lines
  do for [i=1:numx:1] {
    # horizontal line
    if(i == 4 || i == 8){
      set arrow from first xf[i], first oy    to first xf[i+1], first oy    as 2
      set arrow from first xf[i], first oy+ly to first xf[i+1], first oy+ly as 2
    }else{
      set arrow from first xf[i], first oy    to first xf[i+1], first oy    as 1
      set arrow from first xf[i], first oy+ly to first xf[i+1], first oy+ly as 1
    }
  }
  # labels
  do for [i=1:numx+1:1] {
    if(i % 2 == 0){
      set label strings[i] center at first xf[i], first oy-0.15
    }else{
      set label strings[i] center at first xf[i], first oy-0.45
    }
  }
  plot \
    NaN notitle
}

reset
{
  set terminal epslatex standalone color size 8,2 font ',8'
  set output 'grid2.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:8]
  set yrange [0:2]
  unset xtics
  unset ytics
  set format x ''
  set format y ''
  set style line 1 lc rgb '#888888' lw 5
  set style line 2 lc rgb '#888888' lw 5 dt 2
  set style line 3 lc rgb '#FF0000' lw 5
  set style arrow 1 nohead front ls 1
  set style arrow 2 nohead front ls 2
  set style arrow 3 heads size first 0.1,10 filled front ls 3
  array strings[numx] = [ \
    '$DXF \left( 1 \right)$', \
    '$DXF \left( 2 \right)$', \
    '$DXF \left( 3 \right)$', \
    '', \
    '$DXF \left( i-1 \right)$', \
    '$DXF \left( i   \right)$', \
    '$DXF \left( i+1 \right)$', \
    '', \
    '$DXF \left( itot-2 \right)$', \
    '$DXF \left( itot-1 \right)$', \
    '$DXF \left( itot   \right)$' \
  ]
  # vertical lines
  do for [i=1:numx+1:1] {
    set arrow from first xf[i], first oy to first xf[i], first oy+ly as 1
  }
  # horizontal lines
  do for [i=1:numx:1] {
    # horizontal line
    if(i == 4 || i == 8){
      set arrow from first xf[i], first oy    to first xf[i+1], first oy    as 2
      set arrow from first xf[i], first oy+ly to first xf[i+1], first oy+ly as 2
    }else{
      set arrow from first xf[i], first oy    to first xf[i+1], first oy    as 1
      set arrow from first xf[i], first oy+ly to first xf[i+1], first oy+ly as 1
    }
  }
  # labels
  do for [i=1:numx:1] {
    if(i % 2 == 0){
      set label strings[i] center at first 0.5*(xf[i]+xf[i+1]), first oy-0.15
    }else{
      set label strings[i] center at first 0.5*(xf[i]+xf[i+1]), first oy-0.45
    }
    if(i != 4 && i != 8){
      set arrow from first xf[i], first oy+0.5*ly to first xf[i+1], first oy+0.5*ly as 3
    }
  }
  plot \
    NaN notitle
}

reset
{
  set terminal epslatex standalone color size 8,2 font ',8'
  set output 'grid3.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:8]
  set yrange [0:2]
  unset xtics
  unset ytics
  set format x ''
  set format y ''
  set style line 1 lc rgb '#888888' lw 5
  set style line 2 lc rgb '#888888' lw 5 dt 2
  set style line 3 lc rgb '#FF0000' lw 5
  set style arrow 1 nohead front ls 1
  set style arrow 2 nohead front ls 2
  set style arrow 3 nohead front ls 3
  array strings[numx] = [ \
    '$XC \left( 1 \right)$', \
    '$XC \left( 2 \right)$', \
    '$XC \left( 3 \right)$', \
    '', \
    '$XC \left( i-1 \right)$', \
    '$XC \left( i   \right)$', \
    '$XC \left( i+1 \right)$', \
    '', \
    '$XC \left( itot-2 \right)$', \
    '$XC \left( itot-1 \right)$', \
    '$XC \left( itot   \right)$' \
  ]
  # vertical lines
  do for [i=1:numx+1:1] {
    set arrow from first xf[i], first oy to first xf[i], first oy+ly as 1
  }
  # horizontal lines
  do for [i=1:numx:1] {
    # horizontal line
    if(i == 4 || i == 8){
      set arrow from first xf[i], first oy    to first xf[i+1], first oy    as 2
      set arrow from first xf[i], first oy+ly to first xf[i+1], first oy+ly as 2
    }else{
      set arrow from first xf[i], first oy    to first xf[i+1], first oy    as 1
      set arrow from first xf[i], first oy+ly to first xf[i+1], first oy+ly as 1
    }
  }
  # labels and dots
  set label '$XC \left( 0 \right)$' center at first xf[1], first oy-0.15
  set object circle center first xf[1], first oy+0.5*ly size first 1./32. fs solid 1.0 fc rgb '#FF0000' lw 3
  do for [i=1:numx:1] {
    if(i % 2 == 0){
      set label strings[i] center at first 0.5*(xf[i]+xf[i+1]), first oy-0.15
    }else{
      set label strings[i] center at first 0.5*(xf[i]+xf[i+1]), first oy-0.45
    }
    if(i != 4 && i != 8){
      set object circle center first 0.5*(xf[i]+xf[i+1]), first oy+0.5*ly size first 1./32. fs solid 1.0 fc rgb '#FF0000' lw 3
    }
  }
  set label '$XC \left( itot+1 \right)$' center at first xf[numx+1], first oy-0.15
  set object circle center first xf[numx+1], first oy+0.5*ly size first 1./32. fs solid 1.0 fc rgb '#FF0000' lw 3
  plot \
    NaN notitle
}

reset
{
  set terminal epslatex standalone color size 8,2 font ',8'
  set output 'grid4.tex'
  unset border
  set lmargin 0.
  set rmargin 0.
  set bmargin 0.
  set tmargin 0.
  unset xlabel
  unset ylabel
  set xrange [0:8]
  set yrange [0:2]
  unset xtics
  unset ytics
  set format x ''
  set format y ''
  set style line 1 lc rgb '#888888' lw 5
  set style line 2 lc rgb '#888888' lw 5 dt 2
  set style line 3 lc rgb '#FF0000' lw 5
  set style arrow 1 nohead front ls 1
  set style arrow 2 nohead front ls 2
  set style arrow 3 heads size first 0.1,10 filled front ls 3
  array strings = [ \
    '$DXC \left( 1 \right)$', \
    '$DXC \left( 2 \right)$', \
    '$DXC \left( 3 \right)$', \
    '', \
    '', \
    '$DXC \left( i   \right)$', \
    '$DXC \left( i+1 \right)$', \
    '', \
    '', \
    '$DXC \left( itot-1 \right)$', \
    '$DXC \left( itot   \right)$', \
    '$DXC \left( itot+1 \right)$' \
  ]
  # vertical lines
  do for [i=1:numx+1:1] {
    set arrow from first xf[i], first oy to first xf[i], first oy+ly as 1
  }
  # horizontal lines
  do for [i=1:numx:1] {
    # horizontal line
    if(i == 4 || i == 8){
      set arrow from first xf[i], first oy    to first xf[i+1], first oy    as 2
      set arrow from first xf[i], first oy+ly to first xf[i+1], first oy+ly as 2
    }else{
      set arrow from first xf[i], first oy    to first xf[i+1], first oy    as 1
      set arrow from first xf[i], first oy+ly to first xf[i+1], first oy+ly as 1
    }
  }
  # labels
  do for [i=1:numx+1:1] {
    if(i % 2 == 0){
      set label strings[i] center at first xf[i], first oy-0.15
    }else{
      set label strings[i] center at first xf[i], first oy-0.45
    }
  }
  set object circle center first xf[1], first oy+0.5*ly size first 1./32. fs solid 1.0 fc rgb '#000000' lw 3
  do for [i=1:numx:1] {
    if(i != 4 && i != 8){
      set object circle center first 0.5*(xf[i]+xf[i+1]), first oy+0.5*ly size first 1./32. fs solid 1.0 fc rgb '#000000' lw 3
    }
  }
  set object circle center first xf[numx+1], first oy+0.5*ly size first 1./32. fs solid 1.0 fc rgb '#000000' lw 3
  # red arrows
  set arrow from first xf[1], oy+0.5*ly to first 0.5*(xf[1]+xf[2]), oy+0.5*ly as 3
  do for [i=1:numx-1:1] {
    if(i != 3 && i != 4 && i != 7 && i != 8){
      set arrow from first 0.5*(xf[i]+xf[i+1]), oy+0.5*ly to first 0.5*(xf[i+1]+xf[i+2]), oy+0.5*ly as 3
    }
  }
  set arrow from first 0.5*(xf[numx]+xf[numx+1]), oy+0.5*ly to first xf[numx+1], oy+0.5*ly as 3
  plot \
    NaN notitle
}

