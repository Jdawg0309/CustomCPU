CPU_FLAGS := -mcpu=arm7tdmi -marm
CFLAGS := $(CPU_FLAGS) -O2 -ffreestanding -fno-builtin -fomit-frame-pointer \
	-fno-unwind-tables -fno-asynchronous-unwind-tables
LDFLAGS := $(CPU_FLAGS) -nostdlib -Wl,--build-id=none -T customcpu.ld

.PHONY: all clean stress verify verify-logisim verify-stress

STRESS_TESTS := stress_signed stress_memory stress_call

all: add.dump add_rom practical.dump practical_rom

add.o: add.c
	arm-none-eabi-gcc $(CFLAGS) -c $< -o $@

add.dump: add.o
	arm-none-eabi-objdump -d $< > $@

add.bin: add.o
	arm-none-eabi-objcopy -O binary --only-section=.text $< $@

add_rom: add.bin build_rom.py
	python3 build_rom.py add.bin add_rom --add-harness

startup.o: startup.S
	arm-none-eabi-gcc $(CPU_FLAGS) -c $< -o $@

practical.o: practical.c
	arm-none-eabi-gcc $(CFLAGS) -c $< -o $@

practical.elf: startup.o practical.o customcpu.ld
	arm-none-eabi-gcc $(LDFLAGS) startup.o practical.o -o $@

practical.dump: practical.elf
	arm-none-eabi-objdump -d $< > $@

practical.bin: practical.elf
	arm-none-eabi-objcopy -O binary --only-section=.text $< $@

practical_rom: practical.bin build_rom.py
	python3 build_rom.py practical.bin practical_rom

stress_%.o: stress_%.c
	arm-none-eabi-gcc $(CFLAGS) -c $< -o $@

stress_%.elf: startup.o stress_%.o customcpu.ld
	arm-none-eabi-gcc $(LDFLAGS) startup.o stress_$*.o -o $@

stress_%.dump: stress_%.elf
	arm-none-eabi-objdump -d $< > $@

stress_%.bin: stress_%.elf
	arm-none-eabi-objcopy -O binary --only-section=.text $< $@

stress_%_rom: stress_%.bin build_rom.py
	python3 build_rom.py $< $@

stress: $(addsuffix .dump,$(STRESS_TESTS)) $(addsuffix _rom,$(STRESS_TESTS))

verify: all
	python3 verify_practical.py

verify-logisim: verify
	bash run_logisim_test.sh

verify-stress: stress
	python3 verify_stress.py
	bash run_logisim_test.sh stress_signed_rom 41:0000000e ff:fffffff9
	bash run_logisim_test.sh stress_memory_rom 42:00000018 48:00000003 4b:00000009

clean:
	rm -f add.o add.dump add.bin add_rom startup.o practical.o practical.elf \
		practical.dump practical.bin practical_rom stress_*.o stress_*.elf \
		stress_*.dump stress_*.bin stress_*_rom
