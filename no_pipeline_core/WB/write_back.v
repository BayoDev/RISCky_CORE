
module write_back
#(
    parameter XLEN = 32
)
(

    input mem_to_reg,
    input [XLEN-1:0] data,orig,
    
    output  [XLEN-1:0]  result
);

assign result = (mem_to_reg) ? data : orig;

endmodule