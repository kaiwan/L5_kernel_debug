The kgdb_demo/image folder contains three large binaries:


`$ ls -lh image/`

`total 975M`

`-rw-rw-r-- 1 kaiwan kaiwan  23M Dec 19 12:56 bzImage`

`-rw-rw-r-- 1 kaiwan kaiwan 512M Dec 19 12:56 rootfs.img`

`-rwxrwxr-x 1 kaiwan kaiwan 491M Dec 19 12:56 vmlinux`

The `bzImage` kernel image file is within 100 MB and GitHub thus handles it, but the other two,
being very large, cannot be tracked.
To solve this, I've made a *Release* as GitHub allows releases to have large
(read-only) binaries!

So, to try out the `kgdb_demo`, please download the large rootfs.img and vmlinux files from the
release here:
https://github.com/kaiwan/L5_kernel_debug/releases/tag/v0.5_4kgdb-demo

