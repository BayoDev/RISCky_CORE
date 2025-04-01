module memory_access(

    input clk,rst,

    // INPUT

    input [31:0]    ex_result,
    input           ex_zero,
    input           is_branch_op,
    input           mem_write,
    input           mem_read,

    input [31:0]    write_data,

    input           dest_reg_prog_in,

    // OUTPUT

    output           is_valid_branch,
    output           dest_reg_prog_out,

    output [31:0]    memory_res,original_value

);

assign dest_reg_prog_out = dest_reg_prog_in;
assign original_value = ex_result;

// Logging for memory operations
always @(posedge clk) begin
    if (mem_write) begin
        $display("Memory Write: Address = %h, Data = %h", ex_result, write_data);
    end
    if (mem_read) begin
        $display("Memory Read: Address = %h, Data = %h", ex_result, memory_res);
    end
end

// TODO: propagate content of 2nd register to use in store operations

data_memory mem(

    .clk(clk),
    .rst(rst),

    .address(ex_result),
    .data_out(memory_res),

    .data_in(write_data),
    .write_enable(mem_write)

);

endmodule