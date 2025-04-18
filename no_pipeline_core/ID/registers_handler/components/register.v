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
        data_out <= {XLEN{1'b0}}; // Explicitly specify XLEN width
    else if(write_enable)
        data_out <= data_in;
end


endmodule
