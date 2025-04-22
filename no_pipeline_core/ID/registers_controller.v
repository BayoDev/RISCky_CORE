
module registers_controller
#(
    parameter XLEN = 32,
    parameter REG_SEL_LEN = 5
)
(
    input [REG_SEL_LEN-1:0]         src_one,
    input [REG_SEL_LEN-1:0]         src_two,

    input [REG_SEL_LEN-1:0]         dest,
    input                       write_enable,
    input                       clk,reset,
    input [XLEN-1:0]            data_in,
    
    output [XLEN-1:0]       out_one,out_two
);

integer i;
reg [XLEN-1:0] registers_file [(1<<REG_SEL_LEN)-1:0];

// TODO: check for clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (i = 0; i < (1 << REG_SEL_LEN); i = i + 1) begin
            registers_file[i] <= 0;
        end
    end
    // This actually writes into x0 but it shouldnt matter (?)
    else if(write_enable) begin
        registers_file[dest] <= data_in;
    end
end

assign out_one = (src_one=='b00000) ? 'b0 : registers_file[src_one] ;
assign out_two = (src_two=='b00000) ? 'b0 : registers_file[src_two] ;

endmodule