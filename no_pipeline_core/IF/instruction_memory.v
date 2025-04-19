module instruction_memory
#(
    parameter XLEN = 32
)
(

    input clk,rst,

    input [XLEN-1:0]    address,
    output [31:0]      data_out
);

// reg [31:0] memory [128:0]

(* syn_ramstyle = "block_ram" *) 
reg [31:0] memory [511:0];

integer i;
initial begin
    for (i = 0; i < 512; i = i + 1) begin
        memory[i] = 32'b0;
    end
end

initial begin
    $readmemh("./no_pipeline_core/IF/bios.hex", memory,0,511);
end

// always @(posedge clk) begin
//     data_out <= memory[address];
// end

// I do the shifting because the memory should be byte-addressed in theory
assign data_out = memory[address>>2];


endmodule