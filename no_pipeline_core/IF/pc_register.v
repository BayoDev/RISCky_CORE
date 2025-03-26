module pc_register(
    input clk,rst,

    input [31:0]       data_in,
    input              write_en,
    output reg [31:0]  data_out
);

always @(posedge clk or posedge rst) begin
    if(rst)
        data_out <= 32'b0;
    else 
        data_out <=  data_out + 4;
end

always @(negedge clk) begin
    if(!rst && write_en)
        data_out <= data_in;
end

endmodule