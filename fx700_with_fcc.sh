#!/bin/bash
#SBATCH --job-name=coremark
#SBATCH --partition=fx700
#SBATCH -t 03:00:00

module purge
module load system/fx700 FJSVstclanga

rm -rf result_fx700_with_fcc
mkdir result_fx700_with_fcc

# git clone https://github.com/eembc/coremark-pro
cd coremark-pro
rm -rf builds
make build TARGET=fx700

for cval in 1 4 16 64
do
	for wval in 1 4 16 64
	do
		if [ $cval -lt $wval ]; then
			continue
		fi

		make "TARGET=fx700 XCMD='-c${cval} -w${wval}' certify-all"
		cp builds/fx700/fcc/logs/fx700.fcc.mark ../result_fx700_with_fcc/c${cval}w${wval}.mark
	done
done
cd ../

cp -r coremark-pro/builds/fx700/fcc/cert ./result_fx700_with_fcc/cert
