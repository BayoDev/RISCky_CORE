module test_bench();

reg clk,rst;
always #5 clk = ~clk; 

reg signed [31:0] alu_op1,alu_op2;
wire signed [31:0] alu_res;
reg [2:0] alu_in_op;
reg [6:0] alu_op_ext;

ALU alu_mod(
    .op1(alu_op1),
    .op2(alu_op2),
    
    .ALU_op(alu_in_op),
    .ALU_op_ext(alu_op_ext),

    .res(alu_res)
);

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,test_bench);

    rst = 0;
    #1 rst = 1;
    #2 rst = 0;

    //=====================
    //      ALU TEST
    //=====================

    alu_op1 = 'd10;
    alu_op2 = 'd20;

    // ADD

    alu_in_op = 'b0;
    alu_op_ext = 'b0;

    #1 $display("[TEST] ADD %d = %d + %d",alu_res,alu_op1,alu_op2);

    // SUB

    alu_in_op =  'b0;
    alu_op_ext = 'h20;

    #1 $display("[TEST] SUB %d = %d - %d",alu_res,alu_op1,alu_op2);

    // XOR

    alu_in_op =  'h4;
    alu_op_ext = 'h0;

    #1 $display("[TEST] XOR %d = %d ^ %d",alu_res,alu_op1,alu_op2);

    // OR

    alu_in_op =  'h6;
    alu_op_ext = 'h0;

    #1 $display("[TEST] OR  %d = %d | %d",alu_res,alu_op1,alu_op2);

    // AND

    alu_in_op =  'h7;
    alu_op_ext = 'h0;

    #1 $display("[TEST] AND %d = %d & %d",alu_res,alu_op1,alu_op2);

    // SLL (Shift Left Logical)

    alu_op1 = 'd1;
    alu_op2 = 'd2;

    alu_in_op = 'h1;
    alu_op_ext = 'h0;

    #1 $display("[TEST] SLL %d = %d << %d",alu_res,alu_op1,alu_op2);

    // SRL (Shift Right Logical)

    alu_op1 = 32'h88000000;
    alu_op2 = 'd2;

    alu_in_op = 'h5;
    alu_op_ext = 'h0;

    #1 $display("[TEST] SRL %d = %d >> %d",alu_res,alu_op1,alu_op2);

    // SRA (Shift Right Arithmetic)

    alu_op1 = 32'h88000000;
    alu_op2 = 'd2;

    alu_in_op = 'h5;
    alu_op_ext = 'h20;

    #1 $display("[TEST] SRA %d = %d >>> %d",alu_res,alu_op1,alu_op2);
    
    // SLT

    alu_in_op = 'h2;
    alu_op_ext = 'h0;

    #1 $display("[TEST] SLT %d < %d ? %b",alu_op1,alu_op2,alu_res[0]);

    // SLTU

    alu_in_op = 'h3;

    #1 $display("[TEST] SLTU %d < %d ? %b",alu_op1,alu_op2,alu_res[0]);

    #100 $finish;
end

endmodule