const println = @import("uart.zig").println;

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
// MAIN SYSCALL HANDLER
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
    _ = arg0; // autofix
    _ = arg1; // autofix
    _ = arg2; // autofix
    _ = arg3; // autofix
    _ = arg4; // autofix
    _ = arg5; // autofix
    _ = arg6; // autofix
    _ = arg7; // autofix
    println("hello, this is an interupt, it will now return");
    return 42;
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
