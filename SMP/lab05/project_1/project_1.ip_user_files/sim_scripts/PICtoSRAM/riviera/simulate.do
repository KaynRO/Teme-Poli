onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+PICtoSRAM -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.PICtoSRAM xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {PICtoSRAM.udo}

run -all

endsim

quit -force
