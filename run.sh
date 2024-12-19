#!/bin/bash
# run2.sh
KVER=5.10.3
echo "Note:
We assume we're using kernel ${KVER} here.
1. If you don't already have it, install the ${KVER} kernel source tree
2. IF you do use the -enable-kvm accelerator switch, ensure you
   first shut down any other hypervisor instance
3. Once run, the guest qemu system will *wait* for GDB to connect from the host:
On the host, do:
$ cd <...>/${KVER}
$ gdb -q </path/to/>linux-${KVER}/vmlinux
OR
$ gdb -q </path/to/>/image/vmlinux
(gdb) target remote :1234
(gdb) <set your (h/w) breaskpoints etc ...>

"
echo "Verify we're indeed targeting the ${KVER} kernel:"
strings image/vmlinux |grep --color=auto -i "version.*5\.10\.3" --max-count=1 || echo "*WARNING* images/vmlinux is NOT kernel ver ${KVER} ?"

echo "
sudo qemu-system-x86_64 -kernel image/bzImage -append \"console=ttyS0 root=/dev/sda earlyprintk=serial nokaslr\" \
		-hda image/rootfs.img -net user,hostfwd=tcp::10021-:22 -net nic -enable-kvm -nographic -m 1G -smp 2 -S -s"
sudo qemu-system-x86_64 \
		-kernel image/bzImage \
		-append "console=ttyS0 root=/dev/sda earlyprintk=serial nokaslr" \
		-hda image/rootfs.img \
		-net user,hostfwd=tcp::10021-:22 -net nic \
		-nographic \
		-m 1G -smp 2 \
		-S -s
	#	-enable-kvm -nographic 
#qemu-system-x86_64 -kernel linux-5.10.3/arch/x86/boot/bzImage -append "console=ttyS0 root=/dev/sda earlyprintk=serial kgdboc=kbd,/dev/ttyS0,115200 nokaslr" -hda image/stretch.img -net user,hostfwd=tcp::10021-:22 -net nic -enable-kvm -nographic -m 2G -smp 2 -S -s

 # -S  Do not start CPU at startup (you must type 'c' in the monitor).
 # -s  Shorthand for -gdb tcp::1234, i.e. open a gdbserver on TCP port 1234.
 #format=raw
