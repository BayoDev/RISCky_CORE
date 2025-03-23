
TARGET_FILE := ./no_pipeline_core/IF/instruction_fetch.v

TARGET_SIMUL:= ./no_pipeline_core/top_bench.v ./no_pipeline_core/IF/*
SIMULATION_OUT:= test.sim

DEVICE := GW2A-LV18PG256C8/I7
BOARD := tangprimer20k

full_compile: synth
	echo "Compilation successfull"

create_dir:
	mkdir -p out/

.PHONY: clean synth sim

clean:
	rm -r out/

synth: create_dir
	yosys -p "read_verilog $(TARGET_FILE); synth_gowin -json out/post_synth.json"


sim: iverilog
	vvp $(SIMULATION_OUT)

iverilog:
	iverilog -o $(SIMULATION_OUT) $(TARGET_SIMUL)
