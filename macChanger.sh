#!/bin/bash

echo "Hey there folks! Lets change mac address!"

echo "Turning off wifi"
nmcli radio wifi off

mac=$(c=0;until [ $c -eq "6" ];do printf ":%02X" $(( $RANDOM % 256 ));let c=c+1;done|sed s/://)
echo "Generated new mac:" $mac

echo "Setting new mac address"
ip link set dev wlp1s0
ip link set dev wlp1s0 address $mac

echo "Turning on wifi"
nmcli radio wifi on

urlm=${mac//:/$'%3A'}

#wait for ssid
while [[ 1 ]]
do
   SSID=$(iwgetid -r)

   echo "UrlMac:"$urlm
   echo "SSID:"$SSID

   if [[ "$SSID" = "FrenGP-Hoste-5_GHz" ]]; then
    echo "SSSID has matched! Trying to authenticate..."
    curl "https://gateway.frengp.cz/login?dst=&username=T-"$urlm
    break
   else
    echo "Waiting: Strings are not equal: " $SSID " Required: FrenGP-Hoste-5_GHz"
   fi
done
