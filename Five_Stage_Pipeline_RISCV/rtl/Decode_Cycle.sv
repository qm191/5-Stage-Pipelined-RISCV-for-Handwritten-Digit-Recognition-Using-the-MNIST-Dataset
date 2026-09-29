module Decode_Cycle(
    input  logic        clk,
    input  logic        rstn,
    input  logic        FlushE,
    input  logic [31:0] InstrD,
    input  logic [31:0] PCD,
    input  logic [31:0] PCPlus4D,
    input  logic [31:0] ResultW,
    input  logic        RegWriteW,
    input  logic [4:0]  RdW,
    output logic        RegWriteE,
    output logic [1:0]  ResultSrcE,
    output logic        MemWriteE,
    output logic        JumpE,
    output logic        BranchE,
    output logic        JalrE,
    output logic [5:0]  ALUConE,
    output logic        ALUSrcE,
    output logic [31:0] PCE,
    output logic [31:0] RD1E,
    output logic [31:0] RD2E,
    output logic [4:0]  Rs1E,
    output logic [4:0]  Rs2E,
    output logic [4:0]  RdE,
    output logic [31:0] PCPlus4E,
    output logic [31:0] ImmExtE,
    output logic [2:0]  funct3E
);
//Interface of Controller
logic       RegWriteD;
logic [1:0] ResultSrcD;
logic       MemWriteD;
logic       JumpD;
logic       BranchD;
logic       JalrD;
logic [5:0] ALUConD;
logic       ALUSrcD;
//Interface of Register File
logic [31:0] RD1;
logic [31:0] RD2;
//Extend Block
logic [31:0] ImmExtD;

Decode_Controller u_Decode_Controller(
    .op         (InstrD[6:0]),
    .funct3     (InstrD[14:12]),
    .funct7     (InstrD[31:25]),
    .RegWriteD  (RegWriteD),
    .ResultSrcD (ResultSrcD),
    .MemWriteD  (MemWriteD),
    .JumpD      (JumpD),
    .BranchD    (BranchD),
    .JalrD      (JalrD),
    .ALUSrcD    (ALUSrcD),
    .ALUConD    (ALUConD)
);

Decode_Reg_File u_Decode_Reg_File(
    .clk   (clk),
    .rstn  (rstn),
    .A1    (InstrD[19:15]),
    .A2    (InstrD[24:20]),
    .A3    (RdW),
    .WE3   (RegWriteW),
    .WD3   (ResultW),
    .RD1   (RD1),
    .RD2   (RD2)
);

Decode_Extend u_Decode_Extend(
    .InstrD   (InstrD),
    .ImmExtD  (ImmExtD)
);

//Decode Register Block
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        RegWriteE  <= 1'b0;
        ResultSrcE <= 2'b00;
        MemWriteE  <= 1'b0;
        JumpE      <= 1'b0;
        BranchE    <= 1'b0;
        JalrE      <= 1'b0;
        ALUConE    <= 6'b000000;
        ALUSrcE    <= 1'b0;
        RD1E       <= 32'h0;
        RD2E       <= 32'h0;
        PCE        <= 32'h0;
        Rs1E       <= 5'b00000;
        Rs2E       <= 5'b00000;
        RdE        <= 5'b00000;
        ImmExtE    <= 32'h0;
        PCPlus4E   <= 32'h0;
        funct3E    <= 3'b000;
    end
    else begin
         if(FlushE) begin
             RegWriteE  <= 1'b0;
             ResultSrcE <= 2'b00;
             MemWriteE  <= 1'b0;
             JumpE      <= 1'b0;
             BranchE    <= 1'b0;
             JalrE      <= 1'b0;
             ALUConE    <= 6'b000000;
             ALUSrcE    <= 1'b0;
             RD1E       <= 32'h0;
             RD2E       <= 32'h0;
             PCE        <= 32'h0;
             Rs1E       <= 5'b00000;
             Rs2E       <= 5'b00000;
             RdE        <= 5'b00000;
             ImmExtE    <= 32'h0;
             PCPlus4E   <= 32'h0;
             funct3E    <= 3'b000;
         end
        else begin
            RegWriteE  <= RegWriteD;
            ResultSrcE <= ResultSrcD;
            MemWriteE  <= MemWriteD;
            JumpE      <= JumpD;
            BranchE    <= BranchD;
            JalrE      <= JalrD;
            ALUConE    <= ALUConD;
            ALUSrcE    <= ALUSrcD;
            RD1E       <= RD1;
            RD2E       <= RD2;
            PCE        <= PCD;
            Rs1E       <= InstrD[19:15];
            Rs2E       <= InstrD[24:20];
            RdE        <= InstrD[11:7];
            ImmExtE    <= ImmExtD;
            PCPlus4E   <= PCPlus4D;
            funct3E    <= InstrD[14:12];
        end
     end
end
endmodule