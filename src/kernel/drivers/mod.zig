const std = @import("std");

const Device = struct {
    /// owned by device owner
    state: *anyopaque,
    vtable: *VTable,
    pub const VTable = struct {
        init: fn (*anyopaque, std.mem.Allocator) anyerror!void,
        /// processes
        process: fn (*anyopaque, std.mem.Allocator, message: *anyopaque) anyerror!void,
        /// responsible for cleaning up any pointers in state struct
        deinit: fn (*anyopaque, std.mem.Allocator) void,
    };
    pub fn init(self: Device, alloc: std.mem.Allocator) !void {
        return self.vtable.init(self.state, alloc);
    }
    pub fn process(self: Device, alloc: std.mem.Allocator, message: *anyopaque) !void {
        return self.vtable.process(self.state, alloc, message);
    }
    pub fn deinit(self: Device, alloc: std.mem.Allocator) !void {
        return self.vtable.deinit(self.state, alloc);
    }
};
