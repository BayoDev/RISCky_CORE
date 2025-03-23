
module instruction_memory(

    input clk,rst,

    input [31:0]    address,
    output [31:0]      data_out
);

reg [31:0] memory [1023:0];

initial begin
    // Simple RISC-V program (machine code)
    memory[0]  = 32'h00108093; // ADDI x1, x0, 0   (x1 = 0)
    memory[1]  = 32'h00108093; // ADDI x2, x0, 1   (x2 = 1)
    memory[2]  = 32'hfe000ce3;
    // memory[2]  = 32'hfe000ce3; // ADD  x3, x1, x2  (x3 = x1 + x2)
    // memory[3]  = 32'h00310233; // ADD  x4, x2, x3  (x4 = x2 + x3)
    // memory[4]  = 32'h004182b3; // ADD  x5, x3, x4  (x5 = x3 + x4)
    // memory[5] = 32'hfe0006e3; // BEQ x0, x0, -10 (Branch back to instruction 0)
end

// always @(posedge clk) begin
//     data_out <= memory[address];
// end

// I do the shifting because the memory should be byte-addressed in theory
assign data_out = memory[address>>2];

endmodule