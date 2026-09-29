module Decode_Controller(
    input  logic [6:0] op,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic       RegWriteD,
    output logic [1:0] ResultSrcD,
    output logic       MemWriteD,
    output logic       JumpD,
    output logic       BranchD,
    output logic [5:0] ALUConD, 
    output logic       ALUSrcD,
    output logic       JalrD    
);
    logic [1:0] ALUOp;

    Decode_Main u_Decode_Main( 
        .op         (op),
        .RegWriteD  (RegWriteD),
        .ResultSrcD (ResultSrcD),
        .MemWriteD  (MemWriteD),
        .JumpD      (JumpD),
        .BranchD    (BranchD),
        .ALUSrcD    (ALUSrcD),
        .JalrD      (JalrD),
        .ALUOp      (ALUOp)
    );

    Decode_ALU u_Decode_ALU(
        .opb5     (op[5]),   
        .ALUOp    (ALUOp),
        .funct3   (funct3),
        .funct7   (funct7),
        .ALUConD  (ALUConD)
    );
endmodule