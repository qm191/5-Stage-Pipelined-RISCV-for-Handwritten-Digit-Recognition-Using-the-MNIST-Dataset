module Top(
    input logic clk,
    input logic rstn
);

    logic StallF;
    logic StallD;
    logic FlushD;
    logic FlushE;
    logic [1:0] ForwardAE;
    logic [1:0] ForwardBE;

    // --- Fetch Stage ---
    logic [31:0] InstrD;
    logic [31:0] PCD;
    logic [31:0] PCPlus4D;

    // --- Decode Stage ---
    logic RegWriteE;
    logic [1:0] ResultSrcE;
    logic MemWriteE;
    logic JumpE;
    logic BranchE;
    logic JalrE;
    logic [5:0] ALUConE;
    logic ALUSrcE;
    logic [31:0] PCE;
    logic [31:0] RD1E;
    logic [31:0] RD2E;
    logic [4:0] Rs1E;
    logic [4:0] Rs2E;
    logic [4:0] RdE;
    logic [31:0] ImmExtE;
    logic [31:0] PCPlus4E;
    logic [4:0] RdW;

    // --- Execute Stage ---
    logic PCSrcE;
    logic [31:0] ALUResultM;
    logic RegWriteM;
    logic MemWriteM;
    logic [1:0] ResultSrcM;
    logic [31:0] WriteDataM;
    logic [4:0] RdM;
    logic [31:0] PCPlus4M;
    logic [31:0] PCTargetE;
    logic [2:0] funct3E;

    // --- Memory Stage ---
    logic [31:0] ALUResultW;
    logic [31:0] ReadDataW;
    logic [31:0] PCPlus4W;
    logic RegWriteW;
    logic [1:0] ResultSrcW;

    // --- WriteBack Stage ---
    logic [31:0] ResultW;

    
    logic [4:0] Rs1D;
    logic [4:0] Rs2D;
    logic       ResultSrcE0;

   
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
   
    assign ResultSrcE0 = ResultSrcE[0];


    Fetch_Cycle u_Fetch_Cycle(
        .StallF     (StallF),
        .StallD     (StallD),
        .FlushD     (FlushD),
        .clk        (clk),
        .rstn       (rstn),
        .PCSrcE     (PCSrcE),
        .PCTargetE  (PCTargetE),
        .InstrD     (InstrD),
        .PCD        (PCD),
        .PCPlus4D   (PCPlus4D)
    );

    
    Decode_Cycle u_Decode_Cycle(
        .clk        (clk),
        .rstn       (rstn),
        .FlushE     (FlushE),
        .InstrD     (InstrD),
        .PCD        (PCD),
        .PCPlus4D   (PCPlus4D),
        .ResultW    (ResultW),
        .RegWriteW  (RegWriteW),
        .RegWriteE  (RegWriteE),
        .ResultSrcE (ResultSrcE),
        .MemWriteE  (MemWriteE),
        .JumpE      (JumpE),
        .BranchE    (BranchE),
        .JalrE      (JalrE),
        .ALUConE    (ALUConE),
        .ALUSrcE    (ALUSrcE),
        .PCE        (PCE),
        .RD1E       (RD1E),
        .RD2E       (RD2E),
        .Rs1E       (Rs1E),
        .Rs2E       (Rs2E),
        .RdE        (RdE),
        .ImmExtE    (ImmExtE),
        .PCPlus4E   (PCPlus4E),
        .RdW        (RdW),
        .funct3E    (funct3E)
    );

    
    Execute_Cycle u_Execute_Cycle(
        .clk        (clk),
        .rstn       (rstn),
        .funct3E    (funct3E),
        .ResultSrcE (ResultSrcE),
        .RegWriteE  (RegWriteE),
        .MemWriteE  (MemWriteE),
        .JumpE      (JumpE),
        .BranchE    (BranchE),
        .JalrE      (JalrE),
        .ALUSrcE    (ALUSrcE),
        .ALUConE    (ALUConE),
        .RD1E       (RD1E),
        .RD2E       (RD2E),
        .PCE        (PCE),
        .RdE        (RdE),
        .ImmExtE    (ImmExtE),
        .PCPlus4E   (PCPlus4E),
        .ForwardAE  (ForwardAE),
        .ForwardBE  (ForwardBE),
        .ResultW    (ResultW),
        .PCSrcE     (PCSrcE),
        .ALUResultM (ALUResultM),
        .RegWriteM  (RegWriteM),
        .MemWriteM  (MemWriteM),
        .ResultSrcM (ResultSrcM),
        .WriteDataM (WriteDataM),
        .RdM        (RdM),
        .PCPlus4M   (PCPlus4M),
        .PCTargetE  (PCTargetE)
    );

    
    Memory_Cycle u_Memory_Cycle(
        .rstn       (rstn),
        .clk        (clk),
        .RegWriteM  (RegWriteM),
        .ResultSrcM (ResultSrcM),
        .MemWriteM  (MemWriteM),
        .ALUResultM (ALUResultM),
        .WriteDataM (WriteDataM),
        .RdM        (RdM),
        .PCPlus4M   (PCPlus4M),
        .ALUResultW (ALUResultW),
        .ReadDataW  (ReadDataW),
        .PCPlus4W   (PCPlus4W),
        .RdW        (RdW),
        .RegWriteW  (RegWriteW),
        .ResultSrcW (ResultSrcW)
    );

    Write_Back_Cycle u_Write_Back_Cycle(
        .ResultSrcW (ResultSrcW),
        .ALUResultW (ALUResultW),
        .ReadDataW  (ReadDataW),
        .PCPlus4W   (PCPlus4W),
        .ResultW    (ResultW)
    );

    Hazard_Unit u_Hazard_Unit(
        .RdM        (RdM),
        .RdW        (RdW),
        .Rs1E       (Rs1E),
        .Rs2E       (Rs2E),
        .RegWriteM  (RegWriteM),
        .RegWriteW  (RegWriteW),
        .RdE        (RdE),
        .Rs1D       (Rs1D),
        .Rs2D       (Rs2D),
        .ResultSrcE0(ResultSrcE0),
        .PCSrcE     (PCSrcE),
        .ForwardAE  (ForwardAE),
        .ForwardBE  (ForwardBE),
        .StallF     (StallF),
        .StallD     (StallD),
        .FlushD     (FlushD),
        .FlushE     (FlushE)
    );

endmodule