const std = @import("std");

fn print_uart(msg: []const u8) void {
    const UART0: *volatile u8 = @ptrFromInt(0x09000000);

    for (msg) |c| {
        UART0.* = c;
    }
}

pub export fn c_entry() callconv(.C) void {
    const msg = "Hello Zig World!\n";
    print_uart(msg);

    while (true) {} // halt
}
