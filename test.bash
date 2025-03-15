yosys -D LEDS_NR=8 -D INV_BTN=0  -p "read_verilog blinky.v; synth_gowin -json blinky.json"
DEVICE='GW2A-LV18PG256C8/I7'  # change to your device
BOARD='tangprimer20k' # change to your board
nextpnr-himbaechel --json blinky.json \
                   --write pnrblinky.json \
                   --device $DEVICE \
                   --vopt family=GW2A-18 \
		   --vopt cst=primer20k.cst
gowin_pack -d $DEVICE -o pack.fs pnrblinky.json # chango to your device
# gowin_unpack -d $DEVICE -o unpack.v pack.fs
# yosys -p "read_verilog -lib +/gowin/cells_sim.v; clean -purge; show" unpack.v
sudo openFPGALoader -b $BOARD pack.fs
