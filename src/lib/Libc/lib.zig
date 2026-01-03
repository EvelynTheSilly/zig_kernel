const memset = @import("mem/memset.zig");
const memcpy = @import("mem/memcpy.zig");
const memmove = @import("mem/memmove.zig");

/// exports the symbols from the library
/// does nothing outside of a comptime context
///
/// # usage
/// ```zig
/// const libc = @import("libc");
/// comptime libc.export_symbols();
/// ```
pub fn export_symbols() void {
    _ = memset;
    _ = memcpy;
    _ = memmove;
}
