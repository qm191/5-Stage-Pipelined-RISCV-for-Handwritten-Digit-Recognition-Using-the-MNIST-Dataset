interface riscv_if(input logic clk);
    logic rst_n;
    logic [31:0] data_mem [0:1023];
    task automatic load_hex(string instr_file, string data_file);
        $readmemh(instr_file, testbench.u_cpu.u_Fetch_Cycle.u_Fetch_Instr_Mem.mem);
        $readmemh(data_file,  testbench.u_cpu.u_Memory_Cycle.u_Memory_Data.mem);
    endtask
//SYSTEMVERILOG ASSERTION
`ifndef SYNTHESIS
//=====================FETCH CYCLE=======================

//SVA1: Reset state of Fetch
property Fetch_Stage_Reset;
    @(posedge clk) $rose(rst_n) |-> (testbench.u_cpu.u_Fetch_Cycle.u_Fetch_PC.PC_out == 32'h0) &&
                             (testbench.u_cpu.u_Fetch_Cycle.InstrD == 32'h0) &&
                             (testbench.u_cpu.u_Fetch_Cycle.PCD == 32'h0) &&
                             (testbench.u_cpu.u_Fetch_Cycle.PCPlus4D == 32'h0);
endproperty

check_Fetch_Stage_Reset: assert property(Fetch_Stage_Reset)
    else $error("[SVA] ERROR @%0t: Reset state failure in Fetch Stage", $time);

//SVA2: PC Counter: PC Stop counting while occurs Stall state at Fetch Cycle
property Fetch_PC_Stall;
    @(posedge clk) (testbench.u_cpu.u_Fetch_Cycle.StallF) 
    |=> $stable(testbench.u_cpu.u_Fetch_Cycle.u_Fetch_PC.PC_out);
endproperty
check_Fetch_PC_Stall: assert property(Fetch_PC_Stall)
    else $error("[SVA] ERROR @%0t: PC counter still counts while occurs Stall state at Fetch Cycle",$time);
//=======================================================

//SVA3: PC Counter: PC_out matchs update address in two different cases: Branch/Jump or Linear
property Fetch_PC_Update;
    logic [31:0] expected_pc;
    @(posedge clk)disable iff (!rst_n) 
                    (!testbench.u_cpu.u_Fetch_Cycle.StallF && $past(rst_n),
                    expected_pc= testbench.u_cpu.u_Fetch_Cycle.PCSrcE ? 
                                 testbench.u_cpu.u_Fetch_Cycle.PCTargetE:
                                 testbench.u_cpu.u_Fetch_Cycle.u_Fetch_PC_mux.PCPlus4F)
    |=> (testbench.u_cpu.u_Fetch_Cycle.u_Fetch_PC.PC_out==expected_pc);
endproperty
check_Fetch_PC_Update: assert property(Fetch_PC_Update)
    else $error("[SVA] ERROR @%0t: PC counter mismatches expected addess",$time);
//=======================================================

//SVA4: FlushD logic
property FlushD_affection;
    @(posedge clk)disable iff (!rst_n) 
    (testbench.u_cpu.u_Fetch_Cycle.FlushD)
    |=> (testbench.u_cpu.u_Fetch_Cycle.InstrD == '0) &&
        (testbench.u_cpu.u_Fetch_Cycle.PCD =='0) &&
        (testbench.u_cpu.u_Fetch_Cycle.PCPlus4D=='0);
endproperty 
check_FlushD_affection: assert property(FlushD_affection)
    else $error("[SVA] ERROR @%0t: FlushD not effect the Pipeline Register IF/ID",$time);
//=======================================================

//=====================DECODE CYCLE=======================
// SVA5: Reset state of Decode Stage
property Decode_Stage_Reset;
    @(posedge clk) $rose(rst_n) |-> (testbench.u_cpu.u_Decode_Cycle.RegWriteE == 1'b0) &&
                                    (testbench.u_cpu.u_Decode_Cycle.MemWriteE == 1'b0) &&
                                    (testbench.u_cpu.u_Decode_Cycle.JumpE == 1'b0) &&
                                    (testbench.u_cpu.u_Decode_Cycle.BranchE == 1'b0) &&
                                    (testbench.u_cpu.u_Decode_Cycle.JalrE == 1'b0) &&
                                    (testbench.u_cpu.u_Decode_Cycle.ALUConE == 6'b000000) &&
                                    (testbench.u_cpu.u_Decode_Cycle.PCE == 32'h0);
endproperty

check_Decode_Stage_Reset: assert property(Decode_Stage_Reset)
    else $error("[SVA] ERROR @%0t: Reset state failure in Decode Stage", $time);
//=======================================================

// SVA6: RegFile Zero Register
property RegFile_Zero_Register;
    @(posedge clk) disable iff (!rst_n)
    (1'b1) |-> (testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.A1 == 5'd0 -> testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.RD1 == 32'h0) &&
               (testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.A2 == 5'd0 -> testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.RD2 == 32'h0);
endproperty

check_RegFile_Zero_Register: assert property(RegFile_Zero_Register)
    else $error("[SVA] ERROR @%0t: Register x0 returned non-zero value!", $time);
//=======================================================

// SVA7: RegFile Read-During-Write Internal Bypassing for RD1
property RegFile_Bypass_RD1;
    @(posedge clk) disable iff (!rst_n)
    (testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.WE3 && 
     (testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.A1 == testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.A3) && 
     (testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.A1 != 5'd0))
    |-> (testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.RD1 == testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.WD3);
endproperty

check_RegFile_Bypass_RD1: assert property(RegFile_Bypass_RD1)
    else $error("[SVA] ERROR @%0t: RegFile Internal Bypass failed on RD1", $time);

// SVA8: RegFile Read-During-Write Internal Bypassing for RD2
property RegFile_Bypass_RD2;
    @(posedge clk) disable iff (!rst_n)
    (testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.WE3 && 
     (testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.A2 == testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.A3) && 
     (testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.A2 != 5'd0))
    |-> (testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.RD2 == testbench.u_cpu.u_Decode_Cycle.u_Decode_Reg_File.WD3);
endproperty

check_RegFile_Bypass_RD2: assert property(RegFile_Bypass_RD2)
    else $error("[SVA] ERROR @%0t: RegFile Internal Bypass failed on RD2", $time);
//=======================================================

// SVA9: FlushE affection on ID/EX Pipeline Register
property FlushE_affection;
    @(posedge clk) disable iff (!rst_n)
    (testbench.u_cpu.u_Decode_Cycle.FlushE)
    |=> (testbench.u_cpu.u_Decode_Cycle.RegWriteE== 1'b0) &&
        (testbench.u_cpu.u_Decode_Cycle.MemWriteE == 1'b0) &&
        (testbench.u_cpu.u_Decode_Cycle.JumpE == 1'b0) &&
        (testbench.u_cpu.u_Decode_Cycle.BranchE == 1'b0) &&
        (testbench.u_cpu.u_Decode_Cycle.JalrE  == 1'b0) &&
        (testbench.u_cpu.u_Decode_Cycle.ALUConE == 6'b000000);
endproperty

check_FlushE_affection: assert property(FlushE_affection)
    else $error("[SVA] ERROR @%0t: FlushE did not clear ID/EX Pipeline Register", $time);
//=======================================================

// SVA10: Branch & Jump Immediate Alignment
property Imm_Branch_Jump_Alignment;
    @(posedge clk) disable iff (!rst_n)
    (testbench.u_cpu.u_Decode_Cycle.InstrD[6:0] == 7'b1100011 || 
     testbench.u_cpu.u_Decode_Cycle.InstrD[6:0] == 7'b1101111)
    |-> (testbench.u_cpu.u_Decode_Cycle.u_Decode_Extend.ImmExtD[0] == 1'b0);
endproperty

check_Imm_Branch_Jump_Alignment: assert property(Imm_Branch_Jump_Alignment)
    else $error("[SVA] ERROR @%0t: Branch/Jump Immediate LSB is not 0 (Misaligned)", $time);
//=======================================================

// SVA11: Normal Propagation from Decode to Execute Stage
property Decode_Pipeline_Propagation;
    @(posedge clk) disable iff (!rst_n)
    (!testbench.u_cpu.u_Decode_Cycle.FlushE && $past(rst_n))
    |=> (testbench.u_cpu.u_Decode_Cycle.RegWriteE == $past(testbench.u_cpu.u_Decode_Cycle.RegWriteD)) &&
        (testbench.u_cpu.u_Decode_Cycle.MemWriteE == $past(testbench.u_cpu.u_Decode_Cycle.MemWriteD)) &&
        (testbench.u_cpu.u_Decode_Cycle.PCE  == $past(testbench.u_cpu.u_Decode_Cycle.PCD)) &&
        (testbench.u_cpu.u_Decode_Cycle.Rs1E == $past(testbench.u_cpu.u_Decode_Cycle.InstrD[19:15])) &&
        (testbench.u_cpu.u_Decode_Cycle.Rs2E == $past(testbench.u_cpu.u_Decode_Cycle.InstrD[24:20])) &&
        (testbench.u_cpu.u_Decode_Cycle.RdE  == $past(testbench.u_cpu.u_Decode_Cycle.InstrD[11:7]));
endproperty

check_Decode_Pipeline_Propagation: assert property(Decode_Pipeline_Propagation)
    else $error("[SVA] ERROR @%0t: ID/EX Pipeline Register failed to propagate data correctly", $time);
//=======================================================
`endif
endinterface