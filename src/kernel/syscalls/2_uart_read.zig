const print_buffer = @import("../uart.zig").print_uart_buffer;
const uart_has_input = @import("../uart.zig").uart_has_input;
const uart_read_char = @import("../uart.zig").uart_read_char;

// In your kernel's syscall handler
pub fn uart_read(buffer: []u8) isize {
    var bytes_read: usize = 0;

    // While the UART has data AND we haven't filled the user's buffer
    while (uart_has_input() and bytes_read < buffer.len) {
        buffer[bytes_read] = uart_read_char();
        bytes_read += 1;
    }

    // Return how many bytes we actually put in the buffer
    return @intCast(bytes_read);
}
