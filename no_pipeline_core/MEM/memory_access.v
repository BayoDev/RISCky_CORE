module memory_access
#(
    parameter XLEN = 32
)
(

    input clk,rst,

    // INPUT

    input [XLEN-1:0]    ex_result,
    input           ex_zero,
    input           is_branch_op,
    input           mem_write,
    input           mem_read,

    input [XLEN-1:0]    write_data,

    input           dest_reg_prog_in,

    // OUTPUT

    output           is_valid_branch,
    output           dest_reg_prog_out,

    output [XLEN-1:0]    memory_res,original_value,

    // UART

    output reg [7:0] uart_tx_out,
    output  reg     uart_tx_ready

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

data_memory 
#(
    .XLEN(XLEN)
)
mem(

    .clk(clk),
    .rst(rst),

    .address(ex_result),
    .data_out(memory_res),

    .data_in(write_data),
    .write_enable(mem_write),

    .uart_tx_out(uart_tx_out),
    .uart_tx_ready(uart_tx_ready)
);

endmodule