#!/bin/bash

## directory name containing flow fields to restart
# export dirname_restart="output/save/stepxxxxxxxxxx"

## flags
# couple temperature field or not
export with_temperature=true
# thermal forcing is added to x-momentum
export with_thermal_forcing=true

## durations
# maximum duration (in free-fall time)
export timemax=2.0e+2
# maximum duration (in wall time [s])
export wtimemax=6.0e+2
# logging rate (in free-fall time)
export log_rate=2.0e-1
# logging after (in free-fall time)
export log_after=0.0e+0
# save rate (in free-fall time)
export save_rate=2.0e+1
# save after (in free-fall time)
export save_after=0.0e+0
# statistics collection rate (in free-fall time)
export stat_rate=1.0e-1
# statistics collection after (in free-fall time)
export stat_after=1.0e+2

## domain
# domain lengths
export ly=2.0e+0
# number of grids
export itot=128
export jtot=192
# grid stretching in x (i) direction (clipped-Chebyshev)
# number of grids which are clipped
export stretch=3

## physical parameters
export Ra=1.0e+8
export Pr=1.0e+1

export OMPI_MCA_btl_vader_single_copy_mechanism=none

mpirun -n 1 --oversubscribe ./a.out
