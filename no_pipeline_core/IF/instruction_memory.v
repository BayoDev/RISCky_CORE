module instruction_memory
#(
    parameter XLEN = 32
)
(

    input clk,rst,

    input [XLEN-1:0]    address,
    output [31:0]      data_out
);

// reg [31:0] memory [128:0]

(* syn_ramstyle = "block_ram" *) 
reg [31:0] memory [511:0];

// ADDI/LOOP
// initial begin
//     // Simple RISC-V program (machine code)
//     memory[0]  = 32'h00108093;
//     memory[1]  = 32'h00108093;
//     memory[2]  = 32'hfe000ce3;
// end

integer i;
initial begin
    for (i = 0; i < 128; i = i + 1) begin
        memory[i] = 32'b0;
    end
end

// ADD/ADDI test

// initial begin
//     memory[0] = 32'h00a08093;
//     memory[1] = 32'h01410113;
//     memory[2] = 32'h002081b3;
//     memory[3] = 32'hfe000ae3;
// end

// LD/ST test with offset
// initial begin
//     memory[0] = 32'h00a00093; // addi x1, x0, 10  (Put value 10 into x1)
//     memory[1] = 32'h00400113; // addi x2, x0, 4   (Put value 4 into x2 as offset)
//     memory[2] = 32'h00112223; // sw x1, 4(x2)     (Store value of x1 into memory at address x2 + 4)
//     memory[3] = 32'h00412103; // lw x2, 4(x2)     (Load value from memory at address x2 + 4 into x2)
// end

// Test: Loop and store 'a' (0x61) into address 0x680
initial begin
    memory[0] = 32'h06100093; // addi x1, x0, 0x61 (Load ASCII 'a' into x1)
    memory[1] = 32'h68000113; // addi x2, x0, 0x680 (Load address 0x680 into x2)
    memory[2] = 32'h00112023; // sw x1, 0(x2) (Store value of x1 into memory at address x2)
    memory[3] = 32'h0000006f; // j 0 (Jump to the same instruction to loop)
end

// always @(posedge clk) begin
//     data_out <= memory[address];
// end

// I do the shifting because the memory should be byte-addressed in theory
assign data_out = memory[address>>2];


endmodule