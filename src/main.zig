pub const panic = std.debug.FullPanic(kernel_panic);
const std = @import("std");
const uart = @import("uart.zig");
const println = @import("uart.zig").println;

const UART_BASE: u64 = 0x09000000;
const UART_DATA_REGISTER: *volatile u8 = @ptrFromInt(UART_BASE + 0x00); // Data register (read/write)
const UART_FLAG_REGISTER: *volatile u8 = @ptrFromInt(UART_BASE + 0x18); // Flag register
const UART_FLAG_RXFE: u8 = (1 << 4); // flag register bitmask (00010000)
const UART_INTERRUPT_MASK_REGISTER: *volatile u8 = @ptrFromInt(UART_BASE + 0x38); // Interrupt mask register (optional)
const UART_INTERRUPT_CLEAR_REGISTER: *volatile u8 = @ptrFromInt(UART_BASE + 0x44); // Interrupt clear register (optional)

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
    defer @panic("kernel exit");
    println("welcome!");
    uart.UARTWriter.print("this is a hello world example!", .{}) catch @panic("failed to print line");
}

// Basic panic handler
pub fn kernel_panic(msg: []const u8, _: ?usize) noreturn {
    // Print the panic message
    println("KERNEL PANIC");
    println("---------------------------");
    println(msg);
    println("---------------------------");
    println("exit with ctrl + a, x");

    while (true) {
        asm volatile ("wfi");
    }
}
