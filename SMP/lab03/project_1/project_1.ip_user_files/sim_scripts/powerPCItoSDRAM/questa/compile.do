vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 \
"../../../bd/powerPCItoSDRAM/ip/powerPCItoSDRAM_powerpcfsm_0_0/sim/powerPCItoSDRAM_powerpcfsm_0_0.v" \
"../../../bd/powerPCItoSDRAM/ip/powerPCItoSDRAM_mpc106fsm_0_0/sim/powerPCItoSDRAM_mpc106fsm_0_0.v" \
"../../../bd/powerPCItoSDRAM/ip/powerPCItoSDRAM_chip_select_splitter_0_0/sim/powerPCItoSDRAM_chip_select_splitter_0_0.v" \
"../../../bd/powerPCItoSDRAM/ip/powerPCItoSDRAM_data_splitter_0_0/sim/powerPCItoSDRAM_data_splitter_0_0.v" \
"../../../bd/powerPCItoSDRAM/ip/powerPCItoSDRAM_mx9_sdramfsm_0_0/sim/powerPCItoSDRAM_mx9_sdramfsm_0_0.v" \
"../../../bd/powerPCItoSDRAM/sim/powerPCItoSDRAM.v" \


vlog -work xil_defaultlib \
"glbl.v"

