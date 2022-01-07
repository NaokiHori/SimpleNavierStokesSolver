reset
{
  set terminal epslatex standalone color size 5.,3.5 font ',14'
  set output 'nusselt_mean.tex'
  set xlabel '$Pr$'
  set ylabel '$Nu$'
  set logscale x
  set xrange [1./sqrt(2.)*1e-1:sqrt(2.)*1e+1]
  set yrange [20.:30.]
  set xtics 10.
  set ytics 5.
  set format x '$10^{%L}$'
  set format y '$% .0f$'
  set style line 1 lc rgb '#FF0000' lw 5
  set style line 2 lc rgb '#0000FF' lw 5
  set key left top
  filename = 'data/nusselt_mean.dat'
  plot \
    filename u 1:2   t 'result'    ls 1 pt 6 ps 3 w lp, \
    filename u 1:2:3 notitle       ls 1    w errorbars, \
    filename u 1:4   t 'reference' ls 2 pt 4 ps 3 w lp
}

reset
{
  set terminal epslatex standalone color size 5.,3.5 font ',14'
  set output 'temp1.tex'
  set xlabel '$x / \delta_T$'
  set ylabel '$T$'
  set logscale x
  set xrange [1.e-3:5.e+0]
  set yrange [0.:0.55]
  set xtics 10.
  set ytics 0.1
  set format x '$10^{%L}$'
  set format y '$% .1f$'
  set style line 1 lc rgb '#FF0000' lw 5
  set style line 2 lc rgb '#0000FF' lw 5
  set style line 3 lc rgb '#33AA00' lw 5
  set key left top
  nu_0 = 23.32
  nu_1 = 25.17
  nu_2 = 27.25
  fname0 = 'data/Pr1e-1_temp.dat'
  fname1 = 'data/Pr1e+0_temp.dat'
  fname2 = 'data/Pr1e+1_temp.dat'
  plot \
    fname0 u ($1*(2.*nu_0)):($2)             notitle ls 1           w l, \
    fname1 u ($1*(2.*nu_1)):($2)             notitle ls 2           w l, \
    fname2 u ($1*(2.*nu_2)):($2)             notitle ls 3           w l, \
    fname0 u ($1*(2.*nu_0)):($2) every ::::5 notitle ls 1 pt 7 ps 2 w p, \
    fname1 u ($1*(2.*nu_1)):($2) every ::::5 notitle ls 2 pt 7 ps 2 w p, \
    fname2 u ($1*(2.*nu_2)):($2) every ::::5 notitle ls 3 pt 7 ps 2 w p
}

reset
{
  set terminal epslatex standalone color size 5.,3.5 font ',14'
  set output 'temp2.tex'
  set xlabel '$x$'
  set ylabel '$\sigma \left( T^{\prime} \right)$'
  set xrange [0.:0.5]
  set yrange [0.:0.2]
  set xtics 0.1
  set ytics 0.1
  set format x '$% .1f$'
  set format y '$% .1f$'
  set style line 1 lc rgb '#FF0000' lw 5
  set style line 2 lc rgb '#0000FF' lw 5
  set style line 3 lc rgb '#33AA00' lw 5
  set key left top
  plot \
    'data/Pr1e-1_temp.dat' u 1:3 notitle ls 1 w l, \
    'data/Pr1e+0_temp.dat' u 1:3 notitle ls 2 w l, \
    'data/Pr1e+1_temp.dat' u 1:3 notitle ls 3 w l
}

reset
{
  set terminal epslatex standalone color size 5.,3.5 font ',14'
  set output 'ux2.tex'
  set xlabel '$x$'
  set ylabel '$\sigma \left( u_x^{\prime} \right)$'
  set xrange [0.:0.5]
  set yrange [0.:1.0]
  set xtics 0.1
  set ytics 0.2
  set format x '$% .1f$'
  set format y '$% .1f$'
  set style line 1 lc rgb '#FF0000' lw 5
  set style line 2 lc rgb '#0000FF' lw 5
  set style line 3 lc rgb '#33AA00' lw 5
  set key left top
  plot \
    'data/Pr1e-1_ux.dat' u 1:3 notitle ls 1 w l, \
    'data/Pr1e+0_ux.dat' u 1:3 notitle ls 2 w l, \
    'data/Pr1e+1_ux.dat' u 1:3 notitle ls 3 w l
}

reset
{
  set terminal epslatex standalone color size 5.,3.5 font ',14'
  set output 'uy2.tex'
  set xlabel '$x$'
  set ylabel '$\sigma \left( u_y^{\prime} \right)$'
  set xrange [0.:0.5]
  set yrange [0.:0.8]
  set xtics 0.1
  set ytics 0.2
  set format x '$% .1f$'
  set format y '$% .1f$'
  set style line 1 lc rgb '#FF0000' lw 5
  set style line 2 lc rgb '#0000FF' lw 5
  set style line 3 lc rgb '#33AA00' lw 5
  set key left top
  plot \
    'data/Pr1e-1_uy.dat' u 1:3 notitle ls 1 w l, \
    'data/Pr1e+0_uy.dat' u 1:3 notitle ls 2 w l, \
    'data/Pr1e+1_uy.dat' u 1:3 notitle ls 3 w l
}

