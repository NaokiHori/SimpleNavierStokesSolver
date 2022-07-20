
# 1: Pr = 10^{-1}
# 2: Pr = 10^{ 0}
# 3: Pr = 10^{ 1}

array filenames[3] = [ \
  'artifacts/log/nusselt1.dat', \
  'artifacts/log/nusselt2.dat', \
  'artifacts/log/nusselt3.dat'  \
]

reset
{
  set terminal epslatex standalone color size 5.,3.5 font ',14'
  set output 'nusselt_raw.tex'
  set xlabel '$t$'
  set ylabel '$Nu_{wall}$'
  set xrange [0:500]
  set yrange [1.:3.5]
  set xtics 250.
  set ytics 1.
  set format x '$% .0f$'
  set format y '$% .0f$'
  set style line 1 lc rgb '#FF0000' lw 5
  set style line 2 lc rgb '#0000FF' lw 5
  set style line 3 lc rgb '#33AA00' lw 5
  set key right bottom
  plot \
    filenames[1] u 1:2 t '$Pr = 10^{-1}$' ls 1 w l, \
    filenames[2] u 1:2 t '$Pr = 10^{ 0}$' ls 2 w l, \
    filenames[3] u 1:2 t '$Pr = 10^{ 1}$' ls 3 w l
}

reset
{
  do for [case=1:3:1] {
    set terminal epslatex standalone color size 5.,3.5 font ',14'
    set output sprintf('nusselt_dif_%d.tex', case)
    set xlabel '$t$'
    set ylabel '$\left| Nu_{\left\{ \cdot \right\}} - Nu_{wall} \right|$'
    set xrange [0:500]
    set yrange [1.e-16:1.e+0]
    set xtics 250.
    set ytics 1.e4
    set format x '$% .0f$'
    set format y '$10^{%L}$'
    set logscale y
    set style line 1 lc rgb '#FF0000' lw 5
    set style line 2 lc rgb '#0000FF' lw 5
    set style line 3 lc rgb '#33AA00' lw 5
    set key right top
    plot \
      filenames[case] u 1:($3-abs($2)) t '$Nu_{u_x T}$'        ls 1 w l, \
      filenames[case] u 1:($4-abs($2)) t '$Nu_{\epsilon_{k}}$' ls 2 w l, \
      filenames[case] u 1:($5-abs($2)) t '$Nu_{\epsilon_{T}}$' ls 3 w l
  }
}

