sudo apt-get install ldap-auth-client nscd
sudo auth-client-config -t nss -p lac_ldap

#ask user for confirmation to reboot
read -p "Is this your inet interface: $interface (y/n)? " choice
case "$choice" in
  y|Y ) reboot -n;;
  n|N ) exit 1;;
  * ) echo "invalid";;
esac
