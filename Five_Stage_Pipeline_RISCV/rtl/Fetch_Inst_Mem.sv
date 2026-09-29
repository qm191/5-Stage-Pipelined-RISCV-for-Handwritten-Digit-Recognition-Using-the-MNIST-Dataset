module Fetch_Instr_Mem(
    input  logic [31:0] A,
    output logic [31:0] RD
);
    logic [31:0] mem [1023:0];
    int i;
    
    assign RD = mem[A[31:2]];

    initial begin
       for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 32'h00000000;   // fill with NOPs
        end
        //$readmemh("program.mem", mem); 
    end
endmodule