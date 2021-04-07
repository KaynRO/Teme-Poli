#!/bin/bash

sudo brctl addbr virbr0
sudo brctl addif virbr0 ens33
sudo ip address flush dev ens33
sudo dhclient virbr0

sudo qemu-system-arm -machine versatilepb -cpu arm1176 -kernel kernel -append 'root=/dev/sda2' -drive file=rootfs.img,index=0,media=disk,format=raw -net nic,model=smc91c111,netdev=bridge -netdev bridge,br=virbr0,id=bridge -serial stdio
