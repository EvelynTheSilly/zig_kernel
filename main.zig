const std = @import("std");

fn print_uart(msg: []const u8) void {
    const UART0: *volatile u8 = @ptrFromInt(0x09000000);

    for (msg) |c| {
        UART0.* = c;
    }
}

fn println(comptime msg: []const u8) void { // msg must be fully known at comp time
    const new_msg = msg ++ "\n";
    print_uart(new_msg);
}

pub export fn c_entry() callconv(.C) void {
    println("this is a hello world example");
    println("this is running on a bare metal machine");
    println("there is no operating system");
    println("no windows, no linux, no MacOS");
    println("only my own code");
    println("perfectly balanced, as all things should be");

    while (true) {} // halt
}
