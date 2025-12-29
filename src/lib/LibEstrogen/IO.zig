const syscalls = @import("syscalls/mod.zig");
pub const print = syscalls.write;

pub fn println(msg: []const u8) void {
    print(msg);
    print("\n");
}

pub fn readbytes(amount: usize) ![]u8 {
    // make buffer
    var buffer: [amount]u8 = undefined;

    // modifies buffer and returns bytes read
    const return_value = syscalls.read(&buffer);

    // if its not an error
    if (return_value >= 0) {
        return buffer[0..return_value];
    }

    return anyerror;
}
