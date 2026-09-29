module Decode_Extend(
    input  logic [31:0] InstrD,
    output logic [31:0] ImmExtD
);
    logic [6:0] opcode;
    assign opcode = InstrD[6:0];

    always @(*) begin
        case(opcode)
            // I-TYPE 
            7'b0010011, 7'b0000011, 7'b1100111: begin 
                ImmExtD = {{20{InstrD[31]}}, InstrD[31:20]};
            end

            // S-TYPE 
            7'b0100011: begin
                ImmExtD = {{20{InstrD[31]}}, InstrD[31:25], InstrD[11:7]};
            end

            // B-TYPE 
            7'b1100011: begin
                ImmExtD = {{20{InstrD[31]}}, InstrD[7], InstrD[30:25], InstrD[11:8], 1'b0};
            end

            // J-TYPE 
            7'b1101111: begin
                ImmExtD = {{12{InstrD[31]}}, InstrD[19:12], InstrD[20], InstrD[30:21], 1'b0};
            end
            // U-TYPE (LUI, AUIPC)
            7'b0110111, 7'b0010111: begin
                ImmExtD = {InstrD[31:12], 12'b0};
            end

            default: begin
                ImmExtD = 32'b0; 
            end
        endcase
    end
endmodule