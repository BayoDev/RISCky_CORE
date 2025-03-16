
module register(
    input             write_enable,
    input             clk,
    input      [31:0] data_in,
    output reg [31:0] data_out
);

// TODO: check for clock
always @(posedge clk) begin
    if(write_enable)
        data_out <= data_in;
end

endmodule