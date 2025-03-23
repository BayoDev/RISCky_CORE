

module top_bench();

reg clk,rst;
always #5 clk = ~clk; 


reg was_branch;
reg [31:0] if_branch_res;
wire [31:0] if_instr_out;
integer i;

instruction_fetch if_phase(
    .clk(clk),
    .rst(rst),
    .branch_result(if_branch_res),
    .was_branch(was_branch),
    .instr_out(if_instr_out)
);

wire [63:0] id_sign_extended;
wire [31:0] id_first_reg,id_second_reg;
wire id_ALU_src;
wire [2:0] id_ALU_opcode;

wire [4:0]  id_reg_write_target;
wire        id_reg_write;

wire [31:0] ex_res;

instruction_decoding id_phase(
    .clk(clk),
    .rst(rst),
    .instruction(if_instr_out),
    .sign_extended(id_sign_extended),
    .first_reg(id_first_reg),
    .second_reg(id_second_reg),

    .ALU_src(id_ALU_src),
    .ALU_opcode(id_ALU_opcode),

    .reg_write_dest(id_reg_write_target),
    .need_to_write(id_reg_write),
    .reg_write_dest_value(ex_res),

    .reg_write_target(id_reg_write_target),
    .reg_write(id_reg_write)
);


wire ex_zero;
execution ex_phase(
    .clk(clk),
    .rst(rst),

    .op1(id_first_reg),
    .op2(id_second_reg),
    .sign_extended(id_sign_extended),
    .ALU_src(id_ALU_src),
    .ALU_op(id_ALU_opcode),

    .res(ex_res),
    .zero(ex_zero)
);

// write_back wb_phase(
//     .mem_to_reg()

// )

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,top_bench);

    clk = 0;
    rst=0;
    #1 rst = 1;
    #10 rst = 0;
    #100 $finish;
end

endmodule