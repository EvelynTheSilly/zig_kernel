// simple mem move implementation
// the see me moving, they hating
pub export fn memmove(dst: [*]u8, src: [*]const u8, n: usize) void {
    if (dst == src or n == 0) return;

    const dst_addr = @intFromPtr(dst);
    const src_addr = @intFromPtr(src);

    if (dst_addr < src_addr or dst_addr >= src_addr + n) {
        // Non-overlapping or dst before src → copy forward
        var i: usize = 0;
        while (i < n) : (i += 1) {
            dst[i] = src[i];
        }
    } else {
        // Overlapping and dst > src → copy backward
        var i: usize = n;
        while (i > 0) : (i -= 1) {
            dst[i - 1] = src[i - 1];
        }
    }
}
