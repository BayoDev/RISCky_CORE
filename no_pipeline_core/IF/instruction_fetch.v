module instruction_fetch
#(
    parameter XLEN = 32
)
(

    // INPUT

    // Global singlas
    input clk, rst,

    // Result of previous branch operation
    input [XLEN-1:0] branch_result,
    
    // Whether to use increased PC value or branch result (1==>use branch result)
    input was_branch,

    // OUTPUT

    // Instruction to be executed
    output reg [31:0] instr_out,

    // PC corresponding to the instruction that is being executed
    output reg [XLEN-1:0] pc_propagation
);

wire [31:0] instr_wire_out;
wire [XLEN-1:0] pc_prop_wire;

pc_register #(
    .XLEN(XLEN)
)
pc
(
    .clk(clk),
    .rst(rst),
    .write_en(was_branch),
    .data_in(branch_result),
    .data_out(pc_prop_wire)
);

instruction_memory #(
    .XLEN(XLEN)
)
mem
(
    .clk(clk),
    .rst(rst),
    .address(was_branch ? branch_result : pc_prop_wire), // Use branch_result immediately if was_branch is true
    .data_out(instr_wire_out)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        instr_out <= 32'b0;
        pc_propagation <= {XLEN{1'b0}}; // Corrected reset value
    end else begin
        instr_out <= instr_wire_out;
        pc_propagation <= was_branch ? branch_result : pc_prop_wire; // Update pc_propagation accordingly
    end
end

endmodule