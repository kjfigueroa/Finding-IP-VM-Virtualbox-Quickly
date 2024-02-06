[![LinkedIn][linkedin-shield]][linkedin-url] 

# Finding-IP-VM-Virtualbox-Quickly
Ia a Batch script to find the IP of any VirtualBox Machine (Virtual Machine) placed on Windows OS, and then stablish a session via SSH quickly.

The why would be that, it seems very unnecessarily complex and tedious to configure an entry for each VBox machine every time when the host is restarted, the alternative is to configure a network connection using the "VirtualBox Host-Only Ethernet Adapter", and that does not always work (at least for me). 

Normally, having a Linux machine as a Host machine, it's enough to statically configure the addresses in `/etc/hosts`, but this is not the case for Windows.

The Batch script is a short way to skip to many steeps for finding whatever the IP assigned by Windows DHCP to whatever the VM is in VirtualBox.

## How to
Assuming that there is already the `sshd.service` service configured on each VM (this is: have shared the key.pub and activate the line of `.ssh/authorized_keys` on it).

The script use the ARP table (in Windows) to save the IP, after a PING that I use to find it in the VM of interest, filtering the IP with the MAC address of the VM I can find it straightforwardly.

This is:

* Selecting and starting the VM from the script:

```sh
# For example a Centos Machine in VirtualBox
:startcentos
start "" "F:\VBOX2024\centos\centos.vbox"
set md="a0-b1-c2-d3-e5-f6" # I set a new var with they MAC Address first
GOTO conn # And then I move my selection to a function called conn.
```
* In the `conn` function I do the `ping`, filter, and connect via `ssh`

```sh
:conn
for /L %%i in (0,1,30) do ping -f -n 1 -w 50 192.168.1.%%i -4 | findstr -m "bytes=32"
for /f "tokens=1" %%i in ('arp -a ^|findstr %md%') do set ipadd=%%i
ssh -i "c:\users\<user>\.ssh\key" <user>@%ipadd%
```
Considering that the machines are assigned an IP through DHCP from Windows (in my case) no greater than a range of `[1..30]`, I send the `for` applying that criterion (to save time searching ), and for the `ping` I have reduced the `-w timeout` so that it doesn't take so much time too.



https://github.com/kjfigueroa/Finding-IP-VM-Virtualbox-Quickly/assets/68950531/9a0d7b0f-533f-47a7-ba8d-56a8517ff46b



[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/kjfigueroa/ 
