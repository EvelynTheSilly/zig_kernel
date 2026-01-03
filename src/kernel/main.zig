pub const panic = std.debug.FullPanic(kernel_panic);
const std = @import("std");
const uart = @import("uart.zig");
const interupts = @import("interupts.zig");
const println = @import("uart.zig").println;
const libc = @import("Libc");

comptime {
    _ = libc.export_symbols();
    _ = interupts;
}

// 1mb heap buffer
const aligned_alloc = struct {
    var buffer: [1024 * 1024]u8 align(16) = undefined;
};

fn drop_to_el1() void {
    asm volatile (
        \\                          //set up stack pointer for EL0
        \\ ldr x0, =el0_stack_top
        \\ msr sp_el0, x0           // SP_EL0 = top of user stack
        \\                          // set up SPSR_EL1 to enter EL0, using AArch64, interrupts masked
        \\                          // M[4:2]=0b000 for EL0t
        \\                          // D/I/A/F bits mask exceptions if needed
        \\ mov x1, #0               // SPSR_EL1 value
        \\ msr spsr_el1, x1         // SPSR_EL1 = EL0 flags
        \\                          // set ELR_EL1 = address of first instruction in EL0
        \\ ldr x2, =_INIT
        \\ msr elr_el1, x2
        \\ eret                     // jumps into EL0
    );
}

pub export fn _entry() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    println("booting up ESTROS");
    println("dont forget to take your meds :3");
    println("");
    println("");
    println("-------------------");
    println(" welcome to ESTROS");
    println("-------------------");
    println("starting init process :3");
    println("");
    drop_to_el1();
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
