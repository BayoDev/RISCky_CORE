
module execution(
    input clk,rst,

    input [31:0]    op1,
    input [31:0]    op2,

    input [63:0]    sign_extended,

    input           ALU_src,
    input [2:0]     ALU_op,

    output [31:0]          res,
    output                  zero
);


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

endmodule