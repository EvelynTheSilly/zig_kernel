# Tasks For My Project


## build

> Builds my project

~~~sh
echo "building project..."
set -e

ZIG=zig
CROSS=aarch64-none-elf
BUILD_DIR=build

mkdir -p $BUILD_DIR

# Compile Zig source to object file
$ZIG build-obj main.zig -target aarch64-freestanding-none -O ReleaseSmall -fno-stack-protector  -femit-bin=$BUILD_DIR/main.o

# Assemble startup
$CROSS-as -c boot.s -o $BUILD_DIR/boot.o

# Link everything
$CROSS-ld -T linker.ld $BUILD_DIR/boot.o $BUILD_DIR/main.o -o $BUILD_DIR/kernel.elf

# Optional: make binary
$CROSS-objcopy -O binary $BUILD_DIR/kernel.elf $BUILD_DIR/kernel.bin
~~~


## run

> runs the project in qemu (how the fuck do i exit qemu)

~~~sh
echo "running vm"
echo "exit with ctrl a, then x"
qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -kernel ./build/kernel.elf
~~~

## clean

> removes build artifacts from the directory

~~~sh
echo "cleaning"
rm -fr build
~~~

## cbr

> clean, build, run

~~~sh
mask clean
mask build
mask run
~~~
