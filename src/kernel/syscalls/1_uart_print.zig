/// prints to the uart output
/// codes:
/// - 1 success
/// - -1 error
const print_buffer = @import("../uart.zig").print_uart_buffer;

pub fn uart_print(str: []const u8) i64 {
    print_buffer(str);
    return -1;
}
