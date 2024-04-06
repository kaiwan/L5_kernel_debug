#!/bin/bash
#
# gdbline module image
#
# Outputs an add-symbol-file line suitable for pasting into gdb to examine
# a loaded module.
# (Here used in conjunction with the hello_gdb.ko kernel module; gdb demo).
# 
# [minor changes, kaiwan]
# Turn on unofficial Bash 'strict mode'! V useful
# "Convert many kinds of hidden, intermittent, or subtle bugs into immediate, glaringly obvious errors"
# ref: http://redsymbol.net/articles/unofficial-bash-strict-mode/ 
set -euo pipefail

name=$(basename $0)
[[ $(id -u) -ne 0 ]] && {
	echo "${name} requires root."
	exit 1
}
if [[ $# -ne 2 ]]; then
	echo "Usage: $0 module-name image-filename"
	echo "  module-name: name of the (already inserted) kernel module (without the .ko)"
	echo "  image-filename: pathname to the kernel module."
	exit 1
fi
if [[ ! -d /sys/module/$1/sections ]]; then
	echo "$0: module not loaded OR $1 not a valid name"
	exit 1
fi
if [[ ! -f $2 ]]; then
	echo "$0: $2 not a valid file"
	exit 1
fi

cd /sys/module/$1/sections
echo "Copy-paste the following lines into GDB"
echo "---snip---"

# Don't issue newlines and the continuation \ ; results in GDB err:
# Unrecognized argument "
# "
[[ -f .text ]] && {
   sudo echo -n "add-symbol-file $2 `/bin/cat .text` "
   #sudo echo  " \\"
} || [[ -f .init.text ]] && {
   sudo echo -n "-s .init.text `/bin/cat .init.text` "
}

for section in .[a-z]* *; do
    if [[ ${section} != ".text" || ${section} != ".init.text" ]]; then
	sudo echo -n " -s" ${section} `/bin/cat ${section}`
    fi
done
echo "
---snip---"
echo
