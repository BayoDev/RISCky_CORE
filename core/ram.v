`define ADDR_LEN 32

module RAM (
    input                           clk,
    input                           write_enable,
    input       [`ADDR_LEN-1:0]     address,
    input       [15:0]              data_in,
    output reg  [15:0]              data_out
);

// Too big for real implementation
// 1 << `ADDR_LEN == 2**32
// reg [15:0] ram_block[0:(1<<`ADDR_LEN)-1];

reg[15:0] ram_block[0:(1<<5)-1];

always @(posedge clk) begin
    if(write_enable)
        ram_block[address] <= data_in;
    else
        data_out <= ram_block[address]; 
end
    
endmodule