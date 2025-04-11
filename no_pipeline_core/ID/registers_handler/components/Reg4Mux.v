
module Reg4Mux
#(
    parameter XLEN = 32
)
(
    input [1:0]           src_one,
    input [1:0]           src_two,

    input  [1:0]    dest,
    input           write_enable,
    input           clk,
    input           reset,
    input  [XLEN-1:0]   data_in,

    output [XLEN-1:0]   out_one,
    output [XLEN-1:0]   out_two
);

wire [XLEN-1:0] reg1_out,reg2_out,reg3_out,reg4_out;

Reg2Mux 
#(
    .XLEN(XLEN)
)
reg1(src_one[0],src_two[0],dest[0],write_enable && ~dest[1],clk,reset,data_in,reg1_out,reg2_out);

Reg2Mux 
#(
    .XLEN(XLEN)
)
reg2(src_one[0],src_two[0],dest[0],write_enable && dest[1],clk,reset,data_in,reg3_out,reg4_out);

assign out_one = src_one[1] ? reg3_out : reg1_out;
assign out_two = src_two[1] ? reg4_out : reg2_out;

endmodule