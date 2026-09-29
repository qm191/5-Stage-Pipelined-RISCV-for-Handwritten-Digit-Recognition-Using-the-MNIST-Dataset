module Hazard_Unit(
    //Forwarding Solution
    input  logic [4:0] RdM,
    input  logic [4:0] RdW,
    input  logic [4:0] Rs1E,
    input  logic [4:0] Rs2E,
    input  logic       RegWriteM,
    input  logic       RegWriteW,
    //Stall Solution
    input  logic [4:0] RdE,
    input  logic [4:0] Rs1D,
    input  logic [4:0] Rs2D,
    input  logic       ResultSrcE0,
    //Branch
    input  logic       PCSrcE,
    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE,
    output logic       StallF,
    output logic       StallD,
    output logic       FlushD,
    output logic       FlushE
);
    //lwStall Detection
    logic lwStall;

    //Forwarding Solution
    always @(*) begin
        if( ((Rs1E == RdM) & RegWriteM ) & (Rs1E != 5'b00000))       ForwardAE = 2'b10;
        else if( ((Rs1E == RdW) & RegWriteW) & (Rs1E != 5'b00000))  ForwardAE = 2'b01;
        else                                                      ForwardAE = 2'b00;
    end

    always @(*) begin
        if( ((Rs2E == RdM) & RegWriteM) & (Rs2E != 5'b00000))       ForwardBE = 2'b10;
        else if( ((Rs2E == RdW) & RegWriteW) & (Rs2E != 5'b00000))  ForwardBE = 2'b01;
        else                                                      ForwardBE = 2'b00;
    end

    //Stall Solution
    assign lwStall = ResultSrcE0 & ((Rs1D == RdE) | (Rs2D == RdE));
    assign StallF  = lwStall;
    assign StallD  = lwStall;

    //Branch Solution
    assign FlushD  = PCSrcE;
    assign FlushE  = lwStall | PCSrcE;
endmodule