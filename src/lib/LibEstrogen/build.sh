set -e

ZIG=zig

$ZIG build-obj -fno-emit-bin ./check.zig
