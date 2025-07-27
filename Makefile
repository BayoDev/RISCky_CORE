
TARGET_BUILD:= ./no_pipeline_core/top_bench.v ./no_pipeline_core/IF/*.v ./no_pipeline_core/ID/* ./no_pipeline_core/EX/* ./no_pipeline_core/MEM/* ./no_pipeline_core/WB/* ./no_pipeline_core/UART/*.v
TARGET_SIMUL:= ./no_pipeline_core/simulation_bench.v ./no_pipeline_core/IF/*.v ./no_pipeline_core/ID/* ./no_pipeline_core/EX/* ./no_pipeline_core/MEM/* ./no_pipeline_core/WB/*
SIMULATION_OUT:= test.sim

DEVICE := GW2A-LV18PG256C8/I7
BOARD := tangprimer20k

full_compile: synth
	echo "Compilation successfull"

create_dir:
	mkdir -p out/

.PHONY: clean sim synth trace pack load flash tests load-standalone

clean:
	rm -r out/

synth: create_dir
	yosys -p "read_verilog $(TARGET_BUILD); synth_gowin -json out/post_synth.json"

trace: synth
	nextpnr-himbaechel --json ./out/post_synth.json --write ./out/post_trace.json --device $(DEVICE) --vopt family=GW2A-18 --vopt cst=./no_pipeline_core/UART.cst

pack: trace
	gowin_pack -d $(DEVICE) -o ./out/post_pack.fs ./out/post_trace.json

load: pack load-standalone

load-standalone:
	sudo openFPGALoader -b $(BOARD) ./out/post_pack.fs

flash:
	sudo openFPGALoader -b $(BOARD) ./out/post_pack.fs -f 

sim: iverilog
	vvp $(SIMULATION_OUT)

iverilog:
	iverilog -DSIMULATION -o $(SIMULATION_OUT) $(TARGET_SIMUL)
