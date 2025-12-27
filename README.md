# EstrOS
a kernel/operating system written in zig 

## why?
originally i got inspired to work on this 

## developing
<sub>why would anyone ever wanna use this but me :thinking:</sub>

enter the dev environment
~~~sh
nix develop # if you dont use nix.... too bad? you can find the package list in the flake
~~~
run with
~~~sh
mask cbr # cleans/builds/runs the project
~~~
debug with 
~~~sh
# terminal 1
mask debug

# terminal 2
mask start_gdb
~~~

## credits
- based on [aarch64-bare-metal-qemu](https://github.com/freedomtan/aarch64-bare-metal-qemu/tree/master)
- adapted into zig by evelyn
- name by evelyn (not the same evelyn as above)
- heavily insipired to do any of this in the first place by [developed from scratch](https://www.youtube.com/@DevelopedFromScratch)
