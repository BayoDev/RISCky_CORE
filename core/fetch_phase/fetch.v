module fetch(
    input       clk,
    input       reset,

    input       pc_src, // Control if next PC value comes from branch or normal execution
    input  [31:0] branch_result,
    output reg [31:0] data_out,

    output [31:0] memory_bus,
    input  [15:0] data_bus
);

wire [31:0] data_in;

// TODO: check if using the clock as write_enable works
pc_register pc(clk,clk,reset,data_in,data_out);

assign data_in = pc_src ? branch_result : data_out+4;



endmodule