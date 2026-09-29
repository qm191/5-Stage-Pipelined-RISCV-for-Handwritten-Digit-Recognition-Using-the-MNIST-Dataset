module Write_Back_Cycle(
    input  logic [1:0]  ResultSrcW,
    input  logic [31:0] ALUResultW,
    input  logic [31:0] ReadDataW,
    input  logic [31:0] PCPlus4W,
    output logic [31:0] ResultW
);
    assign ResultW = (ResultSrcW == 2'b00) ? ALUResultW :
                     (ResultSrcW == 2'b01) ? ReadDataW :
                     (ResultSrcW == 2'b10) ? PCPlus4W :
                     32'hxxxx_xxxx;
endmodule