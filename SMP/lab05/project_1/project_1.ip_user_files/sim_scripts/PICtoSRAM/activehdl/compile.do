vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../bd/PICtoSRAM/sim/PICtoSRAM.v" \
"../../../bd/PICtoSRAM/ip/PICtoSRAM_PIC16F873_0_0/sim/PICtoSRAM_PIC16F873_0_0.v" \
"../../../bd/PICtoSRAM/ip/PICtoSRAM_T74LS04_0_0/sim/PICtoSRAM_T74LS04_0_0.v" \
"../../../bd/PICtoSRAM/ip/PICtoSRAM_T74LS373_0_0/sim/PICtoSRAM_T74LS373_0_0.v" \
"../../../bd/PICtoSRAM/ip/PICtoSRAM_m62256_0_0/sim/PICtoSRAM_m62256_0_0.v" \
"../../../bd/PICtoSRAM/ip/PICtoSRAM_splitter1_0_0/sim/PICtoSRAM_splitter1_0_0.v" \
"../../../bd/PICtoSRAM/ip/PICtoSRAM_splitter2_0_0/sim/PICtoSRAM_splitter2_0_0.v" \
"../../../bd/PICtoSRAM/ip/PICtoSRAM_splitter3_0_0/sim/PICtoSRAM_splitter3_0_0.v" \
"../../../bd/PICtoSRAM/ip/PICtoSRAM_m62256_1_0/sim/PICtoSRAM_m62256_1_0.v" \
"../../../bd/PICtoSRAM/ip/PICtoSRAM_select_0_0/sim/PICtoSRAM_select_0_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

