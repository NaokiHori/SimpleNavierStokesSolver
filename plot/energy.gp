plot \
  'output/log/energy.dat' u 1:2 t '1/2 u_x^2' ls 1 w l, \
  'output/log/energy.dat' u 1:3 t '1/2 u_y^2' ls 2 w l, \
  'output/log/energy.dat' u 1:4 t '1/2 T^2'   ls 3 w l
