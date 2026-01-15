/// gets kernels end using the _end link symbol
pub fn get_kernel_code_start() u64 {
    asm volatile (
        \\ mov x0, _start // puts the start linker symbol into x0
        : [ret] "=x0" (-> u64), // marks the return to be the output in x0
        : // empty line for no inputs
        : .{ .x0 = true }); // clobbers x0
}

/// gets kernels end using the _end link symbol
pub fn get_kernel_code_end() u64 {
    asm volatile (
        \\ mov x0, _end // puts the start linker symbol into x0
        : [ret] "=x0" (-> u64), // marks the return to be the output in x0
        : // empty line for no inputs
        : .{ .x0 = true }); // clobbers x0
}
