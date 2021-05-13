# 00 - Capture 1

Dupa ce am deschis captura in Wireshark si am cautat stringul **ISC{** in packete, am gasit un match

![[Pasted image 20210512222007.png]]

## Flag
**ISC{sending_passwords_in_cleartext_is_not_smart}**


# 01 - File

```bash
└──╼ $file 01-File 
01-File: gzip compressed data, was "flag.txt", last modified: Sun May 14 01:09:57 2017, max compression, from FAT filesystem (MS-DOS, OS/2, NT), original size modulo 2^32 25
```

Astfel, am redenumit fisierul pentru a adauga extensia **gz** si l-am uploadat pe un host de Windows pentru a vedea flagul.

![[Pasted image 20210512222308.png]]

![[Pasted image 20210512222327.png]]

# Flag
**ISC{file_is_our_friend}**


# 02 - Hidden 1

```bash
└──╼ $strings 02-Hidden\ 1.png | grep ISC
%tEXtdate:ISC{we_all_love_grep}59:18+02:00
```

## Flag
**ISC{we_all_love_grep}**


# 03 - Corrupted.jpg
Trebuie sa reconstruim headerul fisierului cu extensia JPEG pentru a fi unul valid.

![[Pasted image 20210512222848.png]]

![[Pasted image 20210512222938.png]]

![[Pasted image 20210512222958.png]]


## Flag
ISC{no_more_ideas_for_flags}


# 04 - Alien communication
Trebuie sa analizam spectograma aferenta fisierului **.wav** folosind Audacity.

![[Pasted image 20210512223208.png]]

## Flag
**ISC{spectogram_for_the_win}**


# 05 - Idea
```bash
┌─[kayn@parrot]─[~/Documents/ISC/lab09]
└──╼ $binwalk -e 05-Idea.jpg 

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             JPEG image data, JFIF standard 1.01
33519         0x82EF          7-zip archive data, version 0.4
```

```bash
└──╼ $binwalk --dd='.*' 05-Idea.jpg 

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             JPEG image data, JFIF standard 1.01
33519         0x82EF          7-zip archive data, version 0.4

┌─[kayn@parrot]─[~/Documents/ISC/lab09]
└──╼ $ls
'00-Capture 1.pcap'   01-File  '02-Hidden 1.png'   03-Corrupted.jpg  '04-Alien communication.wav'   05-Idea.jpg   _05-Idea.jpg.extracted   06-Letter.pdf   07-Dumb.gif  '08-Capture 2.pcap'   output
┌─[kayn@parrot]─[~/Documents/ISC/lab09]
└──╼ $cat _05-Idea.jpg.extracted/
0     82EF  
```

![[Pasted image 20210512223550.png]]


## Flag
**ISC{fileception_is_real}**


# 06 - Censored
Folosind un program precum Adobe Acrobat Reader, putem muta chenarul negru.

![[Pasted image 20210512224304.png]]


## Flag
**ISC{hidden_in_the_dark}**


# 07 - Dumb
![[Pasted image 20210512224651.png]]

Daca scanam codul QR, primim automat flagul.


## Flag
**ISC{what_were_you_waiting_for}**


# 08 - Capture 2
![[Pasted image 20210512225033.png]]

```bash
┌─[kayn@parrot]─[~/Documents/ISC/lab09/ctf-usb-keyboard-parser]
└──╼ $tshark -r ../08-Capture\ 2.pcap -Y 'usb.capdata && usb.data_len == 8' -T fields -e usb.capdata | sed 's/../:&/g2' > usbPcapData 
┌─[kayn@parrot]─[~/Documents/ISC/lab09/ctf-usb-keyboard-parser]
└──╼ $cat usbPcapData 
20:00:00:00:00:00:00:00
20:00:0c:00:00:00:00:00
20:00:00:00:00:00:00:00
00:00:00:00:00:00:00:00
20:00:00:00:00:00:00:00
20:00:16:00:00:00:00:00
20:00:00:00:00:00:00:00
00:00:00:00:00:00:00:00
20:00:00:00:00:00:00:00
20:00:06:00:00:00:00:00
20:00:00:00:00:00:00:00
00:00:00:00:00:00:00:00
20:00:00:00:00:00:00:00
20:00:2f:00:00:00:00:00
20:00:00:00:00:00:00:00
00:00:00:00:00:00:00:00
00:00:0e:00:00:00:00:00
00:00:00:00:00:00:00:00
00:00:08:00:00:00:00:00
00:00:00:00:00:00:00:00
00:00:1c:00:00:00:00:00
00:00:00:00:00:00:00:00
00:00:06:00:00:00:00:00
00:00:00:00:00:00:00:00
00:00:04:00:00:00:00:00
00:00:00:00:00:00:00:00
00:00:13:00:00:00:00:00
00:00:00:00:00:00:00:00
20:00:00:00:00:00:00:00
20:00:30:00:00:00:00:00
20:00:00:00:00:00:00:00
00:00:00:00:00:00:00:00
┌─[kayn@parrot]─[~/Documents/ISC/lab09/ctf-usb-keyboard-parser]
└──╼ $python2 usbkeyboard.py usb
usbkeyboard.py  usbPcapData     
┌─[kayn@parrot]─[~/Documents/ISC/lab09/ctf-usb-keyboard-parser]
└──╼ $python2 usbkeyboard.py usb
usbkeyboard.py  usbPcapData     
┌─[kayn@parrot]─[~/Documents/ISC/lab09/ctf-usb-keyboard-parser]
└──╼ $python2 usbkeyboard.py usbPcapData 
ISC{keycap}┌─[kayn@parrot]─[~/Documents/ISC/lab09/ctf-usb-keyboard-parser]
```


## Flag
**ISC{keycap}**