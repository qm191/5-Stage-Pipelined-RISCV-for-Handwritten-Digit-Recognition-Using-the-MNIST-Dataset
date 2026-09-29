module Execute_Cycle(
    input  logic        clk,
    input  logic        rstn,
    input  logic [1:0]  ResultSrcE,
    input  logic        RegWriteE,
    input  logic        MemWriteE,
    input  logic        JumpE,
    input  logic        BranchE,
    input  logic        JalrE,
    input  logic        ALUSrcE,
    input  logic [5:0]  ALUConE,
    input  logic [31:0] RD1E,
    input  logic [31:0] RD2E,
    input  logic [31:0] PCE,
    input  logic [4:0]  RdE,
    input  logic [31:0] ImmExtE,
    input  logic [31:0] PCPlus4E,
    input  logic [1:0]  ForwardAE,
    input  logic [1:0]  ForwardBE,
    input  logic [31:0] ResultW,
    input  logic [2:0]  funct3E,
    output logic        PCSrcE,
    output logic [31:0] ALUResultM,
    output logic        RegWriteM,
    output logic        MemWriteM,
    output logic [1:0]  ResultSrcM,
    output logic [31:0] WriteDataM,
    output logic [4:0]  RdM,
    output logic [31:0] PCPlus4M,
    output logic [31:0] PCTargetE
);
    // Interface for ALU
    logic [31:0] ALUResultE;
    logic [31:0] SrcAE;
    logic [31:0] SrcBE;
    logic        ZeroE;
    logic [31:0] WriteDataE;
    logic        branch_taken;

    // Connect
    Execute_ALU u_Execute_ALU(
        .SrcA        (SrcAE),
        .SrcB        (SrcBE),
        .ALUConE     (ALUConE),
        .ALUResultE  (ALUResultE),
        .ZeroE       (ZeroE)
    );

    Execute_PC_adder u_Execute_PC_adder(
        .PCE         (PCE),
        .JalrE       (JalrE),
        .SrcAE       (SrcAE),
        .ImmExtE     (ImmExtE),
        .PCTargetE   (PCTargetE)
    );

    Execute_Branch_Unit u_Execute_Branch_Unit(
        .BranchE      (BranchE),
        .funct3       (funct3E),
        .SrcA         (SrcAE),
        .SrcB         (WriteDataE),
        .branch_taken (branch_taken)
    );

    assign SrcAE = (ForwardAE == 2'b00) ? RD1E :
                   (ForwardAE == 2'b01) ? ResultW :
                   (ForwardAE == 2'b10) ? ALUResultM :
                   32'hxxxx_xxxx;

    assign SrcBE = (ALUSrcE == 1'b0) ? WriteDataE : ImmExtE;

    always @(*) begin
        if(ForwardBE == 2'b00)       WriteDataE = RD2E;
        else if(ForwardBE == 2'b01)  WriteDataE = ResultW;
        else if(ForwardBE == 2'b10)  WriteDataE = ALUResultM;
        else                         WriteDataE = 32'hxxxx_xxxx;
    end

    assign PCSrcE = JumpE | branch_taken;

    // Execute Register Block
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            RegWriteM   <= 1'b0;
            ResultSrcM  <= 2'b00;
            MemWriteM   <= 1'b0;
            ALUResultM  <= 32'h0;
            WriteDataM  <= 32'h0;
            RdM         <= 5'b00000;
            PCPlus4M    <= 32'h0;
        end
        else begin
            RegWriteM   <= RegWriteE;
            ResultSrcM  <= ResultSrcE;
            MemWriteM   <= MemWriteE;
            ALUResultM  <= ALUResultE;
            WriteDataM  <= WriteDataE;
            RdM         <= RdE;
            PCPlus4M    <= PCPlus4E;
        end
    end
endmodule