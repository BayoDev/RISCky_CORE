
module registers_controller
#(
    parameter XLEN = 32
)
(
    input [4:0]         src_one,
    input [4:0]         src_two,

    input [4:0]         dest,
    input               write_enable,
    input               clk,reset,
    input [XLEN-1:0]        data_in,
    
    output [XLEN-1:0]       out_one,out_two
);

wire [XLEN-1:0]     int_out_one,int_out_two;

Reg32Mux registers_mux(
    .src_one(src_one),
    .src_two(src_two),
    .dest(dest),
    .write_enable(write_enable),
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .out_one(int_out_one),
    .out_two(int_out_two)
);

assign out_one = (src_one=='b00000) ? 'b0 : int_out_one ;
assign out_two = (src_two=='b00000) ? 'b0 : int_out_two ;

endmodule