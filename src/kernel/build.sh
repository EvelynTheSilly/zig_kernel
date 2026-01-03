set -e

ZIG=zig
CROSS=aarch64-none-elf


$ZIG build

# Assemble startup
$CROSS-as -c ./boot.s -o $BYPRODUCTS/boot.o

# Link kernel
$CROSS-ld -r $BYPRODUCTS/boot.o $BYPRODUCTS/kernel.o -o $OUT/kernel.o
