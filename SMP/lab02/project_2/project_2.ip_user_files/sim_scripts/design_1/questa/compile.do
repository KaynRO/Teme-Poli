vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 \
"../../../bd/design_1/ip/design_1_decoder_0_0/sim/design_1_decoder_0_0.v" \
"../../../bd/design_1/ip/design_1_gateand_0_0/sim/design_1_gateand_0_0.v" \
"../../../bd/design_1/ip/design_1_gateor_0_0/sim/design_1_gateor_0_0.v" \
"../../../bd/design_1/ip/design_1_gatenegare_0_0/sim/design_1_gatenegare_0_0.v" \
"../../../bd/design_1/ip/design_1_gateand_0_1/sim/design_1_gateand_0_1.v" \
"../../../bd/design_1/ip/design_1_gateand_0_2/sim/design_1_gateand_0_2.v" \
"../../../bd/design_1/ip/design_1_impartitor_d_0_0/sim/design_1_impartitor_d_0_0.v" \
"../../../bd/design_1/ip/design_1_impartitor_a_0_0/sim/design_1_impartitor_a_0_0.v" \
"../../../bd/design_1/ip/design_1_mc68000_0_0/sim/design_1_mc68000_0_0.v" \
"../../../bd/design_1/ip/design_1_ram8kx8_0_0/sim/design_1_ram8kx8_0_0.v" \
"../../../bd/design_1/ip/design_1_ram8kx8_1_0/sim/design_1_ram8kx8_1_0.v" \
"../../../bd/design_1/sim/design_1.v" \


vlog -work xil_defaultlib \
"glbl.v"

