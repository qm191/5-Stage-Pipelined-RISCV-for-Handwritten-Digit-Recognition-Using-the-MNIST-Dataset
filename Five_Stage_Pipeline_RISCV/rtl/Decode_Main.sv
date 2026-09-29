module Decode_Main(
    input  logic [6:0] op,
    output logic       RegWriteD,
    output logic [1:0] ResultSrcD,
    output logic       MemWriteD,
    output logic       JumpD,
    output logic       BranchD,
    output logic       JalrD,
    output logic [1:0] ALUOp,
    output logic       ALUSrcD
);
always @(*) begin
        RegWriteD  = 1'b0;
        ResultSrcD = 2'b00;
        MemWriteD  = 1'b0;
        JumpD      = 1'b0;
        BranchD    = 1'b0;
        ALUOp      = 2'b00;
        ALUSrcD    = 1'b0;
        JalrD      = 1'b0;

        case (op)
            // Load Word
            7'b0000011: begin
                ALUSrcD = 1'b1;
                ResultSrcD = 2'b01; 
                ALUOp = 2'b00;
                RegWriteD=1'b1;
            end
            // Store Word
            7'b0100011: begin
                ALUSrcD = 1'b1; 
                MemWriteD = 1'b1;
                ALUOp = 2'b00;
            end
            // R-type 
            7'b0110011: begin
                RegWriteD = 1'b1; ALUOp = 2'b10;
            end
            // I-Type ALU
            7'b0010011: begin
                RegWriteD = 1'b1;  ALUSrcD = 1'b1;
                ALUOp = 2'b10;
            end
            // Branch 
            7'b1100011: begin
                BranchD = 1'b1; ALUOp = 2'b01;
            end
            // JAL
            7'b1101111: begin
                RegWriteD = 1'b1; ResultSrcD = 2'b10;
                JumpD = 1'b1; ALUOp = 2'b11; 
            end
            // JALR 
            7'b1100111: begin
                RegWriteD = 1'b1; ALUSrcD = 1'b1;
                ResultSrcD = 2'b10; JumpD = 1'b1; JalrD = 1'b1;
                ALUOp = 2'b00; 
            end
            // LUI 
            7'b0110111: begin
                RegWriteD = 1'b1; ALUSrcD = 1'b1;
                ALUOp = 2'b11; 
            end
        endcase
    end
endmodule