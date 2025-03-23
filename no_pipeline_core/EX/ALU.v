
module ALU(
    input [31:0]    op1,op2,

    input [2:0]     ALU_op,

    output [31:0]   res
);

// OPCODE
//      0x00 ADD
//      0x00 SUB

assign res= (ALU_op==3'b000) ? op1+op2  :
            (ALU_op==3'b100) ? op1^op2  :
            (ALU_op==3'b110) ? op1|op2  :
            (ALU_op==3'b111) ? op1&op2  :
            (ALU_op==3'b001) ? op1<<op2 :
            (ALU_op==3'b011) ? op1>>op2 :
            (ALU_op==3'b010) ? ((op1<op2)? 32'hFFFFFFFF : 32'h00000000) : 32'h00000000;

endmodule