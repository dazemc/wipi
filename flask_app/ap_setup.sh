apt update && apt install iwd
rm -f /etc/NetworkManager/conf.d/iwd.conf && touch /etc/NetworkManager/conf.d/iwd.conf
echo -e "[device]\nwifi.backend=iwd" | tee /etc/NetworkManager/conf.d/iwd.conf
systemctl disable wpa_supplicant && systemctl enable iwd
reboot & exit