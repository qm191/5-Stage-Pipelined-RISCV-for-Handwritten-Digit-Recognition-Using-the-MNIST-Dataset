module Memory_Cycle(
    input  logic        rstn,
    input  logic        clk,
    input  logic        RegWriteM,
    input  logic [1:0]  ResultSrcM,
    input  logic        MemWriteM,
    input  logic [31:0] ALUResultM,
    input  logic [31:0] WriteDataM,
    input  logic [4:0]  RdM,
    input  logic [31:0] PCPlus4M,
    output logic [31:0] ALUResultW,
    output logic [31:0] ReadDataW,
    output logic [31:0] PCPlus4W,
    output logic [4:0]  RdW,
    output logic        RegWriteW,
    output logic [1:0]  ResultSrcW
);

    Memory_Data u_Memory_Data(
        .rstn  (rstn),
        .clk   (clk),
        .A     (ALUResultM),
        .WE    (MemWriteM),
        .WD    (WriteDataM),
        .RD    (ReadDataW)
    );

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            RegWriteW   <= 1'b0;
            ResultSrcW  <= 2'b00;
            ALUResultW  <= 32'h0;
            RdW         <= 5'b00000;
            PCPlus4W    <= 32'h0;
        end
        else begin
            RegWriteW   <= RegWriteM;
            ResultSrcW  <= ResultSrcM;
            ALUResultW  <= ALUResultM;
            RdW         <= RdM;
            PCPlus4W    <= PCPlus4M;
        end
    end
endmodule