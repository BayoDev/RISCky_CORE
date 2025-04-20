
TARGET_FILE := ./no_pipeline_core/IF/*

TARGET_BUILD:= ./no_pipeline_core/top_bench.v ./no_pipeline_core/IF/*.v ./no_pipeline_core/ID/* ./no_pipeline_core/ID/registers_handler/* ./no_pipeline_core/ID/registers_handler/components/* ./no_pipeline_core/EX/* ./no_pipeline_core/MEM/* ./no_pipeline_core/WB/* ./no_pipeline_core/UART/*.v
TARGET_SIMUL:= ./no_pipeline_core/simulation_bench.v ./no_pipeline_core/IF/*.v ./no_pipeline_core/ID/* ./no_pipeline_core/ID/registers_handler/* ./no_pipeline_core/ID/registers_handler/components/* ./no_pipeline_core/EX/* ./no_pipeline_core/MEM/* ./no_pipeline_core/WB/* 
SIMULATION_OUT:= test.sim

DEVICE := GW2A-LV18PG256C8/I7
BOARD := tangprimer20k

full_compile: synth
	echo "Compilation successfull"

create_dir:
	mkdir -p out/

.PHONY: clean sim synth trace pack load flash tests

clean:
	rm -r out/

synth: create_dir
	yosys -p "read_verilog $(TARGET_BUILD); synth_gowin -json out/post_synth.json"

trace: synth
	nextpnr-himbaechel --json ./out/post_synth.json --write ./out/post_trace.json --device $(DEVICE) --vopt family=GW2A-18 --vopt cst=./no_pipeline_core/UART.cst

pack: trace
	gowin_pack -d $(DEVICE) -o ./out/post_pack.fs ./out/post_trace.json

load: pack
	sudo openFPGALoader -b $(BOARD) ./out/post_pack.fs

flash:
	sudo openFPGALoader -b $(BOARD) ./out/post_pack.fs -f

sim: iverilog
	vvp $(SIMULATION_OUT)

iverilog:
	iverilog -o $(SIMULATION_OUT) $(TARGET_SIMUL)

tests:
	riscv32-unknown-linux-gnu-as -o ./software_tests/program.o ./software_tests/my_test.s && \
	riscv32-unknown-linux-gnu-ld -o ./software_tests/program.elf ./software_tests/program.o && \
	riscv32-unknown-linux-gnu-objcopy -O binary ./software_tests/program.elf ./software_tests/program.bin && \
	xxd -e -c 4 -p ./software_tests/program.bin > ./software_tests/out/test_data.hex && \
	xxd -e -c 1 -p ./software_tests/program.bin > ./software_tests/out/test_data.hex && \
	rm -f ./software_tests/program.o ./software_tests/program.elf ./software_tests/program.bin