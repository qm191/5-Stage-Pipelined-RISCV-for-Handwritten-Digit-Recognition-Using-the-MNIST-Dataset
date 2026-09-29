module Decode_Reg_File (
    input  logic        clk,
    input  logic        rstn,
    input  logic [4:0]  A1,
    input  logic [4:0]  A2,
    input  logic [4:0]  A3,
    input  logic [31:0] WD3,
    input  logic        WE3,
    output logic [31:0] RD1,
    output logic [31:0] RD2
);
    logic [31:0] store_reg [31:0];
    integer i;

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (i = 0; i < 32; i = i + 1) begin
                store_reg[i] <= 32'b0;
            end
        end 
        else if (WE3 && (A3 != 5'h0)) begin
            store_reg[A3] <= WD3;
        end
    end
//Resolution for Load_then_add_test
    assign RD1 = (!rstn || A1 == 5'h0) ? 32'h0 :
                 ((A1 == A3) && WE3)    ? WD3   : store_reg[A1];

    assign RD2 = (!rstn || A2 == 5'h0) ? 32'h0 :
                 ((A2 == A3) && WE3)    ? WD3   : store_reg[A2];

endmodule