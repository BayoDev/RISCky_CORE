
module Reg16Mux
#(
    parameter XLEN = 32
)
(
    input [3:0]           src_one,
    input [3:0]           src_two,

    input  [3:0]    dest,
    input           write_enable,
    input           clk,
    input           reset,
    input  [XLEN-1:0]   data_in,

    output [XLEN-1:0]   out_one,
    output [XLEN-1:0]   out_two
);

wire [XLEN-1:0] reg1_out,reg2_out,reg3_out,reg4_out;

Reg8Mux reg1(src_one[2:0],src_two[2:0],dest[2:0],write_enable && ~dest[3],clk,reset,data_in,reg1_out,reg2_out);
Reg8Mux reg2(src_one[2:0],src_two[2:0],dest[2:0],write_enable && dest[3],clk,reset,data_in,reg3_out,reg4_out);

assign out_one = src_one[3] ? reg3_out : reg1_out;
assign out_two = src_two[3] ? reg4_out : reg2_out;

endmodule