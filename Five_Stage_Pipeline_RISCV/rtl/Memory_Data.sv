module Memory_Data(
    input  logic        rstn,  
    input  logic        clk,      
    input  logic [31:0] A,      
    input  logic        WE,     
    input  logic [31:0] WD,      
    output logic [31:0] RD     
);

   
    logic [31:0] mem [0:16383];

    logic [13:0] word_index;
    assign word_index = A[15:2];

    integer idx;

    initial begin
        for (idx = 0; idx < 16384; idx = idx + 1) begin
            mem[idx] = 32'h0; 
        end
        //$readmemh("mnist_image.mem", mem, 256, 1039);
    end

    always @(posedge clk) begin
        if (WE) begin
            mem[word_index] <= WD;
        end
    end
    assign RD = (!rstn) ? 32'h0 : mem[word_index];

endmodule