#!/bin/bash
# DEBIAN IMAGE BUILDER: SYSTEM MENU INTERFACE
# Description: SYSTEM MENU INTERFACE
# Destination: /usr/local/bin/menu-config
HA_NOTES="The following install has been tested on the Odroid N2+ and Raspberry Pi 4B. \
An individual also reported success on Banana Pi M5 by selecting odroid N2 in response \
to the actual HA supervisor install script. I do not use audio out of my smart home \
controller, so I have not vailidated that the HA audio container works correctly. Other \
than that, this will give you a good platform for HA. If you use this install on the \
Raspberry Pi, I'd recommend using an "A1" SDCARD. On the Odroid N2+ I recommend \
using an eMMC. The OS is arm64, which matters when the final HA install script \
runs and you are asked to select the platform."

homeAssistant(){
clear -x
echo "Installing Home Assistant ..."

# install docker
curl -fsSL get.docker.com | sh

# install HA required packages
sudo apt-get update; sudo apt-get -y upgrade
sudo apt-get -y install apparmor jq wget curl udisks2 libglib2.0-bin network-manager dbus lsb-release systemd-journal-remote

# install agent required by ha
wget -cq --show-progress \
https://github.com/home-assistant/os-agent/releases/download/1.2.2/os-agent_1.2.2_linux_aarch64.deb
sudo dpkg -i os-agent_1.2.2_linux_aarch64.deb

# enabed service required by HA
# sudo systemctl enable systemd-resolved.service
# sudo systemctl start systemd-resolved.service

# need to fake grub so HA will install
# sudo touch /etc/default/grub
# echo '#!/bin/bash' | sudo tee /usr/bin/update-grub
# echo 'echo got it' | sudo tee -a /usr/bin/update-grub
# sudo chmod 755 /usr/bin/update-grub


# add some kernel arguments, some that are required, some that look to make system more stable
#if [[ -f "/boot/extlinux/extlinux.conf" ]]; then
	#sudo sed -i '/append / s/$/ systemd.unified_cgroup_hierarchy=false systemd.legacy_systemd_cgroup_controller=false usbcore.autosuspend=-1 usbcore.autosuspend=-1 clk_ignore_unused cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory apparmor=1 security=apparmor/' /boot/extlinux/extlinux.conf;
#fi
#if [[ -f "/boot/${FAMILY}/extlinux/extlinux.conf" ]]; then
	#sudo sed -i '/append / s/$/ systemd.unified_cgroup_hierarchy=false systemd.legacy_systemd_cgroup_controller=false usbcore.autosuspend=-1 usbcore.autosuspend=-1 clk_ignore_unused cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory apparmor=1 security=apparmor/' /boot/${FAMILY}/extlinux/extlinux.conf;
#fi
sed '$a extraargs=apparmor=1 security=apparmor systemd.unified_cgroup_hierarchy=false' /boot/orangepiEnv.txt
# grab the HA supervisor package which will install HA
wget -cq --show-progress https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
sudo dpkg -i homeassistant-supervised.deb

# clean
#sleep 2s
#sudo apt autoremove -y
#if [ -f os-agent_1.2.2_linux_aarch64.deb ]; then rm -f os-agent_1.2.2_linux_aarch64.deb; fi
#if [ -f homeassistant-supervised.deb ]; then rm -f homeassistant-supervised.deb; fi
