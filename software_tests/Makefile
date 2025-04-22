
SOURCE_FILES := ./my_test.s

assemble: 
	riscv32-unknown-linux-gnu-as -o ./program.o $(SOURCE_FILES)

link: assemble
	riscv32-unknown-linux-gnu-ld -o ./program.elf ./program.o

objcopy: link
	riscv32-unknown-linux-gnu-objcopy -O binary ./program.elf ./program.bin

hex_dump: objcopy
	xxd -e -c 4 -p ./program.bin | sed 's/\(..\)\(..\)\(..\)\(..\)/\4\3\2\1/' > ./out/test_code.hex && \
	xxd -e -c 1 -p ./program.bin > ./out/test_data.hex

objdump: hex_dump
	riscv32-unknown-linux-gnu-objdump -d -x -h -s -t ./program.elf > ./out/objdump_output.txt


.DEFAULT_GOAL: all
all: objdump clean

.PHONY: clean 
clean:
	rm -f ./program.o ./program.elf ./program.bin