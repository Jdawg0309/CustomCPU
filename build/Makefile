CC ?= cc
CFLAGS ?= -std=c11 -O2 -Wall -Wextra -Werror

C_SOURCES := $(sort $(wildcard ../src/math_*.c))

.PHONY: all roms verify verify-host manifest clean

all: roms verify

roms:
	python3 build.py

verify: verify-host
	python3 build.py --check

verify-host: verify_host
	./verify_host

manifest: verify
	sha256sum ../roms/*.rom ../src/*.S ../src/*.c build.py Makefile > MANIFEST.sha256

verify_host: ../src/verify_host.c $(C_SOURCES)
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f verify_host MANIFEST.sha256
