
module write_back(

    input mem_to_reg,
    input [31:0] data,orig,
    
    output  [31:0]  result
);

assign result = (mem_to_reg) ? data : orig;

endmodule