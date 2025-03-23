
module instruction_decoding(
    input clk,rst,

    input [31:0]        instruction,
    output [63:0]       sign_extended,
    output [31:0]       first_reg,
    output [31:0]       second_reg,

    // TODO: find better naming, this implementation is used to ease
    //       the modification to a pipelined architecture
    output [4:0]        reg_write_target,
    output              reg_write,

    input [4:0]         reg_write_dest,
    input               need_to_write,
    input [31:0]        reg_write_dest_value,

    // 0 = register, 1 = immediate
    output              ALU_src,
    output  [2:0]       ALU_opcode
);

wire [6:0] opcode       = instruction     [6:0];
wire [4:0] rd           = instruction     [11:7];
wire [2:0] funct3       = instruction     [14:12];
wire [4:0] rs1          = instruction     [19:15];
wire [4:0] rs2          = instruction     [24:20];
wire [6:0] funct7       = instruction     [31:25];

assign reg_write_target = rd;
assign reg_write = (opcode!=8'b1100011 && opcode!=8'b0100011 && opcode!=8'b1110011) ? 1'b1 : 1'b0;

assign sign_extended = instruction[31] ? {32'b1,instruction} : {32'b0,instruction};
assign ALU_opcode = funct3;
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