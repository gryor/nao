# libraries are read from a file named libraries

cc = gcc
ccc = g++

cflags = -std=c11
cflags_debug = -g -Wall
cflags_release = -O3

ccflags = -std=c++11
ccflags_debug = -g -Wall
ccflags_release = -O3

csources = ${wildcard src/*.c}
ccsources = ${wildcard src/*.cpp}
libraries = ${addprefix -l, ${shell test -f libraries || touch libraries && cat libraries | tr "\n" " " | sed "s/\s$$//"}}
target = $(notdir ${shell pwd})
version = ${shell test -f VERSION || echo 1.0.0 > VERSION && cat VERSION | tr "\n" " " | sed "s/\s$$//"}
version_major = ${shell echo ${version} | cut -d . -f1}

destdir ?=
prefix ?= /usr

.phony: all clean release debug luo lib libd install

all: release lib

release: luo ${csources:.c=.c.release.o} ${ccsources:.cpp=.cpp.release.o}
ifeq ($(strip $(ccsources)),)
	@${cc} ${addprefix .luo/, ${csources:.c=.c.release.o}} ${libraries} -o build/bin/${target}
else
	@${ccc} ${addprefix .luo/, ${csources:.c=.c.release.o}} ${addprefix .luo/, ${ccsources:.cpp=.cpp.release.o}} ${libraries} -o build/bin/${target}
endif
	@ln -sf bin/${target} build/

lib: luo include ${csources:.c=.c.lib.o} ${ccsources:.cpp=.cpp.lib.o}
ifeq ($(strip $(ccsources)),)
	@${cc} -shared -Wl,-soname,lib${target}.so.${version_major} ${addprefix .luo/, ${csources:.c=.c.lib.o}} ${libraries} -o build/lib/lib${target}.so.${version}
else
	@${ccc} -shared -Wl,-soname,lib${target}.so.${version_major} ${addprefix .luo/, ${csources:.c=.c.lib.o}} ${addprefix .luo/, ${ccsources:.cpp=.cpp.lib.o}} ${libraries} -o build/lib/lib${target}.so.${version}
endif
	@ln -sf lib${target}.so.${version} build/lib/lib${target}.so
	@ln -sf lib${target}.so.${version} build/lib/lib${target}.so.${version_major}

libd: luo include ${csources:.c=.c.lib.debug.o} ${ccsources:.cpp=.cpp.lib.debug.o}
ifeq ($(strip $(ccsources)),)
	@${cc} -shared -Wl,-soname,lib${target}.so.${version_major} ${addprefix .luo/, ${csources:.c=.c.lib.debug.o}} ${libraries} -o build/lib/lib${target}d.so.${version}
else
	@${ccc} -shared -Wl,-soname,lib${target}.so.${version_major} ${addprefix .luo/, ${csources:.c=.c.lib.debug.o}} ${addprefix .luo/, ${ccsources:.cpp=.cpp.lib.debug.o}} ${libraries} -o build/lib/lib${target}d.so.${version}
endif
	@ln -sf lib${target}d.so.${version} build/lib/lib${target}d.so
	@ln -sf lib${target}d.so.${version} build/lib/lib${target}d.so.${version_major}

include:
	@find src -name "*.h" -exec cp -f -t build/include {} \;

debug: luo ${csources:.c=.c.debug.o} ${ccsources:.cpp=.cpp.debug.o}
ifeq ($(strip $(ccsources)),)
	@${cc} ${addprefix .luo/, ${csources:.c=.c.debug.o}} ${libraries} -o build/bin/${target}
else
	@${ccc} ${addprefix .luo/, ${csources:.c=.c.debug.o}} ${addprefix .luo/, ${ccsources:.cpp=.cpp.debug.o}} ${libraries} -o build/bin/${target}
endif
	@ln -sf bin/${target} build/
	@echo -en "\e[1;32mSuccess\e[0m\n"

%.c.debug.o: %.c
	@${cc} ${cflags} ${cflags_debug} -c $< -o .luo/$@
%.cpp.debug.o: %.cpp
	@${ccc} ${ccflags} ${ccflags_debug} -c $< -o .luo/$@
%.c.release.o: %.c
	@${cc} ${cflags} ${cflags_release} -c $< -o .luo/$@
%.cpp.release.o: %.cpp
	@${ccc} ${ccflags} ${ccflags_release} -c $< -o .luo/$@
%.c.lib.debug.o: %.c
	@${cc} ${cflags} ${cflags_debug} -fPIC -c $< -o .luo/$@
%.cpp.lib.debug.o: %.cpp
	@${ccc} ${ccflags} ${ccflags_debug} -fPIC -c $< -o .luo/$@
%.c.lib.o: %.c
	@${cc} ${cflags} ${cflags_release} -fPIC -c $< -o .luo/$@
%.cpp.lib.o: %.cpp
	@${ccc} ${ccflags} ${ccflags_release} -fPIC -c $< -o .luo/$@
luo:
	@mkdir -p .luo/${dir ${csources}}
	@mkdir -p build
	@mkdir -p build/lib
	@mkdir -p build/include
	@mkdir -p build/bin
clean:
	-@rm -rf build .luo

install:
	-@install -D -t ${destdir}${prefix}/bin build/bin/* 2&>/dev/null || exit 0
	-@install -D -t ${destdir}${prefix}/lib build/lib/lib${target}.so.${version} 2&>/dev/null || exit 0
	-@install -D -t ${destdir}${prefix}/lib build/lib/lib${target}d.so.${version} 2&>/dev/null || exit 0
	-@find build/lib -type l -exec cp -fP -t ${destdir}${prefix}/lib {} \;
	-@install -D -m 0644 -t ${destdir}${prefix}/include/${target} build/include/* || exit 0