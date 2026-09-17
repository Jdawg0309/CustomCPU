IVERILOG ?= iverilog
VVP ?= vvp

.PHONY: test clean

test:
	mkdir -p build
	$(IVERILOG) -g2012 -Wall -s tb_npu_accelerator \
		-o build/tb_npu_accelerator \
		rtl/npu_accelerator.sv sim/tb_npu_accelerator.sv
	$(VVP) build/tb_npu_accelerator
	$(IVERILOG) -g2012 -Wall -DSYSTOLIC_DUT -s tb_npu_accelerator \
		-o build/tb_autonomous_systolic_npu \
		rtl/systolic_pe_int8.sv rtl/systolic_array_int8.sv \
		rtl/autonomous_systolic_npu.sv sim/tb_npu_accelerator.sv
	$(VVP) build/tb_autonomous_systolic_npu
	python3 sim/conv_im2col.py
	$(IVERILOG) -g2012 -Wall -s npu_accelerator \
		-Pnpu_accelerator.ARRAY_SIZE=32 \
		-o build/npu_32x32_compile rtl/npu_accelerator.sv

clean:
	rm -f build/tb_npu_accelerator
	rm -f build/tb_autonomous_systolic_npu
	rm -f build/npu_32x32_compile
