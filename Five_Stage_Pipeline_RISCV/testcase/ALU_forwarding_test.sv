class ALU_forwarding_test extends base_test;

    function new(virtual riscv_if vif_i);
        super.new(vif_i);
    endfunction

    virtual task run_scenario();
        $display("\n==========================================================");
        $display("[%0t] [TESTCASE 5] : ALU Forwarding", $time);
        $display("==========================================================");
        run_program(
            "../testcase/mem/instr_ALU_forwarding.hex", 
            "../testcase/mem/data_ALU_forwarding.hex", 
            "../testcase/mem/golden_ALU_forwarding.hex",
            50
        );
        
        $display("[%0t] [END TESTCASE] ALU Forwarding\n", $time);
    endtask

endclass: ALU_forwarding_test