
module execution
#(
    parameter XLEN = 32
)
(

    // INPUT

    // Global signals
    input clk,rst,

    // First operand
    input [XLEN-1:0]    op1,
    // Second operand
    input [XLEN-1:0]    op2,
    
    // Defines ALU op
    input [2:0]     ALU_op,
    // Defines additional ALU op info
    input [6:0]     ALU_op_ext,
    // If set, use imm_value instead of op2
    input           ALU_src,

    // PC value used for branch target calculation
    input [XLEN-1:0]    in_pc_value,

    // Set if is a branch operation
    input                   is_branch_in,

    // Value of immediate field
    input signed [XLEN-1:0]     imm_value,

    input [2:0]     funct3_prop_in,

    // OUTPUT

    // Result of ALU operation
    output [XLEN-1:0]           res,

    // Is set if result is zero
    output                  zero,

    // Result of branch operation (TODO: merge this with normal ALU operation if possible)
    output [XLEN-1:0]           branch_result,

    // Propagate second register value
    output [XLEN-1:0]           second_reg_propagation,

    // Is set if it's a branch operation and the condition for the branch is met
    output                  is_branch_out,

    output [2:0]            funct3_prop_out
);

//=====================
//         ALU
//=====================

// Decide which data is used as second operand for the ALU operation.
// Four cases:
//      - ALU_src is set => 
//          - Handle immediate case ...
//          - ...
//      - ALU_src is not set => op2
wire [XLEN-1:0] ass_op2 = (ALU_src) ?  imm_value : op2;

RISCV_ALU 
#(
    .XLEN(XLEN)
)
alu
(
    .op1(op1),
    .op2(ass_op2),

    .ALU_op(ALU_op),
    .ALU_op_ext(ALU_op_ext),
    
    .res(res)
);

//=====================
//    BRANCH LOGIC
//=====================

// TODO: can you handle this using the ALU instead of re-implementing these operations?
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
assign branch_result = imm_value + in_pc_value;

//=====================
//        FLAGS
//=====================

assign second_reg_propagation = op2;
assign zero = (res=={XLEN{1'b0}}) ? 1'b1 : 1'b0;
assign funct3_prop_out = funct3_prop_in;

endmodule