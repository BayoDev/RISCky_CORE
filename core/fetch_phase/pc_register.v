
module pc_register(
    input             write_enable,
    input             clk,
    input             reset,
    input      [31:0] data_in,
    output reg [31:0] data_out
);

// TODO: check for clock
always @(posedge clk or posedge reset) begin
    if(reset)
        data_out <= 32'h00000000;
    else if(write_enable)
        data_out <= data_in;
end

endmodule