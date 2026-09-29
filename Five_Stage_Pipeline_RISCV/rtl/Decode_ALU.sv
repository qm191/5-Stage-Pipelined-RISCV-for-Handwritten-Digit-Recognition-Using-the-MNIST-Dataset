module Decode_ALU(
    input  logic       opb5,  
    input  logic [1:0] ALUOp,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7, 
    output logic [5:0] ALUConD 
);
    localparam ALU_ADD    = 6'b000001;
    localparam ALU_SUB    = 6'b000010;
    localparam ALU_AND    = 6'b001010;
    localparam ALU_OR     = 6'b001001;
    localparam ALU_XOR    = 6'b000110;
    localparam ALU_SLL    = 6'b000011;
    localparam ALU_SRL    = 6'b000111;
    localparam ALU_SRA    = 6'b001000;
    localparam ALU_SLT    = 6'b000100;
    localparam ALU_SLTU   = 6'b000101;
    localparam ALU_COPY_B = 6'b010000;
    localparam ALU_MUL    = 6'b010001;
    localparam ALU_MULH   = 6'b010010;
    localparam ALU_MULHSU = 6'b010011;
    localparam ALU_MULHU  = 6'b010100;
    localparam ALU_NOP    = 6'b000000;

    always @(*) begin
        case(ALUOp)
            2'b00: ALUConD = ALU_ADD; 
            2'b01: ALUConD = ALU_SUB; 
            
            2'b10: begin // R-type hoặc I-type
                if (opb5 == 1'b1 && funct7 == 7'b0000001) begin
                   
                    case(funct3)
                        3'b000: ALUConD = ALU_MUL;
                        3'b001: ALUConD = ALU_MULH;
                        3'b010: ALUConD = ALU_MULHSU;
                        3'b011: ALUConD = ALU_MULHU;
                        default: ALUConD = ALU_NOP;
                    endcase
                end else begin
                   
                    case(funct3)
                        3'b000: begin
                           
                            if ({opb5, funct7[5]} == 2'b11) ALUConD = ALU_SUB;
                            else                            ALUConD = ALU_ADD;
                        end
                        3'b001: ALUConD = (funct7 == 7'h00) ? ALU_SLL : ALU_NOP;
                        3'b010: ALUConD = ALU_SLT; 
                        3'b011: ALUConD = ALU_SLTU;
                        3'b100: ALUConD = ALU_XOR;
                        3'b101: begin
                            if      (funct7 == 7'h00) ALUConD = ALU_SRL;
                            else if (funct7 == 7'h20) ALUConD = ALU_SRA;
                            else                      ALUConD = ALU_NOP;
                        end
                        3'b110: ALUConD = ALU_OR;
                        3'b111: ALUConD = ALU_AND;
                        default: ALUConD = ALU_NOP;
                    endcase
                end
            end
            
            2'b11: begin 
                ALUConD = ALU_COPY_B; 
            end
            default: ALUConD = ALU_NOP;
        endcase
    end
endmodule