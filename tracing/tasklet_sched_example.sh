#!/bin/bash

# TODO
#   -d seconds
#   -p PID Only trace kernel functions when this process ID is on-CPU.
#   -L TID Only trace kernel functions when this thread ID is on-CPU.
#
# Kaiwan NB
# GPL-2.0

which kprobe-perf >/dev/null && KP=kprobe-perf
which kprobe >/dev/null && KP=kprobe
which ${KP} >/dev/null || {
  echo "Require the kprobe[-perf] utility installed.
(On Debian-type distros, the package is perf-tools[-unstable]"
  exit 1
}

echo "Will run this command:"
CMD="sudo ${KP} -s 'p:mytasklets __tasklet_schedule'"
#  -s     Print kernel stack traces after each event
echo "${CMD}"

MSG="
---
Once running, it displays (traces) all occurences of the __tasklet_schedule()
func being invoked (typically by drivers) along with the stack trace!
(read it bottom-up)..

As an interesting experiment, type a keyboard key: you should now see it
display the trace with the kstack for both the key-press and key-release
(On the x86, the flow involves:
 i8042 irq -> serio -> ps2 -> atkbd interrupt handler -> input_event() ->
   ...input layer handling... -> tasket_schedule() )

Requires kernel support: CONFIG_FTRACE=y and CONFIG_KPROBES=y
---
"
echo "${MSG}"
read -p "Press [Enter] to continue, ^C to abort..." re

eval "${CMD}"
