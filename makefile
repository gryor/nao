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

all: release
release: luo ${csources:.c=.c.release.o} ${ccsources:.cpp=.cpp.release.o}
ifeq ($(strip $(ccsources)),)
	@${cc} ${addprefix .luo/, ${csources:.c=.c.release.o}} ${libraries} -o build/${target}
else
	@${ccc} ${addprefix .luo/, ${csources:.c=.c.release.o}} ${addprefix .luo/, ${ccsources:.cpp=.cpp.release.o}} ${libraries} -o build/${target}
endif
debug: luo ${csources:.c=.c.o} ${ccsources:.cpp=.cpp.o}
ifeq ($(strip $(ccsources)),)
	@${cc} ${addprefix .luo/, ${csources:.c=.c.o}} ${libraries} -o build/${target}
else
	@${ccc} ${addprefix .luo/, ${csources:.c=.c.o}} ${addprefix .luo/, ${ccsources:.cpp=.cpp.o}} ${libraries} -o build/${target}
endif
	@echo -en "\e[1;32mSuccess\e[0m\n"
%.c.o: %.c
	@astyle $<
	@${cc} ${cflags} ${cflags_debug} -c $< -o .luo/$@
%.cpp.o: %.cpp
	@astyle $<
	@${ccc} ${ccflags} ${ccflags_debug} -c $< -o .luo/$@
%.c.release.o: %.c
	@${cc} ${cflags} ${cflags_release} -c $< -o .luo/$@
%.cpp.release.o: %.cpp
	@${ccc} ${ccflags} ${ccflags_release} -c $< -o .luo/$@
luo:
	@mkdir -p .luo/${dir ${csources}}
	@mkdir -p build
clean:
	-@rm -rf build .luo