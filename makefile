comma := ,
empty:=
space:= $(empty) $(empty)
destdir ?=
prefix ?= /usr
installdir := ${destdir}${prefix}
.DEFAULT_GOAL := all

all: debug-static debug-shared release-static release-shared

build/include/distance.h build/include/matrix.h build/include/polynomial.h build/include/scalar.h: build/include/%: src/%
	@mkdir -p ${dir $@}
	@cd src; cp --parents -t ../build/include $*

includes: build/include/distance.h build/include/matrix.h build/include/polynomial.h build/include/scalar.h

clean-includes: 
	@rm -rf build

build/obj/test/src/main.c.o: build/obj/test/%.o: %
	@mkdir -p ${dir $@}
	@gcc -c $< -o $@

test: debug-static build/obj/test/src/main.c.o
	@mkdir -p build/bin
	@gcc -Lbuild/lib -l:libm.so build/obj/test/src/main.c.o -l:libnao.debug.a -o build/bin/nao

clean-test: 
	@rm -rf build

library: includes

build/obj/static/src/distance.c.o build/obj/static/src/matrix.c.o build/obj/static/src/polynomial.c.o build/obj/static/src/scalar.c.o: build/obj/static/%.o: %
	@mkdir -p ${dir $@}
	@gcc -fPIC -c $< -o $@

static: includes build/obj/static/src/distance.c.o build/obj/static/src/matrix.c.o build/obj/static/src/polynomial.c.o build/obj/static/src/scalar.c.o
	@mkdir -p build/lib
	@ar rcs build/lib/libnao.a build/obj/static/src/distance.c.o build/obj/static/src/matrix.c.o build/obj/static/src/polynomial.c.o build/obj/static/src/scalar.c.o

clean-static: 
	@rm -rf build

shared: includes

build/obj/debug-static/src/distance.c.o build/obj/debug-static/src/matrix.c.o build/obj/debug-static/src/polynomial.c.o build/obj/debug-static/src/scalar.c.o: build/obj/debug-static/%.o: %
	@mkdir -p ${dir $@}
	@gcc -fPIC -c $< -o $@

debug-static: includes build/obj/debug-static/src/distance.c.o build/obj/debug-static/src/matrix.c.o build/obj/debug-static/src/polynomial.c.o build/obj/debug-static/src/scalar.c.o
	@mkdir -p build/lib
	@ar rcs build/lib/libnao.debug.a build/obj/debug-static/src/distance.c.o build/obj/debug-static/src/matrix.c.o build/obj/debug-static/src/polynomial.c.o build/obj/debug-static/src/scalar.c.o

clean-debug-static: 
	@rm -rf build

build/obj/release-static/src/distance.c.o build/obj/release-static/src/matrix.c.o build/obj/release-static/src/polynomial.c.o build/obj/release-static/src/scalar.c.o: build/obj/release-static/%.o: %
	@mkdir -p ${dir $@}
	@gcc -fPIC -c $< -o $@

release-static: includes build/obj/release-static/src/distance.c.o build/obj/release-static/src/matrix.c.o build/obj/release-static/src/polynomial.c.o build/obj/release-static/src/scalar.c.o
	@mkdir -p build/lib
	@ar rcs build/lib/libnao.a build/obj/release-static/src/distance.c.o build/obj/release-static/src/matrix.c.o build/obj/release-static/src/polynomial.c.o build/obj/release-static/src/scalar.c.o

clean-release-static: 
	@rm -rf build

debug-shared: includes debug-static
	@mkdir -p build/lib
	@gcc -shared -fPIC -Wl,-soname,libnao.debug.so.0 -Lbuild/lib -l:libm.so -l:libnao.debug.a -o build/lib/libnao.debug.so.0.0.1
	@ln -sf libnao.debug.so.0.0.1 build/lib/libnao.debug.so
	@ln -sf libnao.debug.so.0.0.1 build/lib/libnao.debug.so.0
	@ln -sf libnao.debug.so.0.0.1 build/lib/libnao.debug.so.0.0

clean-debug-shared: 
	@rm -rf build

release-shared: includes release-static
	@mkdir -p build/lib
	@gcc -shared -fPIC -Wl,-soname,libnao.so.0 -Lbuild/lib -l:libm.so -l:libnao.a -o build/lib/libnao.so.0.0.1
	@ln -sf libnao.so.0.0.1 build/lib/libnao.so
	@ln -sf libnao.so.0.0.1 build/lib/libnao.so.0
	@ln -sf libnao.so.0.0.1 build/lib/libnao.so.0.0

clean-release-shared: 
	@rm -rf build

clean: clean-test clean-static clean-debug-static clean-release-static clean-debug-shared clean-release-shared