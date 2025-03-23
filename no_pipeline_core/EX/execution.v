
module execution(

    // INPUT

    input clk,rst,

    input [31:0]    op1,
    input [31:0]    op2,

    input [63:0]    sign_extended,

    input           ALU_src,
    input [2:0]     ALU_op,
    input [6:0]     ALU_op_ext,

    input [31:0]    in_pc_value,

    input           is_branch_in,

    // OUTPUT

    output [31:0]           res,
    output                  zero,
    output [31:0]           branch_result,
    output [31:0]           second_reg_propagation,
    output                  is_branch_out
);

assign second_reg_propagation = op2;

wire [31:0] ass_op2 = (ALU_src) ? 
                        ((sign_extended[31:25]==7'b0000001 || sign_extended[31:25]==7'b0000101) 
                        ? sign_extended[11:7] : sign_extended[31:20] )
                    : op2;

ALU alu(
    .op1(op1),
    .op2(ass_op2),

    .ALU_op(ALU_op),
    
    .res(res)
);

assign zero = (res==32'b0) ? 1'b1 : 1'b0;

// IDK if this is right
wire signed [31:0] b_type_imm = {{20{sign_extended[31]}},sign_extended[7],sign_extended[30:25],sign_extended[11:8],1'b0};
// wire signed [63:0] shifted = (sign_extended>>>23);
// wire signed [31:0] half_extended = shifted[31:0];
assign branch_result = b_type_imm + in_pc_value;

endmodule