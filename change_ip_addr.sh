# read inet interfaces
OUTPUT="$(ifconfig | grep ': ')"
#echo "${OUTPUT}"

#get position of substing
strindex() { 
  x="${1%%$2*}"
  [[ "$x" = "$1" ]] && echo -1 || echo "${#x}"
}

#get name of inet interface
x=$(strindex "${OUTPUT}" ":")
interface=${OUTPUT:0:($x)}

#ask user for confirmation
read -p "Is this your inet interface: $interface (y/n)? " choice
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
# This file describes the network interfaces available on your system\n# For more information, see netplan(5).\nnetwork:\n  version: 2\n  renderer: networkd\n  ethernets:\n    $interface:\n      addresses: [$ip/24]\n      gateway4: $gateway\n      dhcp4: no\n      nameservers:\n        addresses: [$nameserver]\n
"
echo -e "\n"
echo -e "This is your new netplan: \n"
echo -e "$netplan"

#read out old netplan
netplanName="$(ls /etc/netplan/)"
echo "\n$netplanName"
echo -e "This is your old netplan:\n"
echo -e "$(cat /etc/netplan/$netplanName)"

#ask use for permission
read -p "Are you sure you want to change yout netplan (y/n)? " choice
case "$choice" in
  y|Y ) :;;
  n|N ) exit 1;;
  * ) echo "invalid";;
esac
> /etc/netplan/$netplanName
echo -e "$netplan" > /etc/netplan/$netplanName
sudo netplan apply /etc/netplan/$netplanName
