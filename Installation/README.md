
  

# Installation Step
## _Follow these, you will be root_

This is installation step by step in CentOS7. The partition is followed as bonus part.
I recommend you to do it by yourself with [Checkmark]. these step is a hint to help you solve this subject easier.

> Installation base on CentOS!!

## Prerequisite
Setup your environment

- Download [Virtual box](https://www.virtualbox.org/wiki/Downloads)
- Download OS file as iso. [CentOS7 x86_64](https://www.centos.org/download/)
- Download [Gitbash](https://git-scm.com/) the linux terminal (optional for window os)

  

## Setup your OS
Setup virtural box
1. Open your **Virtual Box** and select **New**.
2. Enter name as you want. Choose size RAM 1 GB, Hard Disk 30.8 GB
3. Setting -> Network Adapter1 -> Enable -> Attacted to `Bridged Adapter` -> `your network interface`
4. Setting -> Storage -> Contraller: IDE -> Empty -> Choose `CentOS.iso` (from your download)

Setup OS Installation
1. Start your VM
2. Select `install CentOS 7`. Choose language `English`. Select `INSTALLATION DESTINATION`
3. Other Storage Options
- Select `I will configure partitioning`
- Select `Encrypt my data`
- Done
4. Choose `LVM`. Add new Partition and choose mount path
Create new group name `LVMGroup` and `Encrypt`

| Name | Mount  | Size | Group |File System |
|--|--|--|--|--|
| sda1	| /boot	| 500MiB | | xfs |
| root	| / 	| 10GiB| LVMGroup | xfs |
| swap	| SWAP	|2.3GiB| LVMGroup | xfs |
| home	| /home	| 5GiB | LVMGroup | xfs |
| var	| /var	| 3GiB | LVMGroup | xfs |
| srv	| /srv	| 3GiB | LVMGroup | xfs |
| tmp	| /tmp	| 3GiB | LVMGroup | xfs |
|var-log| /var/log| 4GiB | LVMGroup | xfs |

Click `Done`  and Create a passphrase for encrypted disk
<div align="left">
    <img src="https://raw.githubusercontent.com/viruskizz/42Bangkok-Born2beroot/main/Installation/CentOs-Setup-Partition.png" alt="Logo" height="240">
</div>

5. Click `Install`
6. Create your root password
7. Reboot

Check your partition is succeed with command.
```
lsblk
````

<div align="left">
    <img src="https://raw.githubusercontent.com/viruskizz/42Bangkok-Born2beroot/main/Installation/CentOs-lsblk.png" alt="Logo" height="240">
</div>

Just Check only **_Mount point, Group name, file type, encrpyting level_**. No need to check number of ordering it will managed by OS. CentOS ordering is different from Debian.

## Initialize setting up

####Check your connection and enable

Ping test
```
ping google.com
```
Check network interface
```
nmcli d
```
Active connection and set automatic on start
```
nmtui
```
Reboot required
```
reboot
```

#### Install Utility package
```
## OPTIONAL update os to latest
yum update -y
# install additional utility
yum install -y epel-release
yum install -y net-tools
yum install -y policycoreutils-python
yum install -y vim
```

## Setup Firewall
I recommend setup firewall and ssh first because you can use Gitbash instead of VM termimal. it easy for you to copy and scrolling mouse.


Stop and Disable firewalld (default firewall in CentOS)
```
systemctl status firewalld
systemctl disable firewalld
```
Install UFW and enable
```
yum install -y ufw
systemctl enable ufw
systemctl start ufw
```
Delete not used port by number
```
ufw status numbered
ufw delete [number]
```
Allow your port 4242
```
ufw allow 4242
```

## Setup SSH
Add custom port 4242 in `/etc/ssh/sshd_config`
```
echo "Port 4242" >> /etc/ssh/sshd_config
```
Add custom port 4242 in SELinux
```
semanage port -a -t ssh_port_t -p tcp 4242
```
disable root login
```
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
```
Reboot is required
```
systemctl restart sshd
```

**Good Luck, โชคดีครับ**

  

[checkmark]: https://docs.google.com/spreadsheets/d/1o_YzwE3fOP6ivc68Ipey1HwCWo0oaG5ZFlyEkMFQwRs/edit#gid=1386834576