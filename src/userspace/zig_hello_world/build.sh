set -e

ZIG=zig

$ZIG build-obj ./main.zig -target aarch64-freestanding-none -O Debug -fno-stack-protector  -femit-bin=$BYPRODUCTS/init.o -mcpu=generic+strict_align

cp $BYPRODUCTS/init.o $OUT/init.o
