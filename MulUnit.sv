`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2026 01:10:39 PM
// Design Name: 
// Module Name: MulUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MulUnit(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [2:0] funct3,
    output reg [31:0] mul_result
    );
    logic [63:0] unsigned_product;
    logic signed [63:0] signed_product;
    logic signed [63:0] mixed_product;
    assign unsigned_product = A*B;
    assign signed_product = $signed(A)*$signed(B);
    assign mixed_product = $signed(A) * $signed({1'b0, B});
    always @(*) begin
        case (funct3)
            3'd0: mul_result = unsigned_product[31:0];//MUL
            3'd1: mul_result = signed_product[63:32];//MULH
            3'd2: mul_result = mixed_product[63:32];//MULSU
            3'd3: mul_result = unsigned_product[63:32];//MULU
            3'd4: mul_result = 32'hDEADBEEF;
            3'd5: mul_result = 32'hDEADBEEF;
            3'd6: mul_result = 32'hDEADBEEF;
            3'd7: mul_result = 32'hDEADBEEF;
            /*3'd4: mul_result = $signed(A)/$signed(B);//DIV
            3'd5: mul_result = A/B;//DIVU
            3'd6: mul_result = $signed(A)%$signed(B);//REM
            3'd7: mul_result = A%B;//REMU*/
            default: mul_result = 32'b0;
        endcase 
    end
endmodule
