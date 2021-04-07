onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib powerPCItoSDRAM_opt

do {wave.do}

view wave
view structure
view signals

do {powerPCItoSDRAM.udo}

run -all

quit -force
