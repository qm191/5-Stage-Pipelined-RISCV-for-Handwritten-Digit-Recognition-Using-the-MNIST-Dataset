module Fetch_PC_adder(
    input  logic [31:0] PC_out,
    output logic [31:0] PCPlus4F
);
assign PCPlus4F = PC_out + 32'h4;
endmodule