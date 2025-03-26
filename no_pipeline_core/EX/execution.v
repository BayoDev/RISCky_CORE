
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
assign zero = (res==32'b0) ? 1'b1 : 1'b0;

// Decide which data is used as second operand for the ALU operation.
// Four cases:
//      - ALU_src is set => 
//          - Handle immediate case ...
//          - ...
//      - ALU_src is not set => op2
wire [31:0] ass_op2 = (ALU_src) ? 
                        ((sign_extended[31:25]==7'b0000001 || sign_extended[31:25]==7'b0000101) 
                        ? sign_extended[11:7] : sign_extended[31:20] )
                    : op2;

ALU alu(
    .op1(op1),
    .op2(ass_op2),

    .ALU_op(ALU_op),
    .ALU_op_ext(ALU_op_ext),
    
    .res(res)
);

// Valid branch
assign is_branch_out = (!is_branch_in) ? 'b0 : (
                (ALU_op=='b0 && zero) ?  'b1:
                (ALU_op=='b1 && !zero) ? 'b1 :
                (ALU_op=='b100 && ($signed(op1)<$signed(op2))) ? 'b1 :
                (ALU_op=='b101 && ($signed(op1)>=$signed(op2))) ? 'b1 :
                (ALU_op=='b110 && (op1<op2)) ? 'b1 :
                (ALU_op=='b111 && (op1>=op2)) ? 'b1 : 'b0
        );

// Branch target
wire signed [31:0] b_type_imm = {{20{sign_extended[31]}},sign_extended[7],sign_extended[30:25],sign_extended[11:8],1'b0};
assign branch_result = b_type_imm + in_pc_value;

endmodule