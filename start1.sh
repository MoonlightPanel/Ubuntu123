#!/bin/bash
set -e
echo "Bạn muốn bao nhiêu disk tùy máy (ví dụ muốn 128G thì nhập 128)"
read disk1
echo "Muốn Ram bao nhiêu (ví dụ 1gb thì nhập 1)"
read ram1
DISK="/data/vm.raw"
IMG="/opt/qemu/ubuntu.img"
SEED="/opt/qemu/seed.iso"
DISK2="$disk1"
RAM2="$ram1"
if [ ! -f "$DISK" ]; then
 echo "Creating VM disk..."
 qemu-img convert -f qcow2 -O qcow2 "$IMG" "$DISK"
 qemu-img resize "$DISK" "$DISK2"G
fi
# Start VM
qemu-system-x86_64 \
    -m "$RAM2"G \
    -drive file="$DISK",format=qcow2,if=virtio \
    -drive file="$SEED",format=raw,if=virtio \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -device virtio-net,netdev=net0 \
    -vga virtio \
    -display vnc=:0 \
    -daemonize

# Start noVNC
websockify --web=/novnc 6080 localhost:5900 &

echo "================================================"
echo " 🖥️  VNC: http://localhost:6080/vnc.html"
echo " 🔐 SSH: ssh root@localhost -p 2222"
echo " 🧾 Login: root / root"
echo " Supported Code Sandbox (use ngrok or cloudflare)"
echo " Code By Snipavn/Snhvn (Github) Youtube: https://youtube.com/@snipavn205 & Youtube: HopingBoyz" 
echo "================================================"

echo "Muốn vào được web noVNC thì mở tab mới (Ctrl + B +C) nhập lệnh là cloudflared tunnel --url http://localhost:6080"

# Wait for SSH port to be ready
for i in {1..30}; do
  nc -z localhost 2222 && echo "✅ VM is ready!" && break
  echo "⏳ Waiting for SSH..."
  sleep 2
done

wait
