#!/bin/bash

############
## CONFIG ##
############

host="google.com"

# Your public IP
monIp="10.10.10.10"

# Path to your wireguard config files
path="/path/to/WG_FILES"

###############
## TEST PING ##
###############

# Check your public IP
ip=$(curl -s ifconfig.me)

# Check if connected to internet
ping -c 1 "$host" > /dev/null 2>&1
alive=$?

#####################################
## DOWN INTERFACE AND RECONNECTION ##
#####################################

# If connection OK and if your public IP is not your normal IP
if [ "$alive" = 0 ] && [ "$ip" != "$monIp" ]; then
	exit
else
	# If something is wrong, get the interface name, disconnected and reconnect
	interfaces=$(ifconfig -a | sed 's/[ \t:].*//;/^$/d')
	wgInterfaces=$(echo "$interfaces" | sed 's/eth0\|lo\|wlan0\| //g')
	sudo wg-quick down "$wgInterfaces"
	sleep 1
	
	# Script for random connction if you have many files
	"$path"/random_connection_wg.sh
fi
