
module register
#(
    parameter XLEN = 32
)
(
    input             write_enable,
    input             clk,
    input             reset,
    input      [XLEN-1:0] data_in,
    output reg [XLEN-1:0] data_out
);

// TODO: check for clock
always @(posedge clk or posedge reset) begin
    if(reset)
        data_out <= XLEN'b0;
    else if(write_enable)
        data_out <= data_in;
end


endmodule
