class control_hazard_test extends base_test;

    function new(virtual riscv_if vif_i);
        super.new(vif_i);
    endfunction

    virtual task run_scenario();
        $display("\n==========================================================");
        $display("[%0t] [TESTCASE 7] : Control hazard", $time);
        $display("==========================================================");
        
        
        run_program(
            "../testcase/mem/instr_control_hazard.hex", 
            "../testcase/mem/data_control_hazard.hex", 
            "../testcase/mem/golden_control_hazard.hex",
            50
        );
        
        $display("[%0t] [END TESTCASE] Control hazard\n", $time);
    endtask

endclass: control_hazard_test