module Fetch_PC(
    input  logic        clk,
    input  logic        rstn,
    input  logic        StallF,
    input  logic [31:0] PC_next,
    output logic [31:0] PC_out
);
always_ff @(posedge clk or negedge rstn) begin 
    if(!rstn) 
        PC_out <= 32'h0;
    else begin
        if (StallF)  
            PC_out <= PC_out;
        else 
            PC_out <= PC_next;
    end
end
endmodule