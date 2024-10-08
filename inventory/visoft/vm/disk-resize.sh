#!/usr/bin/env bash

sudo virt-df -h -a workhorse_workhorse.img
sudo virt-df workhorse_workhorse.img
sudo qemu-img create -f qcow2 -o preallocation=metadata new-workhorse.qcow2 512G
sudo virt-resize --expand /dev/sda4 workhorse_workhorse.img new-workhorse.qcow2
sudo rm workhorse_workhorse.img
sudo mv new-workhorse.qcow2 workhorse_workhorse.img
