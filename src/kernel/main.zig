pub const panic = std.debug.FullPanic(kernel_panic);
const std = @import("std");
const uart = @import("uart.zig");
const interupts = @import("interupts/interupts.zig");
const println = @import("uart.zig").println;
const libc = @import("Libc");

comptime {
    _ = libc.export_symbols();
    _ = interupts;
}

pub export fn _entry() align(16) void {
    println("booting up ESTROS");
    println("dont forget to take your meds :3");
    println("");
    println("");
    println("-------------------");
    println(" welcome to ESTROS");
    println("-------------------");
    println("starting userland init :3");
    println("");
}

// Basic panic _handler
pub fn kernel_panic(msg: []const u8, _: ?usize) noreturn {
    // Print the panic message
    println("");
    println("");
    println("");
    println("KERNEL PANIC");
    println("---------------------------");
    println(msg);
    println("---------------------------");
    println("exit with ctrl + a, x");

    while (true) {
        asm volatile ("wfi");
    }
}
