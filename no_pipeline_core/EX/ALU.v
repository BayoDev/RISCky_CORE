
module ALU(
    input [31:0]    op1,op2,

    input [2:0]     ALU_op,
    input [6:0]     ALU_op_ext,

    output signed [31:0]   res
);

// OPCODE
//      0x00 ADD
//      0x00 SUB

wire signed [31:0] signed_op1 = $signed(op1);
wire signed [31:0] signed_op2 = $signed(op2);

assign res= (ALU_op==3'b000 && ALU_op_ext==7'b0100000) ? signed_op1-signed_op2  :
            (ALU_op==3'b000) ? signed_op1+signed_op2 :

            (ALU_op==3'b100) ? signed_op1^signed_op2  :
            (ALU_op==3'b110) ? signed_op1|signed_op2  :
            (ALU_op==3'b111) ? signed_op1&signed_op2  :
            (ALU_op==3'b001) ? signed_op1<<signed_op2 :

            (ALU_op==3'b101 && ALU_op_ext==7'b0100000) ? $signed(signed_op1>>>signed_op2) :    // msb-extends ($signed is needed for some reason)
            (ALU_op==3'b101) ? signed_op1>>signed_op2 :                      

            (ALU_op==3'b010) ? ((signed_op1<signed_op2) ? 'b1 : 'b0 ) :
            (ALU_op==3'b011) ? ((op1<op2) ? 'b1 : 'b0 ) : 32'h00000000;

endmodule