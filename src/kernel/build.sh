set -e

ZIG=zig
CROSS=aarch64-none-elf

$ZIG build

# Assemble startup
$CROSS-as -c ./asm/boot.s -o $BYPRODUCTS/boot.o
$CROSS-as -c ./asm/interupts.s -o $BYPRODUCTS/interupts.o

# Link kernel
$CROSS-ld -r $BYPRODUCTS/boot.o $BYPRODUCTS/kernel.o $BYPRODUCTS/interupts.o -o $OUT/kernel.o
