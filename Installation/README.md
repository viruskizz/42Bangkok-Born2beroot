
  

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
##### Resources
- [What's VM ?]
- [Debain vs Cent]
- [What is apt ?]
- [apt & aptitude]
- [SELinux vs APPArmor]
- [systemctl vs service]
- [LVM Guide]
- [File System Structure]
- [Linux File System]
- [How LUKS works ?]

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

Check your partition is succeed with command
```
lsblk
```
<div align="left">
    <img src="https://raw.githubusercontent.com/viruskizz/42Bangkok-Born2beroot/main/Installation/CentOs-lsblk.png" alt="Logo" height="240">
</div>

Just Check only **_Mount point, Group name, file type, encrpyting level_**. No need to check number of ordering it will managed by OS. CentOS ordering is different from Debian.

## Initialize setting up

#### Check your connection and enable

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
##### Resource
- [Firewalld vs UFW]
- [Setup firewalld in CentOS]
- [How to set UFW]


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
ufw delete <number>
```
Allow your port 4242
```
ufw allow 4242
```

## Setup SSH
Allow you to access VM from external
##### Resource
- [What is SSH ?]
- [Change SSH Port]
- [Disable root SSH]

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

## Setup User management
Manage your user groups and password
##### Resource
- [Linux group & user]
- [Login deps]
- [Implement strong password policy in Debiany]
- [Enforce string password policy in CentOS]
- [Check password age]
- [getent command]
- [Could not chdir to home directory]

Create group and User

```
# check group by getent command
getent group $GROUP
# check exist group from list
cat /etc/group | grep $GROUP
```
if not existed , create new group name `user42`
```
groupadd <group name>
```
Check user
```
id <username>
```
if not existed , create user as login42 username with password
```
adduser <username> -p <password>
```
Assign user to group `user42` and `wheel`  (wheel is sudo group in CentOS)
```
usermod -a -G <group> <username>
```
Check group that user belong to.
```
group <username>
```

## User SSH Access
 Check your ssh and user is works collecty with your Gitbash
```
# check your VM ip lookup at <192.168.xxx.xxx>
ifconfig
```
Access your VM with Gitbash via SSH from your computer not in VM
```
# ssh <username>@<ip> -p <port>
ssh login42@1
```
Test you are in same machine with broadcast message
```
Wall message
```

<div align="left">
    <img src="https://raw.githubusercontent.com/viruskizz/42Bangkok-Born2beroot/main/Installation/CentOs-access-ssh.png" alt="Logo" height="240">
</div>

**Good Luck, โชคดีครับ**

  

[checkmark]: https://docs.google.com/spreadsheets/d/1o_YzwE3fOP6ivc68Ipey1HwCWo0oaG5ZFlyEkMFQwRs/edit#gid=1386834576

[What's VM ?]: https://azure.microsoft.com/en-us/overview/what-is-a-virtual-machine/
[Debain vs Cent]: https://1gbits.com/blog/debian-vs-centos/
[What is apt ?]: https://www.digitalocean.com/community/tutorials/what-is-apt
[apt & aptitude]: https://www.tecmint.com/difference-between-apt-and-aptitude/
[SELinux vs APPArmor]: https://www.cyberciti.biz/tips/selinux-vs-apparmor-vs-grsecurity.html
[systemctl vs service]: https://serverfault.com/questions/867322/what-is-the-difference-between-service-and-systemctl
[LVM Guide]: https://opensource.com/business/16/9/linux-users-guide-lvm
[File System Structure]: https://www.linux.com/training-tutorials/linux-filesystem-explained/
[Linux File System]: https://phoenixnap.com/kb/linux-file-system
[How LUKS works ?]: https://infosecwriteups.com/how-luks-works-with-full-disk-encryption-in-linux-6452ad1a42e8

[How to set UFW]: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-18-04
[Setup firewalld in CentOS]: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7
[Firewalld vs UFW]: https://www.ctrl.blog/entry/ufw-vs-firewalld.html

[What is SSH ?]: https://www.techtarget.com/searchsecurity/definition/Secure-Shell
[Change SSH Port]: https://www.cyberciti.biz/faq/howto-change-ssh-port-on-linux-or-unix-server/
[Disable root SSH]: https://www.tecmint.com/disable-or-enable-ssh-root-login-and-limit-ssh-access-in-linux/

[Linux group & user]: https://phoenixnap.com/kb/how-to-add-user-to-group-linux
[Login deps]: https://linuxtect.com/linux-etc-login-defs-tutorial/
[Implement strong password policy in Debiany]: https://computingforgeeks.com/enforce-strong-user-password-policy-ubuntu-debian/
[Enforce string password policy in CentOS]: https://kifarunix.com/enforce-password-complexity-policy-on-centos-7-rhel-derivatives/

[Check password age]: https://www.cyberciti.biz/faq/linux-howto-check-user-password-expiration-date-and-time/
[getent command]: https://linuxhint.com/getent-command/
[Could not chdir to home directory]: https://www.cyberciti.biz/faq/linux-unix-appleosx-bsd-could-not-chdir-to-home-directory/