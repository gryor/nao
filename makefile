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
libraries = ${addprefix -l, ${shell cat libraries | tr "\n" " " | sed "s/\s$$//"}}
target = $(notdir ${shell pwd})

.phony: all clean release luo

all: release lib
release: luo ${csources:.c=.c.release.o} ${ccsources:.cpp=.cpp.release.o}
ifeq ($(strip $(ccsources)),)
	@${cc} ${addprefix .luo/, ${csources:.c=.c.release.o}} ${libraries} -o build/${target}
else
	@${ccc} ${addprefix .luo/, ${csources:.c=.c.release.o}} ${addprefix .luo/, ${ccsources:.cpp=.cpp.release.o}} ${libraries} -o build/${target}
endif
lib: luo ${csources:.c=.c.lib.o} ${ccsources:.cpp=.cpp.lib.o}
ifeq ($(strip $(ccsources)),)
	@${cc} -shared ${addprefix .luo/, ${csources:.c=.c.lib.o}} ${libraries} -o build/lib${target}.so
else
	@${ccc} -shared ${addprefix .luo/, ${csources:.c=.c.lib.o}} ${addprefix .luo/, ${ccsources:.cpp=.cpp.lib.o}} ${libraries} -o build/lib${target}.so
endif
debug: luo ${csources:.c=.c.o} ${ccsources:.cpp=.cpp.o}
ifeq ($(strip $(ccsources)),)
	@${cc} ${addprefix .luo/, ${csources:.c=.c.o}} ${libraries} -o build/${target}
else
	@${ccc} ${addprefix .luo/, ${csources:.c=.c.o}} ${addprefix .luo/, ${ccsources:.cpp=.cpp.o}} ${libraries} -o build/${target}
endif
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
clean:
	-@rm -rf build .luo