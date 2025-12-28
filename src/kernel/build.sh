set -e

ZIG=zig
CROSS=aarch64-none-elf

# Compile Zig source to object file
$ZIG build-obj ./main.zig -target aarch64-freestanding-none -O Debug -fno-stack-protector  -femit-bin=$BYPRODUCTS/main.o -mcpu=generic+strict_align

# Assemble startup
$CROSS-as -c ./boot.s -o $BYPRODUCTS/boot.o

# Link kernel
$CROSS-ld -r $BYPRODUCTS/boot.o $BYPRODUCTS/main.o -o $OUT/kernel.o
