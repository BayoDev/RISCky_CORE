
module instruction_memory(

    input clk,rst,

    input [31:0]    address,
    output [31:0]      data_out
);

reg [31:0] memory [1023:0];

// ADDI/LOOP
// initial begin
//     // Simple RISC-V program (machine code)
//     memory[0]  = 32'h00108093;
//     memory[1]  = 32'h00108093;
//     memory[2]  = 32'hfe000ce3;
// end

integer i;
initial begin
    for (i = 0; i < 1024; i = i + 1) begin
        memory[i] = 32'b0;
    end
end

// ADD/ADDI test

initial begin
    memory[0] = 32'h00a08093;
    memory[1] = 32'h01410113;
    memory[2] = 32'h002081b3;
    memory[3] = 32'hfe000ae3;
end

// always @(posedge clk) begin
//     data_out <= memory[address];
// end

// I do the shifting because the memory should be byte-addressed in theory
assign data_out = memory[address>>2];

endmodule