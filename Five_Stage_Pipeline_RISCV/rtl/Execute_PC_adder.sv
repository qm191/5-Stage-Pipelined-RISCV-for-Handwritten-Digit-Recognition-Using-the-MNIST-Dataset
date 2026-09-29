module Execute_PC_adder(
    input  logic [31:0] PCE,
    input  logic [31:0] SrcAE,
    input  logic        JalrE,
    input  logic [31:0] ImmExtE,
    output logic [31:0] PCTargetE
);
    assign PCTargetE = (JalrE == 1'b1) ? ((SrcAE + ImmExtE) & 32'hFFFF_FFFE) : (PCE + ImmExtE);
endmodule