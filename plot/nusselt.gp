plot \
  'output/log/nusselt.dat' u 1:2 t 'wall'    ls 1 w l, \
  'output/log/nusselt.dat' u 1:3 t 'inject'  ls 2 w l, \
  'output/log/nusselt.dat' u 1:4 t 'kinetic' ls 3 w l, \
  'output/log/nusselt.dat' u 1:5 t 'thermal' ls 4 w l
