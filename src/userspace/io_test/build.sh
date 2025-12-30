set -e

ZIG=zig

$ZIG build

#$ZIG build-obj  --dep LibEstrogen -Mmain=./main.zig -MLibEstrogen=../../lib/LibEstrogen -target aarch64-freestanding-none -O Debug -fno-stack-protector  -femit-bin=$BYPRODUCTS/init.o -mcpu=generic+strict_align

#cp $BYPRODUCTS/init.o $OUT/init.o
