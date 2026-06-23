module IFID(
    input Clk,
    input reset,
    input IFID_flush,
    input [31:0] instruction1,
    input [31:0] pc1,
    input [31:0] pc1Plus4,
    output reg [31:0] instruction2,
    output reg [31:0] pc2,
    output reg [31:0] pc2Plus4,
    input stall,
    input div_stall,
    input MEM_Memread
);
    always_ff @(posedge Clk) begin
        if(reset || IFID_flush) begin
            instruction2 <= 32'b0;
            pc2 <= 32'b0;
            pc2Plus4 <= 32'b0;
        end
        else if(stall || div_stall || MEM_Memread)begin //holds values for stall
            instruction2<=instruction2;
            pc2<=pc2;
            pc2Plus4<=pc2Plus4;
        end
        else begin
            instruction2 <= instruction1;
            pc2 <= pc1;
            pc2Plus4 <= pc1Plus4;
        end
    end
endmodule