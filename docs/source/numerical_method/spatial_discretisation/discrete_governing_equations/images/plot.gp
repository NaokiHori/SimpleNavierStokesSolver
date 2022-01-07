reset
{
  set terminal epslatex standalone color size 5.,3.5 font ',14'
  set output 'adv_energy.tex'
  set xlabel '$t$'
  set ylabel '$K / K_0, H / H_0$'
  set xrange [0.:10.]
  set yrange [0.9:1.4]
  set xtics 5.
  set ytics 0.1
  set format x '$% .0f$'
  set format y '$% .1f$'
  set style line 1 lc rgb '#FF0000' lw 5
  set style line 2 lc rgb '#0000FF' lw 5
  set style line 3 lc rgb '#FF0000' lw 5 dt 3
  set style line 4 lc rgb '#0000FF' lw 5 dt 3
  set style line 5 lc rgb '#000000' lw 5 dt 2
  filename1 = 'data/adv_energy_consistent.dat'
  filename2 = 'data/adv_energy_inconsistent.dat'
  kx1 = system(sprintf("head -n 1 %s | awk '{print $2}'", filename1))
  ky1 = system(sprintf("head -n 1 %s | awk '{print $3}'", filename1))
  h1  = system(sprintf("head -n 1 %s | awk '{print $4}'", filename1))
  kx2 = system(sprintf("head -n 1 %s | awk '{print $2}'", filename2))
  ky2 = system(sprintf("head -n 1 %s | awk '{print $3}'", filename2))
  h2  = system(sprintf("head -n 1 %s | awk '{print $4}'", filename2))
  k1  = kx1 + ky1
  k2  = kx2 + ky2
  set key left top
  plot \
    filename1 u 1:(($2+$3)/k1) t '$K$ (consistent)'   ls 1 w l, \
    filename1 u 1:(($4   )/h1) t '$H$ (consistent)'   ls 2 w l, \
    filename2 u 1:(($2+$3)/k2) t '$K$ (inconsistent)' ls 3 w l, \
    filename2 u 1:(($4   )/h2) t '$H$ (inconsistent)' ls 4 w l, \
    1. notitle ls 5 w l
}

{
  reset
  set terminal epslatex standalone color size 5.,3.5 font ',12'
  set output 'adv_convergence.tex'
  set xlabel '$\Delta t$'
  set ylabel '$\epsilon$'
  set logscale x
  set logscale y
  set xrange [1.25e-3/sqrt(2.):2.e-2*sqrt(2.)]
  set yrange [1.e-6:1.e+0]
  set xtics 10.
  set ytics 10.
  set format x '$10^{%L}$'
  set format y '$10^{%L}$'
  set style line 1 lc rgb '#FF0000' lw 5
  set style line 2 lc rgb '#0000FF' lw 5
  set style line 3 lc rgb '#FF0000' lw 5 dt 2
  set style line 4 lc rgb '#0000FF' lw 5 dt 2
  set style line 5 lc rgb '#000000' lw 3 dt 3
  set key right bottom spacing 1.2
  filename1 = 'data/adv_convergence_consistent.dat'
  filename2 = 'data/adv_convergence_inconsistent.dat'
  plot \
    filename1 u 1:(abs($2)) t '$K$, consistent'   ls 1 pt 7 ps 1.5 w lp, \
    filename1 u 1:(abs($3)) t '$H$, consistent'   ls 2 pt 7 ps 1.5 w lp, \
    filename2 u 1:(abs($2)) t '$K$, inconsistent' ls 3 pt 7 ps 1.5 w lp, \
    filename2 u 1:(abs($3)) t '$H$, inconsistent' ls 4 pt 7 ps 1.5 w lp, \
    1.e4*x**3. t '$\propto \Delta t^3$' ls 5 w l
}

{
  reset
  set terminal epslatex standalone color size 5.,3.5 font ',12' header '\usepackage{amsmath}'
  set output 'dif_convergence.tex'
  set xlabel 'itot'
  set ylabel '$Nu_{\left\{ \cdot \right\}} / Nu_{\text{wall}}$'
  set logscale x
  set xrange [8/sqrt(2.):256*sqrt(2.)]
  set yrange [0.:2.]
  set xtics ('$8$' 8, '$16$' 16, '$32$' 32, '$64$' 64, '$128$' 128, '$256$' 256)
  set ytics 0.5
  set format y '$% .1f$'
  set style line 1 lc rgb '#FF0000' lw 5
  set style line 2 lc rgb '#0000FF' lw 5
  set key right top
  filename = 'data/dif_convergence.dat'
  plot \
    filename u 1:( $6/($2)) t '$Nu_{\epsilon_k} / Nu_{\text{wall}}$,   consistent' ls 1 pt 2 ps 2. w lp, \
    filename u 1:( $8/($2)) t '$Nu_{\epsilon_h} / Nu_{\text{wall}}$,   consistent' ls 1 pt 4 ps 2. w lp, \
    filename u 1:($10/($2)) t '$Nu_{\epsilon_k} / Nu_{\text{wall}}$, inconsistent' ls 2 pt 2 ps 2. w lp, \
    filename u 1:($12/($2)) t '$Nu_{\epsilon_h} / Nu_{\text{wall}}$, inconsistent' ls 2 pt 4 ps 2. w lp
}

