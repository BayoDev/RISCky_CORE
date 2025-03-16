
module Reg32Mux(
    input [4:0]           src_one,
    input [4:0]           src_two,

    input  [4:0]    dest,
    input           write_enable,
    input           clk,
    input  [31:0]   data_in,

    output [31:0]   out_one,
    output [31:0]   out_two
);

wire [31:0] reg1_out,reg2_out,reg3_out,reg4_out;

Reg4Mux reg1(src_one[3:0],src_two[3:0],dest[3:0],write_enable && ~dest[4],clk,data_in,reg1_out,reg2_out);
Reg4Mux reg2(src_one[3:0],src_two[3:0],dest[3:0],write_enable && dest[4],clk,data_in,reg3_out,reg4_out);

assign out_one = src_one[4] ? reg3_out : reg1_out;
assign out_two = src_two[4] ? reg4_out : reg2_out;

endmodule