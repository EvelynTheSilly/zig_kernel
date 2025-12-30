const syscalls = @import("syscalls/mod.zig");
pub const print = syscalls.write;

pub fn println(msg: []const u8) void {
    _ = print(msg);
    _ = try printbyte('\n');
}
pub fn printbyte(byte: u8) !isize {
    return print(&[_]u8{byte});
}

pub fn readbytes(amount: usize) ![]u8 {
    // make buffer
    var buffer: [amount]u8 = undefined;

    // modifies buffer and returns bytes read
    const bytes_read = syscalls.read(buffer[0..]);

    // if its not an error
    if (bytes_read >= 0) {
        return buffer[0..bytes_read];
    }

    return anyerror;
}

pub fn readbyte() ?u8 {
    // make buffer
    var buffer: [1]u8 = undefined;

    // modifies buffer and returns bytes read
    const bytes_read = syscalls.read(buffer[0..]);

    if (bytes_read < 0) return null;
    if (bytes_read == 0) return null;
    if (bytes_read == 1) return buffer[0];
    if (bytes_read > 1) unreachable;
    unreachable;
}

pub fn readuntil(char: u8, buffer: []u8) !usize {
    if (buffer.len == 0) return 0;
    var index: usize = 0;
    while (index < buffer.len) : (index += 1) {
        const byte: ?u8 = readbyte() orelse null;
        if (byte) |b| {
            _ = try printbyte(b);
            if (b == char) {
                return index;
            }
            buffer[index] = b;
        } else {}
    }
    return index;
}
