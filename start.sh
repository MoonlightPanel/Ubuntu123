#!/bin/bash
set -e
echo "Muốn bao nhiêu disk (ví dụ 128g thì ghi 128)"
read disk1
echo "Bạn muốn bao nhiêu ram (ví dụ 3gb thì ghi 3)"
read ram1
DISK="/data/vm.qcow2"
IMG="/opt/qemu/ubuntu.img"
SEED="/opt/qemu/seed.iso"
DISK1="$disk1"
RAM="$ram1"
echo "Creating VM disk..."
qemu-img convert -f qcow2 -O qcow2 "$IMG" "$DISK"
qemu-img resize "$DISK" "$DISK1"G
# Start VM
qemu-system-x86_64 \
    -m "$RAM"G \
    -cpu max \
    -accel tcg,thread=multi \
    -drive file="$DISK",format=qcow2,if=virtio \
    -drive file="$SEED",format=raw,if=virtio \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -device virtio-net,netdev=net0 \
    -vga virtio \
    -nographic
