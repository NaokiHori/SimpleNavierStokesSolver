reset
{
  set terminal epslatex color standalone header '\usepackage{amsmath}' size 16,6 font ',20'
  set output 'halo1.tex'
  unset border
  set noxtics
  set noytics
  set size ratio -1.
  set xrange [-1.5:14.5]
  set yrange [-3.0: 3.0]
  set linestyle 1 lw 10 lc rgb '#000000'
  set style arrow 1 nohead ls 1
# shadow
# lower process
  set object rectangle from first  1,-1.5 to first 10, -2.5 fc rgb '#FF0000' fillstyle solid 0.25 border lc rgb '#FF0000' back
  set object rectangle from first  0,-0.5 to first  1, -2.5 fc rgb '#AAAAAA' fillstyle solid 1.00 border lc rgb '#AAAAAA' back
  set object rectangle from first 10,-0.5 to first 11, -2.5 fc rgb '#AAAAAA' fillstyle solid 1.00 border lc rgb '#AAAAAA' back
# upper process
  set object rectangle from first  1,1.5 to first 10, 2.5 fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#0000FF' back
  set object rectangle from first  0,0.5 to first  1, 2.5 fc rgb '#AAAAAA' fillstyle solid 1.00 border lc rgb '#AAAAAA' back
  set object rectangle from first 10,0.5 to first 11, 2.5 fc rgb '#AAAAAA' fillstyle solid 1.00 border lc rgb '#AAAAAA' back
# 9 3x3 grids
  do for [x0=0:8:4] {
    do for [i=0:3] {
      set arrow from first x0+i,0.5   to first x0+i,2.5   as 1
    }
    do for [j=0:2] {
      set arrow from first x0+0,j+0.5 to first x0+3,j+0.5 as 1
    }
  }
  do for [x0=0:8:4] {
    do for [i=0:3] {
      set arrow from first x0+i,-0.5   to first x0+i,-2.5   as 1
    }
    do for [j=0:2] {
      set arrow from first x0+0,-j-0.5 to first x0+3,-j-0.5 as 1
    }
  }
# velocity arrows
  arrlngt = 0.25
  set style line 2 lc rgb '#FF0000' lw 10
  set style arrow 2 head size 0.2,10 filled front ls 2
# ux
  do for [y0=-2:2] {
    if(y0 != 0){
      do for [x0=1:10] {
        set arrow from first x0-arrlngt,y0 to first x0+arrlngt,y0 as 2
      }
    }
  }
# index labels
# x
  set label '$1$'       at first  1.0, 2.75 center
  set label '$2$'       at first  2.0, 2.75 center
  set label '$3$'       at first  3.0, 2.75 center
  set label '$i-1$'     at first  4.0, 2.75 center
  set label '$i$'       at first  5.0, 2.75 center
  set label '$i+1$'     at first  6.0, 2.75 center
  set label '$i+2$'     at first  7.0, 2.75 center
  set label '$itot-1$'  at first  8.0, 2.75 center
  set label '$itot$'    at first  9.0, 2.75 center
  set label '$itot+1$'  at first 10.0, 2.75 center
# y
  set label '$jsize$'   at first -1.0, -2.0 center
  set label '$jsize+1$' at first -1.0, -1.0 center
  set label '$0$'       at first -1.0,  1.0 center
  set label '$1$'       at first -1.0,  2.0 center
# exchange arrows
  set style line 3 lc rgb '#000000' lw 10
  set style arrow 3 head size 0.3,15 filled front ls 3
  set style arrow 4 nohead front ls 3
# from upper to lower
  set arrow from first 11.5,  2. to first 12.0,  2. as 4
  set arrow from first 12.0,  2. to first 12.0, -1. as 4
  set arrow from first 12.0, -1. to first 11.5, -1. as 3
# from upper to lower
  set arrow from first 11.5, -2. to first 12.5, -2. as 4
  set arrow from first 12.5, -2. to first 12.5,  1. as 4
  set arrow from first 12.5,  1. to first 11.5,  1. as 3
# process
  set label 'lower process'   left at first 13.0, -1.5
  set label 'current process' left at first 13.0,  1.5
  plot \
    NaN notitle
}

reset
{
  set terminal epslatex color standalone header '\usepackage{amsmath}' size 16,6 font ',20'
  set output 'halo2.tex'
  unset border
  set noxtics
  set noytics
  set size ratio -1.
  set xrange [-1.5:14.5]
  set yrange [-3.0: 3.0]
  set linestyle 1 lw 10 lc rgb '#000000'
  set style arrow 1 nohead ls 1
# shadow
# lower process
  set object rectangle from first  1,-1.5 to first 10, -2.5 fc rgb '#0000FF' fillstyle solid 0.25 border lc rgb '#0000FF' back
  set object rectangle from first  0,-0.5 to first  1, -2.5 fc rgb '#AAAAAA' fillstyle solid 1.00 border lc rgb '#AAAAAA' back
  set object rectangle from first 10,-0.5 to first 11, -2.5 fc rgb '#AAAAAA' fillstyle solid 1.00 border lc rgb '#AAAAAA' back
# upper process
  set object rectangle from first  1,1.5 to first 10, 2.5 fc rgb '#33AA00' fillstyle solid 0.25 border lc rgb '#33AA00' back
  set object rectangle from first  0,0.5 to first  1, 2.5 fc rgb '#AAAAAA' fillstyle solid 1.00 border lc rgb '#AAAAAA' back
  set object rectangle from first 10,0.5 to first 11, 2.5 fc rgb '#AAAAAA' fillstyle solid 1.00 border lc rgb '#AAAAAA' back
# 9 3x3 grids
  do for [x0=0:8:4] {
    do for [i=0:3] {
      set arrow from first x0+i,0.5   to first x0+i,2.5   as 1
    }
    do for [j=0:2] {
      set arrow from first x0+0,j+0.5 to first x0+3,j+0.5 as 1
    }
  }
  do for [x0=0:8:4] {
    do for [i=0:3] {
      set arrow from first x0+i,-0.5   to first x0+i,-2.5   as 1
    }
    do for [j=0:2] {
      set arrow from first x0+0,-j-0.5 to first x0+3,-j-0.5 as 1
    }
  }
# velocity arrows
  arrlngt = 0.25
  set style line 2 lc rgb '#FF0000' lw 10
  set style arrow 2 head size 0.2,10 filled front ls 2
# ux
  do for [y0=-2:2] {
    if(y0 != 0){
      do for [x0=1:10] {
        set arrow from first x0-arrlngt,y0 to first x0+arrlngt,y0 as 2
      }
    }
  }
# index labels
# x
  set label '$1$'       at first  1.0, 2.75 center
  set label '$2$'       at first  2.0, 2.75 center
  set label '$3$'       at first  3.0, 2.75 center
  set label '$i-1$'     at first  4.0, 2.75 center
  set label '$i$'       at first  5.0, 2.75 center
  set label '$i+1$'     at first  6.0, 2.75 center
  set label '$i+2$'     at first  7.0, 2.75 center
  set label '$itot-1$'  at first  8.0, 2.75 center
  set label '$itot$'    at first  9.0, 2.75 center
  set label '$itot+1$'  at first 10.0, 2.75 center
# y
  set label '$jsize$'   at first -1.0, -2.0 center
  set label '$jsize+1$' at first -1.0, -1.0 center
  set label '$0$'       at first -1.0,  1.0 center
  set label '$1$'       at first -1.0,  2.0 center
# exchange arrows
  set style line 3 lc rgb '#000000' lw 10
  set style arrow 3 head size 0.3,15 filled front ls 3
  set style arrow 4 nohead front ls 3
# from upper to lower
  set arrow from first 11.5,  2. to first 12.0,  2. as 4
  set arrow from first 12.0,  2. to first 12.0, -1. as 4
  set arrow from first 12.0, -1. to first 11.5, -1. as 3
# from upper to lower
  set arrow from first 11.5, -2. to first 12.5, -2. as 4
  set arrow from first 12.5, -2. to first 12.5,  1. as 4
  set arrow from first 12.5,  1. to first 11.5,  1. as 3
# process
  set label 'current process' left at first 13.0, -1.5
  set label 'upper   process' left at first 13.0,  1.5
  plot \
    NaN notitle
}

