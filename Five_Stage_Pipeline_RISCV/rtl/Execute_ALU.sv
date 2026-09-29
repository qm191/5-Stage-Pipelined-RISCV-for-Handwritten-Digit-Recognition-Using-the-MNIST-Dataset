module Execute_ALU(       
    input  logic [31:0] SrcA,
    input  logic [31:0] SrcB,
    input  logic [5:0]  ALUConE,
    output logic [31:0] ALUResultE,
    output logic        ZeroE
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
    // ---- M-extension multiply group ----
    localparam ALU_MUL    = 6'b010001; // lower 32 bits of A*B
    localparam ALU_MULH   = 6'b010010; // upper 32 bits, signed   x signed
    localparam ALU_MULHSU = 6'b010011; // upper 32 bits, signed   x unsigned
    localparam ALU_MULHU  = 6'b010100; // upper 32 bits, unsigned x unsigned
    // Error Code (NOP)
    localparam ALU_NOP    = 6'b000000;

    // Internal signals
    logic signed [31:0] signed_a;
    // 64-bit products for the multiply group
    logic signed [63:0] p_ss = $signed(SrcA) * $signed(SrcB);             // signed*signed
    logic signed [63:0] p_su = $signed(SrcA) * $signed({1'b0, SrcB});      // signed*unsigned
    logic        [63:0] p_uu = SrcA * SrcB;

    always @(*) begin
        ALUResultE = 32'h0; // Default
        signed_a   = $signed(SrcA);
        
        case(ALUConE)
            // Arithmetic
            ALU_ADD: ALUResultE = SrcA + SrcB;
            ALU_SUB: ALUResultE = SrcA - SrcB;

            // Logic
            ALU_AND: ALUResultE = SrcA & SrcB;
            ALU_OR:  ALUResultE = SrcA | SrcB;
            ALU_XOR: ALUResultE = SrcA ^ SrcB;

            // Shifts (Using bottom 5 bits of B)
            ALU_SLL: ALUResultE = SrcA << SrcB[4:0];
            ALU_SRL: ALUResultE = SrcA >> SrcB[4:0];
            ALU_SRA: ALUResultE = signed_a >>> SrcB[4:0];

            // Comparisons
            ALU_SLT:  ALUResultE = (signed_a < $signed(SrcB)) ? 32'd1 : 32'd0;
            ALU_SLTU: ALUResultE = (SrcA < SrcB)              ? 32'd1 : 32'd0;

            // LUI Support
            ALU_COPY_B: ALUResultE = SrcB;

            // Multiply group
            ALU_MUL:    ALUResultE = p_ss[31:0];
            ALU_MULH:   ALUResultE = p_ss[63:32];
            ALU_MULHSU: ALUResultE = p_su[63:32];
            ALU_MULHU:  ALUResultE = p_uu[63:32];

            default: ALUResultE = 32'b0;
        endcase
    end

    assign ZeroE = (ALUResultE == 32'h0) ? 1'b1 : 1'b0;
endmodule