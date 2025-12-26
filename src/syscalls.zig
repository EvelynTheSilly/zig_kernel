const println = @import("uart.zig").println;

// current el interupts
// sp0
pub export fn el1_sp0_sync_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("kernel sp0 sync interupt");
}

pub export fn el1_sp0_irq_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("kernel sp0 irq interupt");
}

pub export fn el1_sp0_fiq_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("kernel sp0 fiq interupt");
}

pub export fn el1_sp0_serror_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("kernel sp0 serror interupt");
}

// spx
pub export fn el1_spx_sync_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("kernel spx sync interupt");
}

pub export fn el1_spx_irq_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("kernel spx irq interupt");
}

pub export fn el1_spx_fiq_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("kernel spx fiq interupt");
}

pub export fn el1_spx_serror_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("kernel spx serror interupt");
}

// lower el interupts
// aarch64
pub export fn el0_aarch64_sync_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) i64 {
    println("hello, this is an interupt, it will now return");
    return 0;
}

pub export fn el0_aarch64_irq_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("user aarch64 irq interupt");
}

pub export fn el0_aarch64_fiq_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("user aarch64 fiq interupt");
}

pub export fn el0_aarch64_serror_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("user aarch64 serror interupt");
}

// aarch32
pub export fn el0_aarch32_sync_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("user aarch32 sync interupt");
}

pub export fn el0_aarch32_irq_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("user aarch32 irq interupt");
}

pub export fn el0_aarch32_fiq_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("user aarch32 fiq interupt");
}

pub export fn el0_aarch32_serror_handler() align(16) callconv(.{ .aarch64_aapcs = .{} }) void {
    @panic("user aarch32 serror interupt");
}
