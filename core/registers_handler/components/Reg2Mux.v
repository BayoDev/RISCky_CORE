
module Reg2Mux(
    input           src_one,
    input           src_two,

    input           dest,
    input           write_enable,
    input           clk,
    input           reset,
    input  [31:0]   data_in,

    output [31:0]   out_one,
    output [31:0]   out_two
);

wire [31:0] reg1_out,reg2_out;

register reg1(write_enable && ~dest ,clk,reset,data_in,reg1_out);
register reg2(write_enable && dest,clk,reset,data_in,reg2_out);

assign out_one = src_one ? reg2_out : reg1_out;
assign out_two = src_two ? reg2_out : reg1_out;

endmodule