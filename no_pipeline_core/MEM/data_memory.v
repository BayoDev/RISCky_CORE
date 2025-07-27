
module data_memory
#(
    parameter XLEN = 32,
    parameter uart_rx_data = 'h650,
    parameter uart_rx_ready = 'h660,
    parameter uart_tx_addr = 'h0680
)
(

    input clk,rst,

    input [XLEN-1:0]    address,
    output [XLEN-1:0]      data_out,

    input [XLEN-1:0]        data_in,
    input               write_enable,

    // In reality this will just be the funct3 field
    input [2:0]         word_size,

    output reg [7:0] uart_tx_out,
    output  reg     uart_tx_ready,

    output reg is_special
);

// (* syn_ramstyle = "block_ram" *) 
`ifdef SIMULATION
reg [7:0] memory [8191:0];
`else
reg [7:0] memory [1023:0];
`endif 

// wire [31:0] sp_do;
// SP#(
//     .BIT_WIDTH(32), 
//     .RESET_MODE("ASYNC")
// )(
//     .DO(sp_do),
//     .DI(data_in),
//     .AD(address),
//     .RESET(rst),
//     .WRE(write_enable),
//     .BLKSEL({3'b000}),
// );

integer i;
initial begin
    uart_tx_out <= 'b0;
    for (i = 0; i < 1023; i = i + 1) begin
        memory[i] = {XLEN{1'b0}};
    end
end

`ifdef SIMULATION
initial begin
    $readmemh("./software_tests/out/test_data.hex", memory,0);
end
`endif


// do this better
always @(posedge clk) begin
    if(write_enable) begin
        if(address==uart_tx_addr)begin
            uart_tx_out <= data_in;
            uart_tx_ready <= 'b1;
            is_special<='b1;
            $write("%c", data_in[7:0]); // Print ASCII byte
        end
        else begin
            case (word_size)
                'h0 : begin         // Store byte
                    memory[address] <= data_in[7:0];
                end
                'h1 : begin         // Store half
                    memory[address] <= data_in[7:0];
                    memory[address+1] <= data_in[15:8];
                end     
                'h2 : begin         // Store word
                    memory[address] <= data_in[7:0];
                    memory[address+1] <= data_in[15:8];
                    memory[address+2] <= data_in[23:16];
                    memory[address+3] <= data_in[31:24];
                end
                default: 
                    memory[address] <= 'b0;
            endcase
            // memory[address] <= data_in;
            uart_tx_ready <= 'b0;
        end
    end else is_special <= 'b0;
end

// TODO: FINISH THIS, HOW DO I HANDLE 32/64 bits correctly in a parametrized way? (And do I even need to??)
assign data_out = (word_size=='h0) ? {{(XLEN-8){memory[address][7]}},memory[address]} :  // Load byte
                  (word_size=='h4) ? {{(XLEN-8){1'b0}},memory[address]} :  // Load byte (unsigned)
                  (word_size=='h1) ? {{((XLEN/2)){{memory[address+1][7]}}},memory[address+1],memory[address]} : // Load half
                  (word_size=='h5) ? {{(XLEN/2){1'b0}},memory[address+1],memory[address]} : // Load half (Unsigned)
                  // Not sure about this approach
                  (word_size=='h2) ? {memory[address+3],memory[address+2],memory[address+1],memory[address]} : 'b0;   // Load word

endmodule