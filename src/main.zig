pub const panic = std.debug.FullPanic(kernel_panic);
const std = @import("std");
const uart = @import("uart.zig");
const println = @import("uart.zig").println;

// Simple memcpy implementation
pub export fn memcpy(dest: [*]u8, src: [*]const u8, n: usize) [*]u8 {
    var i: usize = 0;
    while (i < n) : (i += 1) {
        dest[i] = src[i];
    }
    return dest;
}

// Simple memset implementation
pub export fn memset(s: [*]u8, c: u8, n: usize) [*]u8 {
    var i: usize = 0;
    while (i < n) : (i += 1) {
        s[i] = c;
    }
    return s;
}
// 1mb heap buffer
const aligned_alloc = struct {
    var buffer: [1024 * 1024]u8 align(16) = undefined;
};

pub export fn _entry() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    println("welcome!");
    uart.UARTWriter.print("this is a hello world example!", .{}) catch @panic("failed to print line");
    println("now i will fire an interupt");
    asm volatile (
        \\                                                           //set up stack pointer for EL0
        \\ ldr x0, =el0_stack_top
        \\ msr sp_el0, x0            // SP_EL0 = top of user stack
        \\                                                           // set up SPSR_EL1 to enter EL0, using AArch64, interrupts masked
        \\                                                           // M[4:2]=0b000 for EL0t
        \\                                                           // D/I/A/F bits mask exceptions if needed
        \\ mov x1, #0                                                // SPSR_EL1 value
        \\ msr spsr_el1, x1                                          // SPSR_EL1 = EL0 flags
        \\                                                           // set ELR_EL1 = address of first instruction in EL0
        \\ ldr x2, =el0_start
        \\ msr elr_el1, x2
        \\ eret                                                      // jumps into EL0
    );
    println("welcome!");
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

// usermode interupts
pub export fn el0_sync_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("user sync interupt");
}

pub export fn el0_irq_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("user irq interupt");
}

pub export fn el0_fiq_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("user fiq interupt");
}

pub export fn el0_serror_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("user serror interupt");
}

// kernel mode interupts
pub export fn el1_sync_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    println("el1 sync interupt (syscall) hit, lets hope this doesnt require a crash lol");
}

pub export fn el1_irq_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("kernel irq interupt");
}

pub export fn el1_fiq_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("kernel fiq interupt");
}

pub export fn el1_serror_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("kernel serror interupt");
}

// hypervisor interupts
pub export fn el2_sync_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("HV sync interupt");
}

pub export fn el2_irq_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("HV irq interupt");
}

pub export fn el2_fiq_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("HV fiq interupt");
}

pub export fn el2_serror_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("HV serror interupt");
}
