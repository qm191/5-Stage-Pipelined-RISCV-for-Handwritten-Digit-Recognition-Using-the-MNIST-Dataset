module Execute_Branch_Unit(
    input  logic        BranchE,    // From Control Unit
    input  logic [2:0]  funct3,     // BEQ/BNE/BLT/BGE/BLTU/BGEU selector
    input  logic [31:0] SrcA,       // rs1 value (forwarded)  -> = src_AE
    input  logic [31:0] SrcB,       // rs2 value (forwarded)  -> = write_dataE
    output logic        branch_taken
);

    logic eq  = (SrcA == SrcB);
    logic lt  = ($signed(SrcA) <  $signed(SrcB)); // signed   less-than
    logic ltu = (SrcA < SrcB);                    // unsigned less-than

    always @(*) begin
        branch_taken = 1'b0;
        if (BranchE) begin
            case(funct3)
                3'b000: branch_taken =  eq;   // BEQ
                3'b001: branch_taken = ~eq;   // BNE
                3'b100: branch_taken =  lt;   // BLT
                3'b101: branch_taken = ~lt;   // BGE
                3'b110: branch_taken =  ltu;  // BLTU
                3'b111: branch_taken = ~ltu;  // BGEU
                default: branch_taken = 1'b0;
            endcase
        end
    end
endmodule