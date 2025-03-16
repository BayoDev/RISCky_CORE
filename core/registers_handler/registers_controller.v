
module registers_controller(
    input [4:0]         src_one,
    input [4:0]         src_two,

    input [4:0]         dest,
    input               write_enable,
    input               clk,
    input [31:0]        data_in,
    
    output [31:0]       out_one,out_two
);

Reg32Mux registers_mux(
    src_one,
    src_two,
    dest,
    write_enable,
    clk,
    data_in,
    data_out_one,
    data_out_two
);

endmodule