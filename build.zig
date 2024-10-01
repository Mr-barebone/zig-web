
const std = @import("std");

const Builder = std.Build;


pub fn build(b: *Builder) void {
    const mode = b.standardOptimizeOption(.{});

    const server_exe = b.addExecutable(.{
        .name = "web_zig",
        .root_source_file = b.path("src/server.zig"),
        .target = b.standardTargetOptions(.{}), // target of the executable. no choice means to match the computer it was build on
        .optimize = mode, // Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. By default none of the release options are considered the preferable choice by the build script, and the user must make a decision in order to create a release build.
    });
    
    // const core = b.dependency("core_zig", .{
    //     .optimize = mode,
    //     .target = b.standardTargetOptions(.{})
    // })
    const my_net = b.addModule("my_net", .{
        .root_source_file = b.path("connections/my_net.zig"),
        // .dependencies
    });
    const HTTP_parser = b.addModule("HTTP_parser", .{
        .root_source_file = b.path("connections/HTTP_parser.zig"),
    });
    // const my_net_err = b.addModule("my_net_err", .{
    //     .root_source_file = b.path("connections/my_net_err.zig"),
    // });
    const my_posix = b.addModule("my_posix", .{
        .root_source_file = b.path("connections/core/my_posix.zig"),
    });
    const protocols = b.addModule("protocols", .{
        .root_source_file = b.path("connections/core/protocols.zig"),
    });
    const my_err = b.addModule("my_err", .{
        .root_source_file = b.path("connections/core/my_err.zig"),
    });
    const my_mem = b.addModule("my_mem", .{
        .root_source_file = b.path("connections/core/my_mem.zig"),
    });
    const posix_constants = b.addModule("posix_constants", .{
        .root_source_file = b.path("connections/core/posix_constants.zig"),
    });
    
    // server_exe.addIncludePath(b.path("connections")); //expected type 'Build.LazyPath'
    server_exe.root_module.addImport("my_net", my_net);
    server_exe.root_module.addImport("HTTP_parser", HTTP_parser);
    // server_exe.root_module.addImport("my_net_err", my_net_err);

    server_exe.root_module.addImport("my_posix", my_posix);
    server_exe.root_module.addImport("protocols", protocols);
    server_exe.root_module.addImport("my_err", my_err);
    server_exe.root_module.addImport("my_mem", my_mem);
    server_exe.root_module.addImport("posix_constants", posix_constants);

    b.installArtifact(server_exe);

    // Add include path for C source files
//    main_exe.addIncludePath(.{.path=".",});

    // Link against libc
    // main_exe.linkLibC();

    // const run_cmd = b.addRunArtifact(main_exe);
    // run_cmd.step.dependOn(b.getInstallStep());

    // if (b.args) |args| {
    //     run_cmd.addArgs(args);
    // }

    // const run_step = b.step("run", "Run the app");
    // run_step.dependOn(&run_cmd.step); 
}
