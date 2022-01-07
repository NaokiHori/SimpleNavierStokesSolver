#!/bin/bash

with_temperature=true \
with_thermal_forcing=true \
timemax=5.0e+1 \
wtimemax=3.0e+2 \
log_rate=1.0e+2 \
log_after=1.0e+2 \
save_rate=1.0e+3 \
save_after=1.0e+3 \
stat_rate=1.0e+0 \
stat_after=1.0e+3 \
ly=1.0e+0 \
itot=32 \
jtot=32 \
stretch=3 \
Ra=1.0e+100 \
Pr=1.0e+0 \
mpirun -n 1 --oversubscribe ./a.out
