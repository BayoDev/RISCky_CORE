
module data_memory
#(
    parameter XLEN = 32,
    parameter uart_rx_data = 'h650,
    parameter uart_rx_ready = 'h660,
    parameter uart_tx_addr = 'h680
)
(

    input clk,rst,

    input [XLEN-1:0]    address,
    output [XLEN-1:0]      data_out,

    input [XLEN-1:0]        data_in,
    input               write_enable,


    output reg [7:0] uart_tx_out,
    output  reg     uart_tx_ready

);

// (* syn_ramstyle = "block_ram" *) 
reg [XLEN-1:0] memory [255:0];

integer i;
initial begin
    for (i = 0; i < 256; i = i + 1) begin
        memory[i] = XLEN'b0;
    end
end


// do this better
always @(posedge clk) begin
    if(write_enable) begin
        if(address==uart_tx_addr)begin
            uart_tx_out <= data_in;
            uart_tx_ready <= 'b1;
        end
        else begin
            memory[address] <= data_in;
            uart_tx_ready <= 'b0;
        end
    end
end


assign data_out = memory[address];

endmodule