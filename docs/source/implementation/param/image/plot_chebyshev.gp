
itot = 8

xf(stretch, x) = cos(pi*(1.*(x-1)+stretch)/(itot+2.*stretch))

reset
{
  set terminal epslatex standalone color size 5.0,3.5 font ',12'
  set output 'chebyshev.tex'
  set xlabel '$i$'
  set ylabel '$XF \left( i \right)$'
  set xrange [1:itot+1]
  set yrange [-1:1]
  set xtics 1
  set ytics 0.5
  set format x '$% .0f$'
  set format y '$% .1f$'
  set style line 1 lc rgb '#FF0000' lw 5
  set style line 2 lc rgb '#0000FF' lw 5
  set style line 3 lc rgb '#33AA00' lw 5
  plot \
    xf(0, x) t 'str = $0$' ls 1 w l, \
    xf(2, x) t 'str = $2$' ls 2 w l, \
    xf(4, x) t 'str = $4$' ls 3 w l
}

