CPU_FLAGS := -mcpu=arm7tdmi -marm
CFLAGS := $(CPU_FLAGS) -O2 -ffreestanding -fno-builtin -fomit-frame-pointer \
	-fno-unwind-tables -fno-asynchronous-unwind-tables

.PHONY: all clean

all: add.dump add_rom

add.o: add.c
	arm-none-eabi-gcc $(CFLAGS) -c $< -o $@

add.dump: add.o
	arm-none-eabi-objdump -d $< > $@

add.bin: add.o
	arm-none-eabi-objcopy -O binary --only-section=.text $< $@

add_rom: add.bin build_rom.py
	python3 build_rom.py

clean:
	rm -f add.o add.dump add.bin add_rom
