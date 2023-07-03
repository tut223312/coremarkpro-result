#!/bin/bash
#SBATCH --job-name=coremark
#SBATCH --partition=apollo70
#SBATCH -t 03:00:00

module purge
module load system/aarch64 mvapich2

rm -rf result_apollo70_with_gcc
mkdir result_apollo70_with_gcc

# git clone https://github.com/eembc/coremark-pro
cd coremark-pro
rm -rf builds
make build

for cval in 1 4 16 64
do
	for wval in 1 4 16 64
	do
		if [ $cval -lt $wval ]; then
			continue
		fi

		make "TARGET=linux64 XCMD='-c${cval} -w${wval}' certify-all"
		cp builds/linux64/gcc64/logs/linux64.gcc64.mark ../result_apollo70_with_gcc/c${cval}w${wval}.mark
	done
done
cd ../

cp -r coremark-pro/builds/linux64/gcc64/cert ./result_apollo70_with_gcc/cert
