module mem_interface(

    input [31:0]    in_data,
    input           in_valid,
    output          ready_for_input,

    output reg [7:0]    out_data,
    output              out_valid,
    input               output_is_ready,

    input           clk,
    input           rst

);

always @(posedge clk) begin
    if(clk && ready_for_input){
        
    }
end

endmodule