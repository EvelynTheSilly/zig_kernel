pub fn read(buf: []const u8) isize {
    const id: usize = 2; // syscall id for write

    return asm volatile (
    //\\ mov x0, {id}
    //\\ mov x1, {ptr}
    //\\ mov x2, {len}
        \\ svc #0
        : [ret] "=&{x0}" (-> isize),
        : [id] "{x0}" (id),
          [ptr] "{x1}" (buf.ptr),
          [len] "{x2}" (buf.len),
        : .{ .x0 = true, .x1 = true, .x2 = true, .x3 = true, .x4 = true, .x5 = true, .x6 = true, .x7 = true, .x8 = true, .x9 = true, .x10 = true, .x11 = true, .x12 = true, .x13 = true, .x14 = true, .x15 = true, .x16 = true, .x17 = true, .x18 = true });
}
