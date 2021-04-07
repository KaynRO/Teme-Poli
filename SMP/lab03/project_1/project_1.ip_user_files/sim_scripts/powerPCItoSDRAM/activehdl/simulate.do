onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+powerPCItoSDRAM -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.powerPCItoSDRAM xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {powerPCItoSDRAM.udo}

run -all

endsim

quit -force
