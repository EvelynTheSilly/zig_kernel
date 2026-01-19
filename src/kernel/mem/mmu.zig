const std = @import("std");

const tcr_el1 = packed struct {
    T0SZ: u6, // table 0 size
    _reserved: u1,
    EPD0: u1,
    IRGN0: u2,
    ORGN0: u2,
    SH0: u2,
    TG0: u2,
    T1SZ: u6, // table 1 size
    A1: u1,
    EPD1: u1,
    IRGN1: u2,
    ORGN1: u2,
    SH1: u2,
    TG1: u2,
    IPS: u3,
    unused: u29, // unused bits to pack it up
};

/// memory attribute table
/// assigns attribute 1 and attribute 2 as packed u8s
///
/// attr examples:
/// - 0b11111111: full rights memory, basically just normal ram
/// - 0b00000000: no rights device memory
const mair_el1 = packed struct { attr0: u8, atr1: u8, unused: u48 };

comptime {
    if (@bitSizeOf(tcr_el1) != 64) {
        @compileError("invalid size for tcr_el1");
    }
}
