# activate access.conf
last_line="$(tail -1 /etc/pam.d/sshd)"
#µµecho $last_line
if [ "$last_line" = "account  required     pam_access.so" ]; then
    echo "access.conf already activated"
else
    echo -e "\n# line added by edit_access_to_server.sh\naccount  required     pam_access.so" >> /etc/pam.d/sshd
    echo "activated access.conf"
fi

#ask user to edit acces.conf
read -p "Do you want to edit the access.conf (y/n)? " choice
case "$choice" in
  y|Y ) sudo vim /etc/security/access.conf;;
  n|N ) exit 1;;
  * ) echo "invalid";;
esac
