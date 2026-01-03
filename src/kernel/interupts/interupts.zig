const println = @import("../uart.zig").println;
const uart = @import("../uart.zig");
const syscalls = @import("syscalls/mod.zig");

// current el interupts
// sp0
pub export fn el1_sp0_sync_handler() align(16) callconv(.c) void {
    @panic("kernel sp0 sync interupt");
}

pub export fn el1_sp0_irq_handler() align(16) callconv(.c) void {
    @panic("kernel sp0 irq interupt");
}

pub export fn el1_sp0_fiq_handler() align(16) callconv(.c) void {
    @panic("kernel sp0 fiq interupt");
}

pub export fn el1_sp0_serror_handler() align(16) callconv(.c) void {
    @panic("kernel sp0 serror interupt");
}

// spx
pub export fn el1_spx_sync_handler() align(16) callconv(.c) void {
    @panic("kernel spx sync interupt");
}

pub export fn el1_spx_irq_handler() align(16) callconv(.c) void {
    @panic("kernel spx irq interupt");
}

pub export fn el1_spx_fiq_handler() align(16) callconv(.c) void {
    @panic("kernel spx fiq interupt");
}

pub export fn el1_spx_serror_handler() align(16) callconv(.c) void {
    @panic("kernel spx serror interupt");
}

// lower el interupts
// aarch64
/// MAIN SYSCALL HANDLER
/// syscall convention:
/// - x0 syscall id
/// - x1-7 args, all pointer sized
pub export fn el0_aarch64_sync_handler(
    arg0: usize, // syscall ID
    arg1: usize, // arg 1
    arg2: usize, // arg 2
    arg3: usize, // arg 3
    arg4: usize, // arg 4
    arg5: usize, // arg 5
    arg6: usize, // arg 6
    arg7: usize, // arg 7
) align(16) callconv(.c) isize {
    _ = arg3; // autofix
    _ = arg4; // autofix
    _ = arg5; // autofix
    _ = arg6; // autofix
    _ = arg7; // autofix
    //uart.UARTWriter.print("recieved syscall {}\n", .{arg0}) catch @panic("failed to print");
    //uart.UARTWriter.print("--- arg dump: --- \n{}\n{}\n{}\n{}\n{}\n{}\n{}\n", .{ arg1, arg2, arg3, arg4, arg5, arg6, arg7 }) catch @panic("failed to print");
    const return_value: isize = switch (arg0) {
        // write, requires arg1 to be a pointer to a array u8s and len to be the length of said array
        1 => syscalls.uart_print(@as([*]const u8, @ptrFromInt(arg1))[0..arg2]),
        // read, pass in a buffer, and the amount you want to read, returns amount of bytes read
        2 => syscalls.uart_read(@as([*]u8, @ptrFromInt(arg1))[0..arg2]),
        // The answer to life, the universe, and everything /j
        42 => 42,
        // invalid ID, returns -1 as error code for that
        else => -1,
    };
    return return_value;
}

pub export fn el0_aarch64_irq_handler() align(16) callconv(.c) void {
    @panic("user aarch64 irq interupt");
}

pub export fn el0_aarch64_fiq_handler() align(16) callconv(.c) void {
    @panic("user aarch64 fiq interupt");
}

pub export fn el0_aarch64_serror_handler() align(16) callconv(.c) void {
    @panic("user aarch64 serror interupt");
}

// aarch32
pub export fn el0_aarch32_sync_handler() align(16) callconv(.c) void {
    @panic("user aarch32 sync interupt");
}

pub export fn el0_aarch32_irq_handler() align(16) callconv(.c) void {
    @panic("user aarch32 irq interupt");
}

pub export fn el0_aarch32_fiq_handler() align(16) callconv(.c) void {
    @panic("user aarch32 fiq interupt");
}

pub export fn el0_aarch32_serror_handler() align(16) callconv(.c) void {
    @panic("user aarch32 serror interupt");
}
