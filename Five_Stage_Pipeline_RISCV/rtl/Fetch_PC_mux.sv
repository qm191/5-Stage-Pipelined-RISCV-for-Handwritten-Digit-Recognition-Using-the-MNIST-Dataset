module Fetch_PC_mux(
    input  logic        PCSrcE,
    input  logic [31:0] PCPlus4F,
    input  logic [31:0] PCTargetE,
    output logic [31:0] PC_next
);
assign PC_next = (PCSrcE == 1'b1) ? PCTargetE : PCPlus4F;
endmodule