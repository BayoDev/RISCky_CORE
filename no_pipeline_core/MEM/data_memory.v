
module data_memory(

    input clk,rst,

    input [31:0]    address,
    output [31:0]      data_out,

    input [31:0]        data_in,
    input               write_enable
);

reg [31:0] memory [1023:0];

integer i;
initial begin
    for (i = 0; i < 1024; i = i + 1) begin
        memory[i] = 32'b0;
    end
end


// do this better
always @(posedge clk) begin
    if(write_enable)
        memory[address] <= data_in;
end


assign data_out = memory[address];

endmodule