module instruction_memory
#(
    parameter XLEN = 32
)
(

    input clk,rst,

    input [XLEN-1:0]    address,
    output [31:0]      data_out
);


`ifdef SIMULATION

reg [31:0] memory [8191:0];


integer i;
initial begin
    for (i = 0; i < 8192; i = i + 1) begin
        memory[i] = 32'b0;
    end

    $readmemh("./software_tests/out/test_code.hex", memory,0);
end

// I do the shifting because the memory should be byte-addressed in theory
assign data_out = memory[address>>2];

`else


reg [31:0] memory [63:0];
integer i;
initial begin
    // for (i = 0; i < 64; i = i + 1) begin
    //     memory[i] = 32'b0;
    // end
    memory[0] = 'h06100293;
    memory[1] = 'h68000513;
    memory[2] = 'h00550023;
    memory[3] = 'hff5ff06f;
end

assign data_out = memory[address>>2];

// wire [31:0] sp_do;
// SP#(
//     .BIT_WIDTH(32), 
//     .RESET_MODE("ASYNC"),
//     .INIT_RAM_00(256'h061002936800051300550023ff5ff06f)
// )
// block_sram
// (
//     .DO(data_out),
//     .AD(address),
//     .RESET(rst)
// );
`endif 

endmodule