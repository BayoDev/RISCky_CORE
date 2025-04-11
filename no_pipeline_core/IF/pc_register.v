module pc_register
#(
    parameter XLEN = 32
)
(
    input clk, rst,
    input [XLEN-1:0] data_in,
    input write_en,
    output reg [XLEN-1:0] data_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= XLEN'b0;
    end else if (write_en) begin
        data_out <= data_in + 4; 
    end else begin
        data_out <= data_out + 4; 
    end
end

endmodule