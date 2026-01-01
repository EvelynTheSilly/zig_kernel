const io = @import("../IO.zig");
pub fn halt() noreturn {
    io.println("halting");
    while (true) {
        asm volatile ("wfi");
    }
}
