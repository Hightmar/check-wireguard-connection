#!/bin/bash

path="/path/to/WG_FILES"

# Count all file.conf and put them in files[]
mapfile -t files < <(find "$path" -maxdepth 1 -type f -name "*.conf" | sort)

# Pick random number
nb=$(( RANDOM % ${#files[@]} ))

# Use random number as index and connect wireguard
sudo wg-quick up "${files[$nb]}"
