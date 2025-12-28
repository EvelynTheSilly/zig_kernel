CROSS=aarch64-none-elf

$CROSS-as -c test.s -o $BYPRODUCTS/init.o

cp $BYPRODUCTS/init.o $OUT/init.o
