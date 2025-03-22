
TARGET_FILE := ./core/fetch_phase/*.v
DEVICE := GW2A-LV18PG256C8/I7
BOARD := tangprimer20k

full_compile: synth
	echo "Compilation successfull"

create_dir:
	mkdir -p out/

.PHONY: clean synth

clean:
	rm -r out/

synth: create_dir
	yosys -p "read_verilog $(TARGET_FILE); synth_gowin -json out/post_synth.json"