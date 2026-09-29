class basic_pass_through_test extends base_test;

    function new(virtual riscv_if vif_i);
        super.new(vif_i);
    endfunction

    virtual task run_scenario();
        $display("\n==========================================================");
        $display("[%0t] [TESTCASE 2] : Basic pass through", $time);
        $display("==========================================================");
        run_program(
            "../testcase/mem/instr_basic_pass_through.hex", 
            "../testcase/mem/data_basic_pass_through.hex", 
            "../testcase/mem/golden_basic_pass_through.hex",
            50
        );
        
        $display("[%0t] [END TESTCASE] Basic pass through\n", $time);
    endtask

endclass: basic_pass_through_test