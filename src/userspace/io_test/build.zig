const std = @import("std");

pub fn build(b: *std.Build) !void {
    const features = std.Target.aarch64.Feature;
    const disabled_features = std.Target.aarch64.featureSet(&.{
        features.fp_armv8,
        features.neon,
        // You might also need to disable crypto if strict no-vector is required
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
        .root_source_file = b.path("../../lib/LibEstrogen/lib.zig"), // Adjust filename if needed
    });

    // 3. Define the Userspace Object
    // We build an Object file (.o), not an exe, to match your current flow.
    const obj = b.addObject(.{
        .name = "userspace", // Output will likely be userspace.o
        .root_module = b.createModule(.{ .root_source_file = b.path("main.zig"), .target = target, .optimize = optimize }),
    });
    obj.root_module.stack_protector = false;

    // 4. Link the module
    // This allows @import("lib") inside userspace code
    obj.root_module.addImport("LibEstrogen", libestrogen_module);

    // 5. Handle the Output Directory via Env Var
    // We attempt to grab the specific ENV var you use currently.
    // Replace "YOUR_OUTPUT_DIR_ENV_VAR" with your actual variable name (e.g., BUILD_DIR)
    const env_map = try std.process.getEnvMap(b.allocator);
    const output_dir = env_map.get("OUT") orelse "/dev/zero";

    // 6. Custom Install Step
    // Standard b.install() enforces a directory structure (bin/ lib/).
    // Since you want a raw .o file in a specific folder, we use a custom install step.
    const install_step = b.addInstallFile(obj.getEmittedBin(), "userspace.o");

    // We override the base prefix to be your environment variable path
    b.install_path = output_dir;

    // Trigger the install
    b.getInstallStep().dependOn(&install_step.step);

    const check_step = b.step("check", "Check compilation");
    check_step.dependOn(&obj.step);
}
