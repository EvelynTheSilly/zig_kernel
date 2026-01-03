const std = @import("std");

pub fn build(b: *std.Build) !void {
    const features = std.Target.aarch64.Feature;
    const disabled_features = std.Target.aarch64.featureSet(&.{
        features.fp_armv8,
        features.neon,
        features.crypto,
    });

    const target_query = std.Target.Query{
        .cpu_arch = .aarch64,
        .os_tag = .freestanding,
        .abi = .none,
        .cpu_model = .{ .explicit = &std.Target.aarch64.cpu.generic },
        .cpu_features_add = std.Target.aarch64.featureSet(&.{.strict_align}),
        .cpu_features_sub = disabled_features,
    };
    const target = b.resolveTargetQuery(target_query);
    const optimize = .Debug;

    const libestrogen_module = b.createModule(.{
        .root_source_file = b.path("../lib/LibEstrogen/lib.zig"),
    });
    const libc_module = b.createModule(.{
        .root_source_file = b.path("../lib/Libc/lib.zig"),
    });

    // 3. define object file for our outputs
    const obj = b.addObject(.{
        .name = "kernel",
        .root_module = b.createModule(.{ .root_source_file = b.path("main.zig"), .target = target, .optimize = optimize }),
    });
    obj.root_module.stack_protector = false;

    // 4. Link the module
    // This allows @import("lib") inside userspace code
    obj.root_module.addImport("LibEstrogen", libestrogen_module);
    obj.root_module.addImport("Libc", libc_module);

    // 5. Handle the Output Directory via Env Var
    // We attempt to grab the specific ENV var you use currently.
    const env_map = try std.process.getEnvMap(b.allocator);
    const output_dir = env_map.get("BYPRODUCTS") orelse "/dev/zero";

    // 6. Custom Install Step
    const install_step = b.addInstallFile(obj.getEmittedBin(), "kernel.o");

    // We override the base prefix to be your environment variable path
    b.install_path = output_dir;

    // Trigger the install
    b.getInstallStep().dependOn(&install_step.step);

    // lsp check step
    const check_step = b.step("check", "Check compilation");
    check_step.dependOn(&obj.step);
}
