
module IF_ID_barrier
#(
    parameter XLEN = 32
)(
    
    input clk,rst,

    input [31:0]    if_instr_out,
    output reg [31:0]  id_instr_in,

    input [XLEN-1:0] if_pc_propagation_out,
    output reg [XLEN-1:0] id_pc_propagation_in

);


    
endmodule