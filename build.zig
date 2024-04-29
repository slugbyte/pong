const std = @import("std");

fn clean() !void {
    const src: std.builtin.SourceLocation = @src();
    std.log.warn("file: {s}", .{src.file});
}

pub fn build(b: *std.Build) void {
    // exe
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "pong",
        .root_source_file = std.Build.LazyPath{ .path = "./src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    const zgl = b.dependency("zgl", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("gl", zgl.module("zgl"));
    const glfw = b.dependency("mach-glfw", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("glfw", glfw.module("mach-glfw"));
    exe.linkFramework("OpenGL");
    exe.addIncludePath(.{ .path = "/opt/homebrew/include" });
    exe.addLibraryPath(.{ .path = "/opt/homebrew/lib" });
    b.installArtifact(exe);

    // run
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // clean
    const clean_step = b.step("clean", "remove zig-out and zig-cache");
    const clean_cmd = b.addSystemCommand(&.{ "rm", "-rf", "zig-cache", "zig-out" });
    clean_step.dependOn(&clean_cmd.step);

    // test
    const exe_unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "./src/main.zig" },
        // .root_source_file = b.path("./src//main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
