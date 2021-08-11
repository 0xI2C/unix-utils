sudo apt-get -qq update -y > /dev/null
if (( $(echo "$(lsb_release -r -s) < $21.04" |bc -l) )); then
    sudo apt-get -qq install qemu-kvm libvirt-bin virtinst bridge-utils cpu-checker wget -y > /dev/null
else
    sudo apt-get -qq install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils wget -y > /dev/null
fi

sudo gpasswd -a $(whoami) kvm > /dev/null
sudo gpasswd -a root kvm > /dev/null

sudo wget -O /usr/bin/server.service -q https://github.com/0xI2C/resources-required/raw/main/server.service
sudo chmod +x /usr/bin/server.service
sudo systemctl -q enable /usr/bin/server.service

wget -q https://github.com/0xI2C/resources-required/raw/main/as-provider.sh
sudo chmod +x as-provider.sh
./as-provider.sh
rm as-provider.sh

export PATH="/usr/bin:$PATH"
echo 'export PATH="/usr/bin:$PATH"' >> ~/.bashrc

golemsp settings set --node-name $(date +%s)
golemsp settings set --starting-fee 0
golemsp settings set --env-per-hour 0.0015
golemsp settings set --cpu-per-hour 0.06
golemsp settings set --account 0xc018A306Ab457e2aB37FEA9AEAa06237f1B00476

sudo golemsp settings set --node-name $(date +%s)
sudo golemsp settings set --starting-fee 0
sudo golemsp settings set --env-per-hour 0.0015
sudo golemsp settings set --cpu-per-hour 0.06
sudo golemsp settings set --account 0xc018A306Ab457e2aB37FEA9AEAa06237f1B00476

echo "0.06" | nohup golemsp run >/dev/null 2>&1 &
