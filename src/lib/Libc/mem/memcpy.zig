// Simple memcpy implementation
pub export fn memcpy(dest: [*]u8, src: [*]const u8, n: usize) [*]u8 {
    var i: usize = 0;
    while (i < n) : (i += 1) {
        dest[i] = src[i];
    }
    return dest;
}
