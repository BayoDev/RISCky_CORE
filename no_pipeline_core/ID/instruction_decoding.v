
module instruction_decoding(

    // INPUT

    input clk,rst,
    input [31:0]        instruction,

    input [4:0]         reg_write_dest,
    input               need_to_write,
    input [31:0]        reg_write_dest_value,
    input [31:0]        in_pc_value,

    // OUTPUT

    output [63:0]       sign_extended,
    output [31:0]       first_reg,
    output [31:0]       second_reg,
    

    output [4:0]        reg_write_target,
    output              reg_write,
    output              reg_write_from_load,

    output [31:0]       out_pc_value,

    // control data
    output [2:0]         ALU_op_base,
    output [6:0]         ALU_op_ext,
    output               ALU_src,           // check if use reg2 or imm

    output [31:0]        imm_value,

    output               is_branch,
    output               mem_write,
    output               mem_read,

    output               is_write_back


);

assign out_pc_value = in_pc_value;

wire [6:0] opcode       = instruction     [6:0];
wire [4:0] rd           = instruction     [11:7];
wire [2:0] funct3       = instruction     [14:12];
wire [4:0] rs1          = instruction     [19:15];
wire [4:0] rs2          = instruction     [24:20];
wire [6:0] funct7       = instruction     [31:25];

assign reg_write_target = rd;
assign reg_write = (opcode!=8'b1100011 && opcode!=8'b0100011 && opcode!=8'b1110011) ? 1'b1 : 1'b0;

assign reg_write_from_load = (opcode==8'b0000011) ? 1'b1 : 1'b0;

assign is_branch = (opcode == 8'b1100011)? 1'b1 : 1'b0;

assign sign_extended = {{32{instruction[31]}}, instruction};

// assign is_R_format = opcode == 'b0110011;
assign is_I_format = (opcode == 'b0010011) || (opcode == 'b0000011) || (opcode== 'b1100111) || (opcode == 'b1110011);
assign is_J_format = opcode == 'b1101111;
assign is_S_format = opcode == 'b0100011;
assign is_B_format = opcode == 'b1100011;
assign is_U_format = opcode == 'b0110111;

// The R-format is not necessary and should go to the last else case (32'b0)
assign imm_value = 
            (is_I_format) ? {{21{instruction[31]}},instruction[31:20]} :
            (is_J_format) ? {{11{instruction[31]}},instruction[31],instruction[21:12],instruction[22],instruction[30:23],1'b0} :
            (is_S_format) ? {{20{instruction[31]}},instruction[31:25],instruction[11:7]} :
            (is_B_format) ? {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0} :
            (is_U_format) ? {instruction[31:12],12'b0} : 32'b0;

assign ALU_op_base = funct3;
assign ALU_op_ext = funct7;
assign ALU_src = (opcode==8'b0010011)? 1'b1: 1'b0;

registers_controller reg_ctr(
    .src_one(rs1),
    .src_two(rs2),
    .dest(reg_write_dest),
    .write_enable(need_to_write),
    .clk(clk),
    .reset(rst),
    .data_in(reg_write_dest_value),
    .out_one(first_reg),
    .out_two(second_reg)
);

endmodule