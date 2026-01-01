const std = @import("std");

pub fn build(b: *std.Build) void {
    // 1. Standard options (required for ZLS to understand build modes)
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // 2. Define a placeholder executable.
    // This doesn't need to actually run; it just tells ZLS where your
    // root file is and what context to analyze it in.
    const exe = b.addExecutable(.{
        .name = "zls_check_placeholder",
        // CHANGE THIS LINE: Point to your actual main entry point (e.g., src/main.zig)
        .root_source_file = b.path("./main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // 3. Create the "check" step specifically for ZLS
    const check = b.step("check", "Check for compilation errors");

    // 4. Connect the check step to the executable artifact
    // This forces Zig to analyze the code when 'zig build check' is run
    check.dependOn(&exe.step);
}
