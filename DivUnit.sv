`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2026 05:47:34 PM
// Design Name: 
// Module Name: DivUnit
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


module DivUnit(
    input wire Clk,
    input wire reset,
    input wire start,           // pulse high for 1 cycle when DIV instruction enters EX
    input wire [31:0] dividend, // rs1
    input wire [31:0] divisor,  // rs2
    input wire is_signed,       // 1 for DIV/REM, 0 for DIVU/REMU
    output reg [31:0] quotient,
    output reg [31:0] remainder,
    output reg div_busy,        // high while running
    output reg div_done
    );
    
    localparam IDLE    = 2'b00;
    localparam RUNNING = 2'b01;
    localparam DONE    = 2'b10;
    
    reg [1:0] state;
    reg [5:0] count; //iteration coutner
    reg [31:0] abs_dividend; //absolute dividen value
    reg [31:0] abs_divisor; //absolute divisor value
    reg sign_q; //sign of quotient
    reg sign_r; //sign of remainder
    reg [31:0] quotient_reg; //quotient
    reg [32:0] partial_rem; //partial remainder
    wire [32:0] trial = {partial_rem[31:0], abs_dividend[31-count]} - {1'b0, abs_divisor};
    always_ff @(posedge Clk) begin
        if(reset) begin
            state <= IDLE;
            count <= 6'd0;
            abs_dividend <= 32'd0;
            abs_divisor <= 32'd0;
            sign_q <= 1'b0;
            sign_r <= 1'b0;
            quotient_reg <= 32'd0;
            partial_rem <= 33'd0;
            div_busy <= 1'b0;
            div_done <= 1'b0;
        end
        else begin
            case(state)
                IDLE: begin
                    if(start)begin
                        state <= RUNNING;
                        count <= 6'd0;
                        partial_rem <=33'd0;
                        quotient_reg <=32'd0;
                        div_busy <= 1'b1;
                        if(is_signed) begin
                            if(dividend[31]==1)begin
                                abs_dividend <= -dividend;
                            end
                            else begin
                                abs_dividend <= dividend;
                            end
                            if(divisor[31]==1)begin
                                abs_divisor <= -divisor;
                            end
                            else begin
                                abs_divisor <= divisor;
                            end
                            sign_q <= dividend[31] ^ divisor[31];
                            sign_r <= dividend[31];
                        end else begin
                            abs_dividend <= dividend;
                            abs_divisor <= divisor;
                            sign_q <= 1'b0;
                            sign_r <= 1'b0;
                        end
                    end
                end
                RUNNING:begin
                    if(trial[32]) begin
                        partial_rem <= {partial_rem[31:0], abs_dividend[31-count]};
                        quotient_reg <= {quotient_reg[30:0], 1'b0};
                    end else begin
                        partial_rem <= trial;
                        quotient_reg <= {quotient_reg[30:0], 1'b1};
                    end
                    count <= count+1;
                    if(count==6'd31) begin
                        state <= DONE;
                        div_busy <= 1'b0;
                        div_done <= 1'b1;
                    end
                end
                DONE:begin
                    quotient <= sign_q ? -quotient_reg : quotient_reg;
                    remainder <= sign_r ? -partial_rem[31:0] : partial_rem[31:0];
                    state <= IDLE;
                    div_done <= 1'b0;
                end
            endcase
        end
    end
endmodule
