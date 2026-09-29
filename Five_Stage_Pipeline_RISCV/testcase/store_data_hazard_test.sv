class store_data_hazard_test extends base_test;

    function new(virtual riscv_if vif_i);
        super.new(vif_i);
    endfunction

    virtual task run_scenario();
        $display("\n==========================================================");
        $display("[%0t] [TESTCASE 6] : Store data hazard", $time);
        $display("==========================================================");
        
        
        run_program(
            "../testcase/mem/instr_store_data_hazard.hex", 
            "../testcase/mem/data_store_data_hazard.hex", 
            "../testcase/mem/golden_store_data_hazard.hex",
            50
        );
        
        $display("[%0t] [END TESTCASE] Store data hazard\n", $time);
    endtask

endclass: store_data_hazard_test