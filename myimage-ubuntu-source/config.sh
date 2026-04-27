#!/bin/bash
set -e

# 1. Force GRUB to use the unified 'linux' and 'initrd' commands
# This is the industry-standard fix for Ubuntu 24.04 cloud images
echo 'GRUB_DISABLE_LINUX_EFI_COMMANDS="true"' >> /etc/default/grub

# 2. Patch the existing variable definitions in the generated config
# Sometimes update-grub still misses these in a chroot environment
if [ -f /boot/grub/grub.cfg ]; then
    sed -i 's/set linux="linuxefi"/set linux="linux"/g' /boot/grub/grub.cfg
    sed -i 's/set initrd="initrdefi"/set initrd="initrd"/g' /boot/grub/grub.cfg
    # Also handle the direct commands just in case
    sed -i 's/linuxefi/linux/g' /boot/grub/grub.cfg
    sed -i 's/initrdefi/initrd/g' /boot/grub/grub.cfg
fi

# 3. Regenerate to seal the deal
update-grub

exit 0
