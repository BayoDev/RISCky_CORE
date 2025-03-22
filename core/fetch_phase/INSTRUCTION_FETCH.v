module INSTRUCTION_FETCH(
    input       clk,
    input       reset,

    input               is_branch,
    input [31:0]        branch_result,

    // INTERFACE WITH NEXT VALUE

    // A double AXI-like interface is needed (?) to exchange data channels in and out

    // AXI output interface (SOURCE)
    output reg [31:0]   axi_write_address,
    output reg          axi_write_valid,
    input               axi_write_ready,

    // AXI input interface  (DESTINATION)
    input  [31:0]       axi_read_value,
    input               axi_read_valid,
    output reg          axi_read_ready

);

wire [31:0] data_in,data_out;
reg [31:0] output_value;

// TODO: check if using the clock as write_enable works
pc_register pc(clk,clk,reset,data_in,data_out);

assign data_in = is_branch ? branch_result : data_out+4;

// SOURCE logic
// Comunicate address to memory controller
always @(posedge clk) begin
    if(axi_write_ready && !axi_write_valid) begin
        axi_write_address <= data_out;
        // axi_write_valid <= 1'b1;
    end
end

// DESTINATION logic
// Receive data from memory controller
always @(posedge clk) begin
    if(axi_read_valid) begin
        output_value <= axi_read_value;
        // axi_write_valid <= 1'b0;
    end
    axi_read_ready <= 1'b1;
end

endmodule