#!/bin/bash
set -e

echo "NPCI DevOps: Staging EFI binaries..."

# 1. Create the standard directory structure
mkdir -p /boot/efi/EFI/BOOT

# 2. Copy the binaries that were just downloaded/installed via apt
# These are the actual 'real' files that were missing before
cp /usr/lib/shim/shimx64.efi.signed /boot/efi/EFI/BOOT/BOOTX64.EFI
cp /usr/lib/grub/x86_64-efi-signed/grubx64.efi.signed /boot/efi/EFI/BOOT/grubx64.efi

# 3. Create the EFI-level grub.cfg stub
cat <<EOF > /boot/efi/EFI/BOOT/grub.cfg
search --no-floppy --file --set=root /boot/grub/grub.cfg
set prefix=(\$root)/boot/grub
configfile (\$root)/boot/grub/grub.cfg
EOF

echo "Staging complete."
