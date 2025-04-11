
module Reg2Mux
#(
    parameter XLEN = 32
)
(
    input           src_one,
    input           src_two,

    input           dest,
    input           write_enable,
    input           clk,
    input           reset,
    input  [XLEN-1:0]   data_in,

    output [XLEN-1:0]   out_one,
    output [XLEN-1:0]   out_two
);

wire [XLEN-1:0] reg1_out,reg2_out;

register 
#(
    .XLEN(XLEN)
)
reg1(write_enable && ~dest ,clk,reset,data_in,reg1_out);

register 
#(
    .XLEN(XLEN)
)
reg2(write_enable && dest,clk,reset,data_in,reg2_out);

assign out_one = src_one ? reg2_out : reg1_out;
assign out_two = src_two ? reg2_out : reg1_out;

endmodule