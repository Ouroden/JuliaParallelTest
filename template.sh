#!/bin/bash
#SBATCH -p plgrid
#SBATCH -N 1
#SBATCH --ntasks-per-node=CPUS
#SBATCH --output="logs/CPUS.out"

module add plgrid/tools/julia/1.0.0
julia -p CPUS zad1.jl
