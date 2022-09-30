#!/bin/bash

############
## CONFIG ##
############

host="google.com"

# Your public IP
monIp="10.10.10.10"

# Path to your wireguard config files
path="/path/to/WG_FILES"

# Name for grep command
nameInterface="WG"

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
	interface=$(ifconfig -a | grep "$nameInterface" | grep -wv "inet" | sed 's/:.*$//g')
	sudo wg-quick down "$interface"
	sleep 1
	# Script for random connction if you have many files
	"$path"/random_connection_wg.sh
fi
