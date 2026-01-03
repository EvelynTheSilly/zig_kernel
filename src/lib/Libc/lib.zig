const memset = @import("mem/memset.zig");
const memcpy = @import("mem/memcpy.zig");
const memmove = @import("mem/memmove.zig");

pub fn export_symbols() void {
    _ = memset;
    _ = memcpy;
    _ = memmove;
}
