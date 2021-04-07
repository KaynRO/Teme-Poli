vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../bd/powerPCItoSDRAM/ip/powerPCItoSDRAM_powerpcfsm_0_0/sim/powerPCItoSDRAM_powerpcfsm_0_0.v" \
"../../../bd/powerPCItoSDRAM/ip/powerPCItoSDRAM_mpc106fsm_0_0/sim/powerPCItoSDRAM_mpc106fsm_0_0.v" \
"../../../bd/powerPCItoSDRAM/ip/powerPCItoSDRAM_chip_select_splitter_0_0/sim/powerPCItoSDRAM_chip_select_splitter_0_0.v" \
"../../../bd/powerPCItoSDRAM/ip/powerPCItoSDRAM_data_splitter_0_0/sim/powerPCItoSDRAM_data_splitter_0_0.v" \
"../../../bd/powerPCItoSDRAM/ip/powerPCItoSDRAM_mx9_sdramfsm_0_0/sim/powerPCItoSDRAM_mx9_sdramfsm_0_0.v" \
"../../../bd/powerPCItoSDRAM/sim/powerPCItoSDRAM.v" \


vlog -work xil_defaultlib \
"glbl.v"

