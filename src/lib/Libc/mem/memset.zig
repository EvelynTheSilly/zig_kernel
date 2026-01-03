// Simple memset implementation
pub export fn memset(s: [*]u8, c: u8, n: usize) [*]u8 {
    var i: usize = 0;
    while (i < n) : (i += 1) {
        s[i] = c;
    }
    return s;
}
