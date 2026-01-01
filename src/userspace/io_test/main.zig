const estrogen = @import("LibEstrogen");

export fn _INIT() void {
    estrogen.IO.println("hello from the io test");
    estrogen.IO.println("this is showing off the output");
    estrogen.IO.println("its some pretty simply io");
    estrogen.IO.println("now im gonna try to read");
    var buffer: [128]u8 = [_]u8{0} ** 128;
    const bytes_read = try estrogen.IO.readuntil(13, buffer[0..]);
    const new_buffer = buffer[0..bytes_read];
    estrogen.IO.println("read out");
    estrogen.IO.println(new_buffer);
    estrogen.util.halt();
}
