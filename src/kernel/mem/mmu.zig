const std = @import("std");

const tcr_el1 = packed struct {
    T0SZ: u5,
    _reserved: u1,
    EPD0: u1,
    IRGN0: u2,
    ORGN0: u2,
    SH0: u2,
    TG0: u2,
    T1SZ: u6,
    A1: u1,
    EPD1: u1,
    IRGN1: u2,
    ORGN1: u2,
    SH1: u2,
    TG1: u2,
    IPS: u3,
    unused: u30, // unused bits to pack it up
};

comptime {
    if (@bitSizeOf(tcr_el1) != 64) {
        @compileError("invalid size for tcr_el1");
    }
}

pub fn init() !void {}
