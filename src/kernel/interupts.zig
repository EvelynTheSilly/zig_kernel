const println = @import("uart.zig").println;
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
    arg0: i64, // syscall ID
    arg1: i64, // arg 1
    arg2: i64, // arg 2
    arg3: i64, // arg 3
    arg4: i64, // arg 4
    arg5: i64, // arg 5
    arg6: i64, // arg 6
    arg7: i64, // arg 7
) align(16) callconv(.c) i64 {
    _ = arg3; // autofix, stops "unused function arguments" errors via explicit discarding
    _ = arg4; // autofix, stops "unused function arguments" errors via explicit discarding
    _ = arg5; // autofix, stops "unused function arguments" errors via explicit discarding
    _ = arg6; // autofix, stops "unused function arguments" errors via explicit discarding
    _ = arg7; // autofix, stops "unused function arguments" errors via explicit discarding
    const return_value: i64 = switch (arg0) {
        // requires arg1 to be a pointer to a array u8s and len to be the length of said array
        1 => syscalls.uart_print(@as([*]const u8, @ptrFromInt(@as(usize, @bitCast(arg1))))[0..@as(usize, @bitCast(arg2))]),
        // The answer to life, the universe, and everything /j
        42 => 42,
        // invalid ID, returns -1 as error code for that
        else => -1,
    };
    println("hello, this is an interupt, it will now return");
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
