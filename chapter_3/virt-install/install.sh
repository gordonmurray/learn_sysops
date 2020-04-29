sudo apt install qemu-kvm libvirt-bin virtinst -y
sudo apt install virtinst -y

# Create a VM with 8gb disk usin the CLI

virt-install \
--name ubuntu \
--description "Our first VM" \
--ram 1024 \
--disk path=/var/lib/libvirt/images/ubuntu.img,size=10 \
--vcpus 2 \
--virt-type kvm \
--os-type linux \
--os-variant ubuntu18.04 \
--graphics none \
--location 'http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/' \
--extra-args console=ttyS0

Dont forget to install openSSH server, so we can SSH in later.

# list VMs

virsh list

# Get IP
$ virsh list
$ virsh dumpxml VM_NAME | grep "mac address" 
$ arp -an | grep 52:54:00:ce:8a:c4

# bridge

edit  /etc/netplan/cloud-init.yml

change from

etwork:
  version: 2
  ethernets:
    ens33:
      dhcp4: no
      dhcp6: no

to

 bridges:
    br0:
      interfaces: [ens33]
      dhcp4: no
      addresses: [192.168.0.51/24]
      gateway4: 192.168.0.1
      nameservers:
        addresses: [192.168.0.1]

( change the ethernat name to suit)

sudo virt-install  -n DB-Server  --description "Test VM for Database"  --os-type=Linux  --os-variant=rhel7  --ram=1096  --vcpus=1  --disk path=/var/lib/libvirt/images/dbserver.img,bus=virtio,size=10  --network bridge:br0 --graphics none  --location /home/linuxtechi/rhel-server-7.3-x86_64-dvd.iso --extra-args console=ttyS0