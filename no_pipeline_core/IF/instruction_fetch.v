module instruction_fetch(
    input clk, rst,
    input [31:0] branch_result,
    input was_branch,
    output reg [31:0] instr_out,
    output reg [31:0] pc_propagation
);

wire [31:0] instr_wire_out, pc_prop_wire;

pc_register pc(
    .clk(clk),
    .rst(rst),
    .write_en(was_branch),
    .data_in(branch_result),
    .data_out(pc_prop_wire)
);

instruction_memory mem(
    .clk(clk),
    .rst(rst),
    .address(was_branch ? branch_result : pc_prop_wire), // Use branch_result immediately if was_branch is true
    .data_out(instr_wire_out)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        instr_out <= 32'b0;
        pc_propagation <= 32'b0;
    end else begin
        instr_out <= instr_wire_out;
        pc_propagation <= was_branch ? branch_result : pc_prop_wire; // Update pc_propagation accordingly
    end
end

endmodule