reset
{
  set terminal epslatex standalone color size 5.,3.5 font ',14'
  set output 'energy.tex'
  set xlabel '$t$'
  set ylabel '$K / K_0, H / H_0$'
  set xrange [50.:100.]
  set yrange [0.5:1.01]
  set xtics 25.
  set ytics 0.1
  set format x '$% .0f$'
  set format y '$% .1f$'
  set style line 1 lc rgb '#FF0000' lw 5
  set style line 2 lc rgb '#0000FF' lw 5
  set style line 3 lc rgb '#000000' lw 5 dt 2
  filename = 'artifacts/log/energy.dat'
  kx0 = system(sprintf("head -n 1 %s | awk '{print $2}'", filename))
  ky0 = system(sprintf("head -n 1 %s | awk '{print $3}'", filename))
  k0  = kx0 + ky0
  h0  = system(sprintf("head -n 1 %s | awk '{print $4}'", filename))
  set key left bottom
  plot \
    filename u 1:(($2+$3)/k0) t '$K$' ls 1 w l, \
    filename u 1:(($4   )/h0) t '$H$' ls 2 w l, \
    1. notitle ls 3 w l
}

