reset
{
  set terminal epslatex standalone color size 5.,3.5 font ',14'
  set output 'divergence.tex'
  set xlabel '$t$'
  set ylabel 'maximum divergence'
  set logscale y
  set xrange [100.:200.]
  set yrange [1.e-16:1.e-12]
  set xtics 50.
  set ytics 10.
  set format x '$% .0f$'
  set format y '$10^{%L}$'
  set style line 1 lc rgb '#FF0000' lw 5
  filename = 'artifacts/log/divergence.dat'
  plot \
    filename u 1:2 notitle ls 1 w l
}

reset
{
  set terminal epslatex standalone color size 5.,3.5 font ',14'
  set output 'nusselt.tex'
  set xlabel '$t$'
  set ylabel '$Nu$'
  set xrange [100.:200.]
  set yrange [10.:50.]
  set xtics 50.
  set ytics 10.
  set format x '$% .0f$'
  set format y '$% .0f$'
  set style line 1 lc rgb '#FF0000' lw 5
  set style line 2 lc rgb '#0000FF' lw 5
  set style line 3 lc rgb '#33AA00' lw 5
  set style line 4 lc rgb '#FF00FF' lw 5
  set style line 5 lc rgb '#000000' lw 5 dt 2
  set key right bottom
  filename = 'artifacts/log/nusselt.dat'
  # van der Poel et al., JFM, 2013
  refval = 27.25
  plot \
    filename u 1:2 notitle ls 1 w l, \
    filename u 1:3 notitle ls 2 w l, \
    filename u 1:4 notitle ls 3 w l, \
    filename u 1:5 notitle ls 4 w l, \
    refval notitle ls 5 w l
}

reset
{
  set terminal epslatex standalone color size 5.,3.5 font ',14'
  set output 'stat.tex'
  set xlabel '$x$'
  set ylabel '$\sigma \left( q \right)$'
  set xrange [0.:0.5]
  set yrange [0.:0.2]
  set xtics 0.1
  set ytics 0.05
  set format x '$% .1f$'
  set format y '$% .2f$'
  set style line 1 lc rgb '#FF0000' lw 5
  set style line 2 lc rgb '#0000FF' lw 5
  set style line 3 lc rgb '#33AA00' lw 5
  plot \
    'stat/ux.dat'   u 1:3 notitle ls 1 w l, \
    'stat/uy.dat'   u 1:3 notitle ls 2 w l, \
    'stat/temp.dat' u 1:3 notitle ls 3 w l
}

