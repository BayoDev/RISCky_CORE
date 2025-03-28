

module top_bench();

reg clk,rst;
always #5 clk = ~clk; 

integer i;

//=======================
//      STAGE WIRES
//=======================

// IF

// input
wire [31:0] if_branch_result_in;
wire if_was_branch_in;

// output
wire [31:0] if_instr_out;
wire [31:0] if_pc_propagation_out;

// ID

// input
wire [31:0]     id_instr_in;
wire [4:0]      id_write_reg_dest_in;
wire            id_write_en_in;
wire [31:0]     id_write_value_in;
wire [31:0]     id_pc_propagation_in;

// output
wire [63:0]     id_sign_extended_out;
wire [31:0]     id_first_reg_out;
wire [31:0]     id_second_reg_out;
wire [4:0]      id_write_reg_dest_out;
wire            id_write_en_out;
wire            id_reg_write_from_load;
wire [31:0]     id_pc_propagation_out;
wire [2:0]      id_alu_op_base_out;
wire [6:0]      id_alu_op_ext_out;
wire            id_alu_src_out;
wire            id_is_branch_out;
wire            id_is_write_back;
wire            id_mem_write_out;
wire            id_mem_read_out;
wire [31:0]     id_imm_value_out;

// EX

// input
wire [31:0]     ex_op1_in;
wire [31:0]     ex_op2_in;
wire [63:0]     ex_sign_extended_in;
wire [2:0]      ex_alu_op_base_in;
wire [6:0]      ex_alu_op_ext_in;
wire            ex_alu_src_in;
wire [31:0]     ex_pc_propagation_in;
wire            ex_is_branch_in;
wire [31:0]     ex_imm_value_in;

// output
wire [31:0]     ex_result_out;
wire            ex_zero_out;
wire [31:0]     ex_branch_result_out;
wire [31:0]     ex_second_reg_propagation_out;
wire            ex_is_branch_out;

// MEM

// input

wire [31:0]     mem_ex_result_in;
wire            mem_ex_zero_in;
wire            mem_is_branch_op_in;
wire            mem_is_mem_write_in;
wire            mem_is_mem_read_in;
wire [31:0]     mem_write_data_in;
wire            mem_dest_reg_prog_in;

// output
wire            mem_is_valid_branch_out;
wire            mem_dest_reg_prog_out;
wire [31:0]     mem_memory_res_out;
wire [31:0]     mem_original_value_out;

// WB 

// input
wire            wb_mem_to_reg_in;
wire [31:0]     wb_data_in;
wire [31:0]     wb_orig_in;

// output
wire [31:0]     wb_result_out;

instruction_fetch if_phase(
    .clk(clk),
    .rst(rst),

    .branch_result(if_branch_result_in),
    .was_branch(if_was_branch_in),

    .instr_out(if_instr_out),
    .pc_propagation(if_pc_propagation_out)
);

assign id_instr_in = if_instr_out;
assign id_pc_propagation_in = if_pc_propagation_out;

instruction_decoding id_phase(
    .clk(clk),
    .rst(rst),
    
    .instruction(id_instr_in),
    .reg_write_dest(id_write_reg_dest_in),
    .need_to_write(id_write_en_in),
    .reg_write_dest_value(id_write_value_in),

    .in_pc_value(id_pc_propagation_in),


    .sign_extended(id_sign_extended_out),
    .first_reg(id_first_reg_out),
    .second_reg(id_second_reg_out),
    
    .reg_write_target(id_write_reg_dest_out),
    .reg_write(id_write_en_out),
    .reg_write_from_load(id_reg_write_from_load),

    .out_pc_value(id_pc_propagation_out),
    .ALU_op_base(id_alu_op_base_out),
    .ALU_op_ext(id_alu_op_ext_out),
    .ALU_src(id_alu_src_out),
    .imm_value(id_imm_value_out),

    .is_branch(id_is_branch_out),
    .mem_write(id_mem_write_out),
    .mem_read(id_mem_read_out),
    .is_write_back(id_is_write_back)
);
// TODO: this is very messed up, this should be propagated through the ex phase
assign id_write_reg_dest_in = id_write_reg_dest_out;

assign ex_op1_in = id_first_reg_out;
assign ex_op2_in = id_second_reg_out;
assign ex_sign_extended_in = id_sign_extended_out;
assign ex_alu_src_in = id_alu_src_out;
assign ex_alu_op_base_in = id_alu_op_base_out;
assign ex_alu_op_ext_in = id_alu_op_ext_out;
assign ex_pc_propagation_in = id_pc_propagation_out;
assign ex_is_branch_in = id_is_branch_out;
assign ex_imm_value_in = id_imm_value_out;

execution ex_phase(
    .clk(clk),
    .rst(rst),

    .op1(ex_op1_in),
    .op2(ex_op2_in),
    .sign_extended(ex_sign_extended_in),

    .ALU_op(ex_alu_op_base_in),
    .ALU_op_ext(ex_alu_op_ext_in),
    .ALU_src(ex_alu_src_in),
    .imm_value(ex_imm_value_in),

    .res(ex_result_out),
    .zero(ex_zero_out),

    .in_pc_value(ex_pc_propagation_in),
    .is_branch_in(ex_is_branch_in),

    .branch_result(ex_branch_result_out),
    .second_reg_propagation(ex_second_reg_propagation_out),
    .is_branch_out(ex_is_branch_out)
);
// TODO: change this to go through mem for pipelining
assign if_branch_result_in = ex_branch_result_out;

assign mem_ex_result_in = ex_result_out;
assign mem_ex_zero_in = ex_zero_out;
assign mem_write_data_in = ex_second_reg_propagation_out;
assign if_was_branch_in = ex_is_branch_out;
assign mem_is_mem_write_in = id_mem_write_out;
assign mem_is_mem_read_in = id_mem_read_out;
assign mem_is_branch_op_in = id_is_branch_out;


memory_access mem_phase(
    .ex_result(mem_ex_result_in),
    .ex_zero(mem_ex_zero_in),
    .is_branch_op(mem_is_branch_op_in),
    .mem_write(mem_is_mem_write_in),
    .mem_read(mem_is_mem_read_in),
    .write_data(mem_write_data_in),
    .dest_reg_prog_in(mem_dest_reg_prog_in),

    .is_valid_branch(mem_is_valid_branch_out),
    .dest_reg_prog_out(mem_dest_reg_prog_out),
    .memory_res(mem_memory_res_out),
    .original_value(mem_original_value_out)
);
// TODO: change this to go through barrier with pipeline
// assign id_write_reg_dest_in = mem_dest_reg_prog_out;
assign id_write_en_in = id_write_en_out;

// assign wb_mem_to_reg_in 
assign wb_mem_to_reg_in = id_reg_write_from_load;
assign wb_data_in = mem_memory_res_out;
assign wb_orig_in = mem_original_value_out;
assign id_write_value_in = wb_result_out;

write_back wb_phase(
    .mem_to_reg(wb_mem_to_reg_in),
    .data(wb_data_in),
    .orig(wb_orig_in),

    .result(wb_result_out)
);

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,top_bench);

    clk = 0;
    rst=0;
    #1 rst = 1;
    #10 rst = 0;
    #1000 $finish;
end

endmodule