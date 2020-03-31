# read inet interfaces
OUTPUT="$(ifconfig | grep ': ')"
#echo "${OUTPUT}"

#get position of substing
strindex() { 
  x="${1%%$2*}"
  [[ "$x" = "$1" ]] && echo -1 || echo "${#x}"
}

#get name of inet interface
interface=$(strindex "${OUTPUT}" ":")
interface=${OUTPUT:0:($interface)}

#ask user for confirmation
read -p "Is this your inet interface: $x (y/n)? " choice
case "$choice" in
  y|Y ) :;;
  n|N ) exit 1;;
  * ) echo "invalid";;
esac

#ask user for new ip
echo Enter the new IPv4:
read ip

#ask user for gateway ip
echo Enter the gateway IPv4:
read gateway

#ask user for nameserver ip
echo Enter the nameserver IPv4:
read nameserver

#prepare netplan file
netplan="
# This file describes the network interfaces available on your system\n# For more information, see netplan(5).\nnetwork:\n\tversion: 2\n\trenderer: networkd\n\tethernets:\n\t\t$interface:\n\t\t\taddresses: [$ip/24]\n\t\t\tgateway4: $gateway\n\t\t\tdhcp4: no\n\t\t\tnameservers:\n\t\t\t\taddresses: [$nameserver]\n
"
> ./netplan.net
echo -e $netplan >> ./netplan.net
