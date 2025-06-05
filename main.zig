pub const panic = std.debug.FullPanic(kernel_panic);
const std = @import("std");

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

fn print_uart_buffer(msg: []const u8) void {
    for (msg) |c| {
        UART_DATA_REGISTER.* = c;
    }
}

fn print_uart_char(char: u8) void {
    UART_DATA_REGISTER.* = char;
}

fn println(msg: []const u8) void {
    print_uart_buffer(msg);
    print_uart_char('\n'); // newline
}

fn uart_has_input() bool {
    return (UART_FLAG_REGISTER.* & UART_FLAG_RXFE) == 0; // apply the bitmask to the value in the register
}

fn uart_read_char() u8 {
    while (!uart_has_input()) {}
    return UART_DATA_REGISTER.*;
}

fn print_uart(msg: std.ArrayList(u8)) void {
    for (msg) |c| {
        UART_DATA_REGISTER.* = c;
    }
}

fn readLine(allocator: std.mem.Allocator) ![]u8 {
    var buffer = std.ArrayList(u8).init(allocator);
    defer buffer.deinit(); // Ensure cleanup on error

    while (true) {
        const byte = uart_read_char();
        print_uart_char(byte);

        if (byte == 13) break;
        try buffer.append(byte);
    }

    return buffer.toOwnedSlice();
}

// 1mb heap buffer
const aligned_alloc = struct {
    var buffer: [1024 * 1024]u8 align(16) = undefined;
};

pub export fn c_entry() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    var fixed_allocator align(16) = std.heap.FixedBufferAllocator.init(&aligned_alloc.buffer); // the init function also finishes, but the asembly between the init function and the next line doesnt finish
    const allocator align(16) = fixed_allocator.allocator();
    println("this is a hello world example");
    print_uart_char(uart_read_char());
    while (true) {
        const char = uart_read_char();
        if (char == 13) {
            break;
        }
        print_uart_char(char);
    }
    println("");

    const line = readLine(allocator) catch @panic("failed to read line");
    println("");
    print_uart_buffer(line);
    println("");

    println("exiting");
    @panic("kernel panic test");
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
