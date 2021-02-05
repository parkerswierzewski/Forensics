#!/bin/bash
#
# Linux System Info v1.0
#
# author: Parker Swierzewski
# lanugage: Bash Script
# desc: This script will obtain system information on Linux systems.
#
# Note: This was tested only on an Ubuntu box (SANS Swift VM). Output
#        may vary on different (Linux) operating systems.

RED=`tput setaf 1`
GREEN=`tput setaf 2`
NC=`tput sgr0`

clear
sudo apt-get install net-tools
clear

echo "---- Time ----"
ts=$(date)
up=$(uptime)

echo "Timestamp: ${GREEN}$ts${NC}"
echo "Uptime: ${GREEN}$up${NC}"

echo -e "\n---- Operating System ----"
os=$(cat /etc/os-release | grep -m 1 'NAME' | sed 's/"//g') 
ver=$(cat /etc/os-release | grep -m 1 'VERSION' | sed 's/"//g')
vendor=$(cat /proc/cpuinfo | grep 'vendor' | uniq | awk '{print $3}') 
model=$(cat /proc/cpuinfo | grep 'model name' | uniq) 
proc=$(cat /proc/cpuinfo | grep 'processor' | wc -l)
kernel=$(uname -sr)                                          

echo "OS: ${GREEN}${os:5} ${ver:8}${NC}"
echo "Vendor: ${GREEN}$vendor${NC}"
echo "Model: ${GREEN}${model:13}${NC}"
echo "Processor: ${GREEN}$proc${NC}"
echo "Kernal: ${GREEN}$kernel${NC}"

echo -e "\n---- System Specs ----"
arch=$(lscpu | grep 'Architecture' | awk '{print $2}')
mem=$(free -m | head -n 2)
fs=$(df)
partitions=$(lsblk)
hostname=$(hostname)
dn=$(domainname)

echo "CPU Architecture: ${GREEN}$arch${NC}"
echo -e "Memory (Used and Free):\n${GREEN}$mem${NC}"
echo -e "File System Disk Information:\n${GREEN}$fs${NC}"
echo -e "Paritions:\n${GREEN}$partitions${NC}"
echo "Hostname: ${GREEN}$hostname${NC}"
echo "Domain Name: ${GREEN}$dn${NC}"

echo -e "\n---- Network ----"
mac=$(ip -o link | awk '{print $2,$(NF-2)}')
ip=$(ip -o address | awk '{print $2,$4}')
promisc=$(ip a | grep PROMISC | awk '{print $2'})
estab=$(netstat -at)

echo -e "Interfaces and MAC Addresses:\n${GREEN}$mac${NC}"
echo -e "Interfaces and IPv4/IPv6 Address:\n${GREEN}$ip${NC}"

if [ "$promisc" == '' ]
then
	echo "Promiscuous Mode: ${RED}None${NC}"
else
	echo -e "Promiscuous Mode:\n${GREEN}$promisc${NC}"
fi

echo -e "Established Connection(s):\n${GREEN}$estab${NC}"

echo -e "\n---- Users ----"
online=$(w)
logio=$(last)
uid0=$(awk -F: '($3 == 0) {printf "%s:%s\n",$1,$3}' /etc/passwd)

echo -e "Logged On:\n${GREEN}$online${NC}"
echo -e "Recently Logged On/Out:\n${GREEN}$logio${NC}"
echo -e "Users with UID 0:\n${GREEN}$uid0${NC}"
echo "Root Owned Files:${GREEN}"
echo -n "$(sudo find / -uid 0 -perm -4000 -type f)${NC}"

echo -e "\n---- Processes and Open Files ----"
process=$(ps aux | head -20)
ncf=$(ps -gef | grep nc)
openu=$(lsof +L1)

echo -e "Processes:\n${GREEN}$process${NC}"
echo -e "Files Opened By nc:\n${GREEN}$ncf${NC}"
echo -e "All Opened, but Unlinked File:\n${GREEN}$openu${NC}"

echo -e "\n---- Miscellaneous ----"
edited=$(find /home/ -mtime -1)
rootpasswd=$(sudo chage -l root)
executable=$(sudo find / -type f -executable -mtime -5)
sshconn=$(journalctl /usr/sbin/sshd | tail -20)

echo -e "Files Modified Within One Day:\n${GREEN}$edited${NC}"
echo -e "Schedule Task(s) for Root:${GREEN}"
echo -n "$(sudo crontab -l -u root)${NC}"
echo -e "Root Password Information:\n${GREEN}$rootpasswd${NC}"
echo -e "Executable Files Modified Within Five Days:\n${GREEN}$executable${NC}"
echo -e "SSH Connections:\n${GREEN}$sshconn${NC}"

echo -e "\nThe script has concluded."

                                                                                   9,48          Top
