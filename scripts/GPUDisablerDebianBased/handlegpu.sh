#!/bin/bash
if [[ "$(prime-select query)" = "intel" ]]; then
	# load acpi_call
	echo "Loading acpi_call..."
	modprobe acpi_call

	# power off GPU
	echo "Powering off GPU..."
	echo '\_SB.PCI0.PEG0.PEGP._OFF' > /proc/acpi/call
	sleep 0.5

	# cat to confirm - if the output is Error*, it failed
	echo "Power off resulted in:"
	cat /proc/acpi/call

	# unload nvidia related modules
	echo "Removing nvidia related modules..."
	modprobe -r nvidia_drm
	modprobe -r nvidia_uvm
	modprobe -r nvidia_modeset
	modprobe -r nvidia

	# remove PCI device so it cannot be detected
	echo "Removing nvidia PCI device..."
	echo -n 1 > /sys/bus/pci/devices/0000\:00\:01.0/remove
	sleep 0.5

	# power off GPU again, just in case
	echo "Powering off GPU again..."
	echo '\_SB.PCI0.PEG0.PEGP._OFF' > /proc/acpi/call
	sleep 0.5

	echo "Turned off GPU, removed the PCI device, unloaded related modules successfully!"
else
	echo "nvidia profile selected - not disabling GPU"
fi
