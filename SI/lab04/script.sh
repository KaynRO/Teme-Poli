#!/bin/bash

echo '---------------Exercitiul 1---------------'

#Step 1: create a 6GB file system(partition table + boot + rootfs)
echo '[+] Creating 6GB of file system'
dd if=/dev/zero of=rpi.img bs=1k count=6M

#Step 2:Format file system to contain 100MB boot(fat) and rest rootfs(ext4)
#Create partition 1, first sector 2048, last sector 206848, primary, label 1
#Create partition 2, first sector 206849, last sector THE END, primary, label 2
echo '[+] Formating file system'
fdisk rpi.img

#Step 3: Create boot image of 100MB
echo '[+] Creating 100MB of boot image'
dd if=/dev/zero of=boot.img bs=1k count=100k

#Step 4: Create rootf image of 6GB - 100 MB - 1MB
echo '[+] Creating 6 GB of rootfs'
dd if=/dev/zero of=rootfs.img bs=1k count=6000k

#Step 5: Formating boot image as FAT
echo '[+] Formatting boot.img as FAT'
mkfs -t vfat boot.img

#Step 6: Formating rootfs image as EXT2
echo '[+] Formatting rootfs.img as EXT2'
mkfs -t ext2 rootfs.img

#Step 7:
echo '[+] Adding boot image to file system'
dd if=boot.img of=rpi.img bs=1k seek=4096

#Step 8:
echo '[+] Adding rootfs to file system'
dd if=rootfs.img of=rpi.img bs=1k seek=413696


echo '---------------Exercitiul 2---------------'

#Step 1: Mounting our image and the official one
echo '[+] Mounting our image and the 2015-qemu one'
sudo mkdir rootfs-rpi
sudo mkdir rootfs-qemu
sudo mount -o offset=$((413696 * 1024)) rpi.img rootfs-rpi
sudo mount -o offset=$((245760 * 1024)) 2015-qemu-rpi.img rootfs-qemu

#Step 2: Copy all data from official image to our image
echo '[+] Copying data from the official image to our image'
sudo cp -a rootfs-qemu/* rootfs-rpi/

#Step 3: Unmounting the images
echo '[+] Unmounting the images'
sudo umount rootfs-rpi
sudo umount rootfs-qemu
sudo rm -rf rootfs-rpi
sudo rm -rf rootfs-qemu


echo '---------------Exercitiul 3---------------'
#Step 1: We need to add the virtual bridge which is attached to our physical one
echo '[+] Adding vibr0 bridge'
sudo brctl addbr virbr0
sudo brctl addif virbr0 ens33
sudo ip address flush dev ens33
sudo dhclient virbr0 2> /dev/null
sudo sync -f rootfs.img

#Step 2: Start qemu using our created rootfs.img
echo '[+] Starting qemu'
sudo qemu-system-arm -machine versatilepb -cpu arm1176 -kernel kernel.img -append 'root=/dev/sda2' -drive file=rootfs.img,index=0,media=disk,format=raw -net nic,model=smc91c111,netdev=bridge -netdev bridge,br=virbr0,id=bridge -serial stdio

