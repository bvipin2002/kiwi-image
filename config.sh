#!/bin/bash
set -e

echo "NPCI DevOps: Staging EFI bootloaders..."

# 1. Create the target directory inside the image root
mkdir -p /boot/efi/EFI/BOOT

# 2. Copy the signed Shim (the primary boot entry)
# We check both common signed locations
if [ -f /usr/lib/shim/shimx64.efi.signed ]; then
    cp /usr/lib/shim/shimx64.efi.signed /boot/efi/EFI/BOOT/BOOTX64.EFI
    echo "Found signed shim."
fi

# 3. Copy MokManager (mmx64) - sometimes not .signed in Noble
if [ -f /usr/lib/shim/mmx64.efi ]; then
    cp /usr/lib/shim/mmx64.efi /boot/efi/EFI/BOOT/mmx64.efi
elif [ -f /usr/lib/shim/mmx64.efi.signed ]; then
    cp /usr/lib/shim/mmx64.efi.signed /boot/efi/EFI/BOOT/mmx64.efi
fi

# 4. Copy the signed GRUB
if [ -f /usr/lib/grub/x86_64-efi-signed/grubx64.efi.signed ]; then
    cp /usr/lib/grub/x86_64-efi-signed/grubx64.efi.signed /boot/efi/EFI/BOOT/grubx64.efi
    echo "Found signed grub."
fi

# 5. Create the EFI-level grub.cfg
# This points GRUB to the real config on the main Linux partition (gpt3)
cat <<EOF > /boot/efi/EFI/BOOT/grub.cfg
set prefix=(hd0,gpt3)/boot/grub
configfile (hd0,gpt3)/boot/grub/grub.cfg
EOF

echo "EFI staging complete."
exit 0
