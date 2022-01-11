const std = @import("std");
const builtin = @import("builtin");
const Pkg = std.build.Pkg;
const string = []const u8;

pub const cache = ".zigmod\\deps";

pub fn addAllTo(exe: *std.build.LibExeObjStep) void {
    @setEvalBranchQuota(1_000_000);
    for (packages) |pkg| {
        exe.addPackage(pkg.pkg.?);
    }
    var llc = false;
    var vcpkg = false;
    inline for (std.meta.declarations(package_data)) |decl| {
        const pkg = @as(Package, @field(package_data, decl.name));
        inline for (pkg.system_libs) |item| {
            exe.linkSystemLibrary(item);
            llc = true;
        }
        inline for (pkg.c_include_dirs) |item| {
            exe.addIncludeDir(@field(dirs, decl.name) ++ "/" ++ item);
            llc = true;
        }
        inline for (pkg.c_source_files) |item| {
            exe.addCSourceFile(@field(dirs, decl.name) ++ "/" ++ item, pkg.c_source_flags);
            llc = true;
        }
    }
    if (llc) exe.linkLibC();
    if (builtin.os.tag == .windows and vcpkg) exe.addVcpkgPaths(.static) catch |err| @panic(@errorName(err));
}

pub const Package = struct {
    directory: string,
    pkg: ?Pkg = null,
    c_include_dirs: []const string = &.{},
    c_source_files: []const string = &.{},
    c_source_flags: []const string = &.{},
    system_libs: []const string = &.{},
    vcpkg: bool = false,
};

pub const dirs = struct {
    pub const _root = "";
    pub const _eblgzipm6b58 = cache ++ "/../..";
    pub const _4cjx39zox2iq = cache ++ "/v/git/github.com/bdoner/zig-permutate/tag-v0.1.0";
};

pub const package_data = struct {
    pub const _eblgzipm6b58 = Package{
        .directory = dirs._eblgzipm6b58,
    };
    pub const _4cjx39zox2iq = Package{
        .directory = dirs._4cjx39zox2iq,
        .pkg = Pkg{ .name = "permutate", .path = .{ .path = dirs._4cjx39zox2iq ++ "/src/permutate.zig" }, .dependencies = null },
    };
    pub const _root = Package{
        .directory = dirs._root,
    };
};

pub const packages = &[_]Package{
    package_data._4cjx39zox2iq,
};

pub const pkgs = struct {
    pub const permutate = package_data._4cjx39zox2iq;
};

pub const imports = struct {
    pub const permutate = @import(".zigmod\\deps/v/git/github.com/bdoner/zig-permutate/tag-v0.1.0/src/permutate.zig");
};
