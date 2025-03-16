
module Reg4Mux(
    input [1:0]           src_one,
    input [1:0]           src_two,

    input  [1:0]    dest,
    input           write_enable,
    input           clk,
    input  [31:0]   data_in,

    output [31:0]   out_one,
    output [31:0]   out_two
);

wire [31:0] reg1_out,reg2_out,reg3_out,reg4_out;

Reg2Mux reg1(src_one[0],src_two[0],dest[0],write_enable && ~dest[1],clk,data_in,reg1_out,reg2_out);
Reg2Mux reg2(src_one[0],src_two[0],dest[0],write_enable && dest[1],clk,data_in,reg3_out,reg4_out);

assign out_one = src_one[1] ? reg3_out : reg1_out;
assign out_two = src_two[1] ? reg4_out : reg2_out;

endmodule