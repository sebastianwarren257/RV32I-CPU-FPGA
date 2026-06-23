module dmem(
    input wire Clk,
    input wire [2:0]funct3,
    input wire [31:0] addr,
    input wire [31:0] wri_data,
    output reg [31:0] read_data,
    input wire Memread, Memwrite, 
    output reg [31:0] tohost,
    input reg [31:0] cycle_count
);
    reg [31:0] memory [16383:0];//not byte addressable 
    reg [31:0] read_buffer;
    reg[3:0] write_enable;
    //initial tohost = 32'b0;
    
    initial begin //intializes dmem with values from hex file
    $readmemh("C:/Users/Sebastian Warren/RISCV_CPU/fpga_test.dmem.hex", memory);
    end
    always_comb begin
        write_enable = 4'b0000;
        case (funct3)
            3'h0:begin //SB
                case(addr[1:0])
                    2'b00: write_enable = 4'b0001;
                    2'b01: write_enable = 4'b0010;
                    2'b10: write_enable = 4'b0100;
                    2'b11: write_enable = 4'b1000;
                endcase
            end
            3'h1:begin //SH
                case(addr[1:0])
                    2'b00: write_enable = 4'b0011;
                    2'b10: write_enable = 4'b1100;
                    default: write_enable = 4'b0000;
                endcase
            end
            3'h2:  begin //SW
                write_enable = 4'b1111;
            end
        endcase
        read_data = 32'b0;
        case (funct3)
                3'h0:begin //LB
                    case(addr[1:0])
                        2'b00: read_data = {{24{read_buffer[7]}}, read_buffer[7:0]};
                        2'b01: read_data = {{24{read_buffer[15]}}, read_buffer[15:8]};
                        2'b10: read_data = {{24{read_buffer[23]}}, read_buffer[23:16]};
                        2'b11: read_data = {{24{read_buffer[31]}}, read_buffer[31:24]};
                    endcase
                end
                3'h1:begin  //LH
                    case(addr[1:0])
                        2'b00: read_data = {{16{read_buffer[15]}}, read_buffer[15:0]};
                        2'b10: read_data = {{16{read_buffer[31]}}, read_buffer[31:16]};
                        default: read_data = 32'b0;
                    endcase
                end
                3'h2:begin //LW
                    read_data = read_buffer;
                end
                 3'h4: begin //LBU
                    case(addr[1:0])
                        2'b00: read_data = {{24'b0}, read_buffer[7:0]};
                        2'b01: read_data = {{24'b0}, read_buffer[15:8]};
                        2'b10: read_data = {{24'b0}, read_buffer[23:16]};
                        2'b11: read_data = {{24'b0}, read_buffer[31:24]};
                    endcase
                 end
                 3'h5:begin //LHU
                    case(addr[1:0])
                        2'b00: read_data = {{16'b0}, read_buffer[15:0]};
                        2'b10: read_data = {{16'b0}, read_buffer[31:16]};
                        default: read_data = 32'b0;
                    endcase
                 end
            endcase
    end
    always_ff @(posedge Clk) begin
        if(Memwrite) begin
            if(addr == 32'h80001000) begin
                tohost <= wri_data;
            end else begin
                if(write_enable[0]) memory[addr[15:2]][7:0] <= wri_data[7:0];
                if(write_enable[1]) memory[addr[15:2]][15:8] <= wri_data[15:8];
                if(write_enable[2]) memory[addr[15:2]][23:16] <= wri_data[23:16];
                if(write_enable[3]) memory[addr[15:2]][31:24] <= wri_data[31:24];
            end
        end
     end

    always_ff @(posedge Clk) begin 
        if(Memread) begin
            if(addr == 32'h80001004) begin
                read_buffer <= cycle_count;
            end else begin
                read_buffer <= memory[addr[15:2]];
            end
        end
    end

endmodule