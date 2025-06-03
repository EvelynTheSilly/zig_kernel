# bare metal zig kernel
based on [aarch64-bare-metal-qemu](https://github.com/freedomtan/aarch64-bare-metal-qemu/tree/master)

adapted into zig by eve

works on elbow greace and magic

run with
~~~sh
nix develop # to enter dev environment
mask build # builds project
mask run # runs the vm using qemu
~~~
