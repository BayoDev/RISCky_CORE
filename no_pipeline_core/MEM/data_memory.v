
module data_memory(

    input clk,rst,

    input [31:0]    address,
    output [31:0]      data_out
);

reg [31:0] memory [1023:0];

initial begin
    integer i;
    for (i = 0; i < 1024; i = i + 1) begin
        memory[i] = 32'b0;
    end
end

// always @(posedge clk) begin
//     data_out <= memory[address];
// end

assign data_out = memory[address];

endmodule