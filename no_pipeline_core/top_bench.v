

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