
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

### Resources

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
| sda1 | /boot | 500MiB | | xfs |
| root | /  | 10GiB| LVMGroup | xfs |
| swap | SWAP |2.3GiB| LVMGroup | xfs |
| home | /home | 5GiB | LVMGroup | xfs |
| var | /var | 3GiB | LVMGroup | xfs |
| srv | /srv | 3GiB | LVMGroup | xfs |
| tmp | /tmp | 3GiB | LVMGroup | xfs |
|var-log| /var/log| 4GiB | LVMGroup | xfs |

Click `Done`  and Create a passphrase for encrypted disk
<div align="left">
    <img src="https://raw.githubusercontent.com/viruskizz/42Bangkok-Born2beroot/main/Installation/CentOs-Setup-Partition.png" alt="Logo" height="240">
</div>

5. Click `Install`
6. Create your root password
7. Reboot

Check your partition is succeed with command

```bash
lsblk
```

<div align="left">
    <img src="https://raw.githubusercontent.com/viruskizz/42Bangkok-Born2beroot/main/Installation/CentOs-lsblk.png" alt="Logo" height="240">
</div>

Just Check only **_Mount point, Group name, file type, encrpyting level_**. No need to check number of ordering it will managed by OS. CentOS ordering is different from Debian.

## Initialize setting up

### Check your connection and enable

Ping test

```bash
$ ping google.com
```

Check network interface

```bash
$ nmcli d
```

Active connection and set automatic on start

```bash
$ nmtui
```

Reboot required

```bash
$ reboot
```

### Install Utility package

```bash
## OPTIONAL update os to latest
$ yum update -y
# install additional utility
$ yum install -y epel-release
$ yum install -y net-tools
$ yum install -y policycoreutils-python
$ yum install -y vim
```

## Setup Firewall

I recommend setup firewall and ssh first because you can use Gitbash instead of VM termimal. it easy for you to copy and scrolling mouse.

### Resource

- [Firewalld vs UFW]
- [Setup firewalld in CentOS]
- [How to set UFW]

Stop and Disable firewalld (default firewall in CentOS)

```bash
# check firewalld status
$ systemctl status firewalld
# disable firewalld on start vm
$ systemctl disable firewalld
```

Install UFW and enable

```bash
$ yum install -y ufw
$ systemctl enable ufw
$ systemctl start ufw
```

Delete not used port by number

```bash
$ ufw status numbered
$ ufw delete <number>
```

Allow your port 4242

```bash
$ ufw allow 4242
```

## Setup SSH

Allow you to access VM from external

### Resource

- [What is SSH ?]
- [Change SSH Port]
- [Disable root SSH]

Add custom port 4242 in `/etc/ssh/sshd_config`

```bash
$ echo "Port 4242" >> /etc/ssh/sshd_config
```

Add custom port 4242 in SELinux

```bash
$ semanage port -a -t ssh_port_t -p tcp 4242
```

disable root login

```bash
$ echo "PermitRootLogin no" >> /etc/ssh/sshd_config
```

restart service

```bash
$ systemctl restart sshd
```

Reboot is required

```bash
$ reboot
```

## Setup User management

Manage your user groups and password

### Resources

- [Linux group & user]
- [Login deps]
- [Implement strong password policy in Debiany]
- [Enforce string password policy in CentOS]
- [Check password age]
- [getent command]
- [Could not chdir to home directory]

Create group and User

```bash
# check group by getent command
$ getent group $GROUP
# check exist group from list
$ cat /etc/group | grep $GROUP
```

If not existed , create new group name `user42`

```bash
$ groupadd <group name>
```

Check user

```bash
$ id <username>
```

if not existed , create user as login42 username with password

```bash
$ adduser <username> -p <password>
```

Assign user to group `user42` and `wheel`  (wheel is sudo group in CentOS)

```bash
$ usermod -a -G <group> <username>
```

$ Check group that user belong to.

```bash
$ group <username>
```

## User SSH Access

Check your ssh and user is works collecty with your Gitbash

```bash
# check your VM ip lookup at <192.168.xxx.xxx>
$ ifconfig
```

Access your VM with Gitbash via SSH from your computer not in VM

```bash
# ssh <username>@<ip> -p <port>
$ ssh login42@1
```

Test you are in same machine with broadcast message

```bash
$ wall message
```

<div align="left">
    <img src="https://raw.githubusercontent.com/viruskizz/42Bangkok-Born2beroot/main/Installation/CentOs-access-ssh.png" alt="Logo" height="240">
</div>

## Implement Password Policy

### set password age

Open login defitions `/etc/loigin.defs`

```bash
$ vi /etc/loigin.defs
```

Edit Parameters like below

```txt
PASS_MAX_DAYS   30
PASS_MIN_DAYS   2
PASS_MIN_LEN    10
PASS_WARN_AGE   7
```

### Set password policies

backup original file (optional)

```bash
$ cp /etc/pam.d/system-auth /etc/pam.d/system-auth.bak
```

Edit config file `/etc/pam.d/system-auth`

```bash
$ vi /etc/pam.d/system-auth
```

Change parameters`pam_pwquality.so` in file like this

```txt
password    requisite     pam_pwquality.so retry=3 minlen=10 ucredit=-1 dcredit=-1 difok=7 reject_username enforce_for_root
```

## Implemet Sudo rule

- [Useful sudoer configuration]
- [wheel group is default for sudo group in CentOS]

```bash
$ visodu
```

Edit config file like this below

```txt
## Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL

## Set Sudoer by visudo command
#basic security
Defaults        requiretty
Defaults        secure_path = /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
Defaults        passwd_tries = 3
Defaults        badpass_message = "HEY!!!...Wrong password, please try again..."
Defaults        insults

#log config
Defaults        lecture = always
Defaults        logfile = "/var/log/sudo.log"
Defaults        log_input,log_output, iolog_dir = "/var/log/sudo"
```

check sudo log as normal user

```shell
$ su - <user>
$ sudo <command>
```

## Create crontab script

write a shell script will grep information from your VM

### Resources

- [How to Cronjob]
- [How to monitor resource]
- [Get cpu usage]
- [List sudo history]
- [Check TCP ESTABLISHED]
- [Check LVM is used]
- [Check last boot]
- [Check disk usage]
- [Memory Usage]
- [Check CPU command]
- [Wall command]

```shell
$ vi monitor.sh
```

add script file below

```bash
#!/bin/bash

output="#Arhitecture : $(uname -a)
#CPU physical : $(nproc)
#vCPU : $(grep processor /proc/cpuinfo | wc -l)
#Memory Usage : $(free -m -t | awk 'NR == 4 {printf("%d/%dMB (%.2f%%)", $3, $2, $3/$2*100)}')
#Disk Usage : $(df -h | awk '$NF=="/" {printf("%d/%dGb (%s)", $3, $2, $5)}')
#CPU load : $(top -bn1 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'| awk '{print 100-$8}')%
#Last boot : $(who -b | awk '{ printf("%s %s", $3, $4) }')
#LVM use : $(cat /etc/fstab | grep /dev/mapper/ | wc -l | awk '{if ($1 > 0) {printf("yes")} else {printf("no")}}')
#Connexions TCP : $(netstat -ant | grep ESTABLISHED | wc -l) ESTABLISHED
#User log : $(who | wc -l)
#Network : IP $(/sbin/ifconfig enp0s3 | grep "inet " | awk '{ print($2) }') ($(/sbin/ifconfig enp0s3 | grep "ether" | awk '{ print($2) }'))
#Sudo : $(journalctl _COMM=sudo | grep COMMAND | wc -l) cmd"

echo "$output"
```

grant permission to file

```shell
$ chmod +x monitor.sh
```

execute file to test

```shell
$ ./monitor.sh
```

Try broadcast message with script

```shell
$ ~/monitor.sh | wall
```

Add crontab job every 10 mins

```shell
$ crontab -e
```

add line below

```txt
*/10 * * * * ~/monitor.sh | wall
```

## Finish Mandatory

congratulations your ROOT now

<div align="left">
    <img src="https://c.tenor.com/nTWaxH_L3bEAAAAC/loki-success.gif" alt="Logo" height="240">
</div>

by Araiva
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

[Useful sudoer configuration]: https://www.tecmint.com/sudoers-configurations-for-setting-sudo-in-linux/
[wheel group is default for sudo group in CentOS]: https://en.wikipedia.org/wiki/Wheel_(computing)#:~:text=The%20wheel%20group%20is%20a,that%20of%20a%20wheel%20group.

[How to Cronjob]: https://phoenixnap.com/kb/set-up-cron-job-linux
[How to monitor resource]: https://linuxhint.com/check-cpu-utilization-linux/
[Get cpu usage]: https://www.baeldung.com/linux/get-cpu-usage
[List sudo history]: https://unix.stackexchange.com/questions/167935/details-about-sudo-commands-executed-by-all-user
[Check TCP ESTABLISHED]: https://serverfault.com/questions/527875/how-do-i-get-the-number-of-currently-established-tcp-connections-for-a-specifi
[Check LVM is used]: https://askubuntu.com/questions/202613/how-do-i-check-whether-i-am-using-lvm
[Check last boot]: https://www.cyberciti.biz/tips/linux-last-reboot-time-and-date-find-out.html
[Check disk usage]: https://phoenixnap.com/kb/linux-check-disk-space
[Memory Usage]: https://phoenixnap.com/kb/linux-commands-check-memory-usage
[Check CPU command]: https://www.cyberciti.biz/faq/check-how-many-cpus-are-there-in-linux-system/
[Wall command]: https://linuxize.com/post/wall-command-in-linux/