module instruction_fetch(

    input clk,rst,

    input [31:0]    branch_result,
    input           was_branch,

    output reg [31:0]   instr_out,

    // Propagation
    output reg [31:0]       pc_propagation

);

wire [31:0] instr_wire_out,pc_prop_wire;

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
    .address(pc_prop_wire),
    .data_out(instr_wire_out)
);

always @(posedge clk or posedge rst) begin
    if(rst) begin
        instr_out <= 32'b0;
        pc_propagation <= 32'b0;
    end
    else begin
        instr_out <= instr_wire_out;
        pc_propagation <= pc_prop_wire;
    end
    // $display("[IF-PHASE] PC: 0x%08h INSTR: 0x%08h",data_out,instr_out);
end

// always @(negedge clk)begin
    
// end

endmodule