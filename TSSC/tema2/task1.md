# Task 1

The first thing to do is open the PCAP file inside **Wireshark** in order to properly analyze/filter data that we need. Due to the fact that SSH and TLS protocol use encrypted communication which we will not be able to understand by investigating the packets, we can filter them out.

![[Pasted image 20210429001323.png]]

## HTTP

One of the most important feature Wireshark provides for analysing HTTP traffic is the File->Export Objects->HTTP.

![[Pasted image 20210429001449.png]]

We can now view the files that were used during the protocol. Due to the fact that the only plain/text one is todo.txt, we can use the *Preview* option only on it.

**todo.txt**
![[Pasted image 20210429001522.png]]

For the others, we need to follow the HTTP stream and see the raw bytes transferred.

**key.pub**
![[Pasted image 20210429001844.png]]

**certificate.pem**
![[Pasted image 20210429001808.png]]


## TELNET

There is also TELNET related traffic which we can also see by following the stream.

![[Pasted image 20210429002121.png]]

![[Pasted image 20210429002459.png]]

![[Pasted image 20210429002821.png]]

## FTP

Never the less, there is also data transferred via FTP protocol.

![[Pasted image 20210429002316.png]]


Using the private **OpenSSH** key from transfered via the Telnet protocol, we could log into **secure\@isc2021.root.sx**.

```bash
┌─[kayn@parrot]─[~/Documents/ISC/tema2/task1]
└──╼ $ssh secure@isc2021.root.sx -i secure.key 
You did it! Congratulations!

Your flag is:

SpeishFlag{6TXftdQAzDoXq8GXb0hXPblEv6jf4QeZ}

Connection to isc2021.root.sx closed.
```


## Flag

**SpeishFlag{6TXftdQAzDoXq8GXb0hXPblEv6jf4QeZ}**

