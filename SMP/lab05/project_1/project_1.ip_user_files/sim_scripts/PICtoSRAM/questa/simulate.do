onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib PICtoSRAM_opt

do {wave.do}

view wave
view structure
view signals

do {PICtoSRAM.udo}

run -all

quit -force
