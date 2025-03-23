module pc_register(
    input clk,rst,

    input [31:0]       data_in,
    input              write_en,
    output reg [31:0]  data_out
);

reg was_rst;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        was_rst <= 1'b1;
        data_out <= 32'b0;
    end
    else if (write_en)
        data_out <= data_in;
    else begin
        if(was_rst) begin
            data_out <= 32'b0;
            was_rst <= 1'b0;
        end
        else 
            data_out <= data_out + 1;
    end

end

endmodule