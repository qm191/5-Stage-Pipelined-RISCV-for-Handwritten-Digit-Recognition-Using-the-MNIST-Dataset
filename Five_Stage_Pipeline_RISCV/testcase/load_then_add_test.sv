class load_then_add_test extends base_test;

    function new(virtual riscv_if vif_i);
        super.new(vif_i);
    endfunction

    virtual task run_scenario();
        $display("\n==========================================================");
        $display("[%0t] [TESTCASE 1] : Load then add test", $time);
        $display("==========================================================");
        
        
        run_program(
            "../testcase/mem/instr_load_then_add_test.hex", 
            "../testcase/mem/data_load_then_add_test.hex", 
            "../testcase/mem/golden_load_then_add_test.hex",
            50
        );
        
        $display("[%0t] [END TESTCASE] Load then add\n", $time);
    endtask

endclass: load_then_add_test