#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
DATA=$(curl -s https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes[]|"\(.ip_prefix),\(.region)"' | grep 'eu' | cut -d, -f1 | sed 's/\/32//')
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper delete firewall group address-group aws-eu-ip-range
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set firewall group address-group aws-eu-ip-range description "AWS EU IP Ranges"
for item in $DATA
do
  /opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set firewall group address-group aws-eu-ip-range address "$item"
done
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper commit
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper save
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper end

