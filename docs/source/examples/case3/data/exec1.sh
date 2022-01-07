#!/bin/bash

with_temperature=true \
with_thermal_forcing=true \
timemax=5.0e+2 \
wtimemax=3.0e+2 \
log_rate=1.0e+0 \
log_after=0.0e+0 \
save_rate=1.0e+3 \
save_after=1.0e+3 \
stat_rate=1.0e+0 \
stat_after=1.0e+3 \
ly=2.0e+0 \
itot=32 \
jtot=64 \
stretch=3 \
Ra=1.0e+4 \
Pr=1.0e-1 \
mpirun -n 1 --oversubscribe ./a.out
