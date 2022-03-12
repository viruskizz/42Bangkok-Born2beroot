HOSTNAME=tsomsa42
USER=tsomsa
PWD=Born2ber00t
GROUP=user42
# Start configaration

## rename hostname
# set hostname as intra username42
hostnamectl set-hostname $HOSTNAME
# reboot required
reboot

## Config internet connection
# ping test
ping google.com
# check network interface
nmcli d
# active connection and set automatic on start
nmtui
# reboot required
reboot

## OPTIONAL update os to latest
yum update -y
# install additional utility
yum install -y epel-release
yum install -y net-tools
yum install -y policycoreutils-python
yum install -y vim

## User management
# check group
getent group $GROUP
# if not existed , create new group
groupadd $GROUP
# check exist group from list
cat /etc/group | grep $GROUP
# check user
id $USER
# create user
adduser $USER -p $PWD
# assign user to group
usermod -a -G $GROUP,wheel $USER
# check group
group $USER

## Set UFW
# check firewalld and disable firewalld for CentOS
systemctl status firewalld
systemctl disable firewalld
# install UFW and enable port4242
yum install -y ufw
systemctl enable ufw
systemctl start ufw
ufw status numbered
ufw delete 1
ufw delete 1
ufw delete 1
ufw delete 1
ufw allow 4242

## Set SSH
# add custom port 4242 in sshd_config
echo "Port 4242" >> /etc/ssh/sshd_config
# add custom port 4242 in SELinux
semanage port -a -t ssh_port_t -p tcp 4242
# disable root login
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
# restart
systemctl restart sshd

## Set password policy
# set password age
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS\t30/' /etc/login.defs
sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS\t2/' /etc/login.defs
sed -i 's/^PASS_MIN_LEN.*/PASS_MIN_LEN\t10/' /etc/login.defs
sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE\t7/' /etc/login.defs
# Set password policy
cp /etc/pam.d/system-auth /etc/pam.d/system-auth.bak
vi /etc/pam.d/system-auth
# change pam_pwquality.so like this
#password    requisite     pam_pwquality.so retry=3 minlen=10 ucredit=-1 dcredit=-1 difok=7 reject_username enforce_for_root

visodu
## Set Sudoer by visudo command
#basic security
#Defaults        requiretty
#Defaults        secure_path = /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
#Defaults        passwd_tries = 3
#Defaults        badpass_message = "HEY!!!...Wrong password, please try again..."
#Defaults        insults

#log config
#Defaults        lecture = always
#Defaults        logfile = "/var/log/sudo.log"
#Defaults        log_input,log_output, iolog_dir = "/var/log/sudo"

## Create Cronjob
# write a script file
vim ~/monitor.sh
# grant permission
chmod +x ~/monitor.sh
# test broadcast with wall command
~/monitor.sh | wall
