module Fetch_Cycle(
    input  logic        StallF,
    input  logic        StallD,
    input  logic        FlushD,
    input  logic        clk,
    input  logic        rstn,
    input  logic        PCSrcE,
    input  logic [31:0] PCTargetE,
    output logic [31:0] InstrD,
    output logic [31:0] PCD,
    output logic [31:0] PCPlus4D
);
logic [31:0] RD;
logic [31:0] PCPlus4F;
logic [31:0] PC_out;
logic [31:0] PC_next;

//PC
Fetch_PC u_Fetch_PC(
    .clk     (clk), 
    .rstn    (rstn),
    .StallF  (StallF), 
    .PC_next (PC_next), 
    .PC_out  (PC_out)
);

//PC Adder
Fetch_PC_adder u_Fetch_PC_adder(
    .PC_out    (PC_out), 
    .PCPlus4F  (PCPlus4F)
);

//PC Mux
Fetch_PC_mux u_Fetch_PC_mux(
    .PCSrcE     (PCSrcE), 
    .PCTargetE  (PCTargetE),
    .PCPlus4F   (PCPlus4F),
    .PC_next    (PC_next)
);

//Instruction Memory
Fetch_Instr_Mem u_Fetch_Instr_Mem(         
    .A   (PC_out),
    .RD  (RD)
);

//Pipeline Register
always_ff @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        InstrD   <= 32'h0;
        PCD      <= 32'h0;
        PCPlus4D <= 32'h0;
    end
    else begin
        if(FlushD) begin
            InstrD   <= 32'h0;
            PCD      <= 32'h0;
            PCPlus4D <= 32'h0;
        end
        else begin
            if(StallD) begin
                InstrD   <= InstrD;
                PCD      <= PCD;
                PCPlus4D <= PCPlus4D;
            end
            else begin 
                InstrD   <= RD;
                PCD      <= PC_out;
                PCPlus4D <= PCPlus4F;
            end
        end
    end
end
endmodule