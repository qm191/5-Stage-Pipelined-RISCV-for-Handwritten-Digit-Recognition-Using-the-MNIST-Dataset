class load_use_hazard_test extends base_test;

    function new(virtual riscv_if vif_i);
        super.new(vif_i);
    endfunction

    virtual task run_scenario();
        $display("\n==========================================================");
        $display("[%0t] [TESTCASE 4] : Load use hazard", $time);
        $display("==========================================================");
        
        
        run_program(
            "../testcase/mem/instr_load_use_hazard.hex", 
            "../testcase/mem/data_load_use_hazard.hex", 
            "../testcase/mem/golden_load_use_hazard.hex",
            50
        );
        
        $display("[%0t] [END TESTCASE] Load use hazard\n", $time);
    endtask

endclass: load_use_hazard_test