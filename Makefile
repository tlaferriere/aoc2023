ZIG_VERSION = 0.12.0-dev.2777+2176a73d6

zig: zig-linux-x86_64-$(ZIG_VERSION)
	cp -r $</* $@

zig-linux-x86_64-$(ZIG_VERSION): zig-linux-x86_64-$(ZIG_VERSION).tar.xz
	tar -xf $<

zig-linux-x86_64-%.tar.xz:
    curl -O https://ziglang.org/builds/$@