`timescale 1ns/1ps
module testbench;
    import riscv_pkg::*;
    import test_pkg::*;
    logic clk;

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    riscv_if u_interf(clk);

    
    Top u_cpu (
        .clk  (u_interf.clk),
        .rstn (u_interf.rst_n)
    );

    
    always_comb begin
        for (int i = 0; i < 1024; i++) begin
            u_interf.data_mem[i] = u_cpu.u_Memory_Cycle.u_Memory_Data.mem[i]; 
        end
    end

    
    initial begin
        #500us;
        $display("\n[%0t] [TESTBENCH] ERROR: Time out! Simulation hung.", $time);
        $finish;
    end

    
    base_test               base;
    
    basic_pass_through_test basic_pass_through_obj = new(u_interf);
    ALU_store_test          alu_store_obj          = new(u_interf);
    load_use_hazard_test    load_use_hazard_obj    = new(u_interf);
    ALU_forwarding_test     alu_forwarding_obj     = new(u_interf);
    store_data_hazard_test  store_data_hazard_obj  = new(u_interf);
    control_hazard_test     control_hazard_obj     = new(u_interf);
    load_then_add_test      load_then_add_obj      = new(u_interf);

   
    initial begin
        if ($test$plusargs("basic_pass_through_test")) begin
            $display("[TESTBENCH] Running Test: basic_pass_through_test");
            base = basic_pass_through_obj;
        end
        else if ($test$plusargs("ALU_store_test")) begin
            $display("[TESTBENCH] Running Test: ALU_store_test");
            base = alu_store_obj;
        end
        else if ($test$plusargs("load_use_hazard_test")) begin
            $display("[TESTBENCH] Running Test: load_use_hazard_test");
            base = load_use_hazard_obj;
        end
        else if ($test$plusargs("ALU_forwarding_test")) begin
            $display("[TESTBENCH] Running Test: ALU_forwarding_test");
            base = alu_forwarding_obj;
        end
        else if ($test$plusargs("store_data_hazard_test")) begin
            $display("[TESTBENCH] Running Test: store_data_hazard_test");
            base = store_data_hazard_obj;
        end
        else if ($test$plusargs("control_hazard_test")) begin
            $display("[TESTBENCH] Running Test: control_hazard_test");
            base = control_hazard_obj;
        end
        else if ($test$plusargs("load_then_add_test")) begin
            $display("[TESTBENCH] Running Test: load_then_add_test");
            base = load_then_add_obj;
        end
        else begin
            $display("\n[TESTBENCH] WARNING: No matching +TESTNAME specified!");
            $display("[TESTBENCH] Defaulting to: load_then_add_test\n");
            base = load_then_add_obj;
        end

        base.vif = u_interf; 
        base.run_test();
    end
endmodule