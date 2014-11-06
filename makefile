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

.phony: all clean release debug luo lib

all: release lib

release: luo ${csources:.c=.c.release.o} ${ccsources:.cpp=.cpp.release.o}
ifeq ($(strip $(ccsources)),)
	@${cc} ${addprefix .luo/, ${csources:.c=.c.release.o}} ${libraries} -o build/bin/${target}
else
	@${ccc} ${addprefix .luo/, ${csources:.c=.c.release.o}} ${addprefix .luo/, ${ccsources:.cpp=.cpp.release.o}} ${libraries} -o build/bin/${target}
endif
	@ln -sf bin/${target} build/

lib: luo ${csources:.c=.c.lib.o} ${ccsources:.cpp=.cpp.lib.o}
ifeq ($(strip $(ccsources)),)
	@${cc} -shared -Wl,-soname,lib${target}.so.${version_major} ${addprefix .luo/, ${csources:.c=.c.lib.o}} ${libraries} -o build/lib/lib${target}.so.${version}
else
	@${ccc} -shared -Wl,-soname,lib${target}.so.${version_major} ${addprefix .luo/, ${csources:.c=.c.lib.o}} ${addprefix .luo/, ${ccsources:.cpp=.cpp.lib.o}} ${libraries} -o build/lib/lib${target}.so.${version}
endif
	@find src -name "*.h" -exec cp -t build/include {} \;

debug: luo ${csources:.c=.c.o} ${ccsources:.cpp=.cpp.o}
ifeq ($(strip $(ccsources)),)
	@${cc} ${addprefix .luo/, ${csources:.c=.c.o}} ${libraries} -o build/bin/${target}
else
	@${ccc} ${addprefix .luo/, ${csources:.c=.c.o}} ${addprefix .luo/, ${ccsources:.cpp=.cpp.o}} ${libraries} -o build/bin/${target}
endif
	@ln -sf bin/${target} build/
	@echo -en "\e[1;32mSuccess\e[0m\n"

%.c.o: %.c
	@${cc} ${cflags} ${cflags_debug} -c $< -o .luo/$@
%.cpp.o: %.cpp
	@${ccc} ${ccflags} ${ccflags_debug} -c $< -o .luo/$@
%.c.release.o: %.c
	@${cc} ${cflags} ${cflags_release} -c $< -o .luo/$@
%.cpp.release.o: %.cpp
	@${ccc} ${ccflags} ${ccflags_release} -c $< -o .luo/$@
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