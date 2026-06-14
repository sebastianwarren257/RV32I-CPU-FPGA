module imem(
    input wire [31:0] PC,
    output reg [31:0] instruction,
    input wire Clk
);
    reg [31:0] imem [16383:0];
    wire [13:0] bram_addr = (PC - 32'h80000000) >> 2; // combinational translation
    
    initial begin
        $readmemh("C:/Users/Sebastian Warren/RISCV_CPU/load_store_test.hex",imem); //load instructions into memory
    end
    
    always_ff @(posedge Clk) begin
        instruction <= imem[bram_addr];
    end

endmodule