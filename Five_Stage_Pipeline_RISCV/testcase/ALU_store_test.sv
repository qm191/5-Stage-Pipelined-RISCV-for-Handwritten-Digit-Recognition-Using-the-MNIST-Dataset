class ALU_store_test extends base_test;

    function new(virtual riscv_if vif_i);
        super.new(vif_i);
    endfunction

    virtual task run_scenario();
        $display("\n==========================================================");
        $display("[%0t] [TESTCASE 3] : ALU & Store", $time);
        $display("==========================================================");
        
        // Chạy file hex với giới hạn 50 chu kỳ clock
        run_program(
            "../testcase/mem/instr_ALU_store.hex", 
            "../testcase/mem/data_ALU_store.hex", 
            "../testcase/mem/golden_ALU_store.hex",
            50
        );
        
        $display("[%0t] [END TESTCASE] ALU & Store\n", $time);
    endtask

endclass: ALU_store_test