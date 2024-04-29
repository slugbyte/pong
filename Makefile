run:
	zig build run

clean:
	rm -rf zig-cache
	rm -rf zig-out

install: install-glfw install-gl

install-glfw:
	zig fetch --save https://pkg.machengine.org/mach-glfw/e57190c095097810980703aa26d4f0669a21dbab.tar.gz

install-gl:
	zig fetch --save https://github.com/slugbyte/zgl-4.1/archive/787c91441aeef9048d5f20236365bcd64f6ca72b.tar.gz

