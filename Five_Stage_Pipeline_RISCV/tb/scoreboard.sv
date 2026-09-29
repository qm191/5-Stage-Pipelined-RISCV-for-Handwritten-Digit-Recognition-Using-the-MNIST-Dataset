class scoreboard;
    mailbox mon2scb;
    int total_tests = 0;
    int error_cnt   = 0;
    parameter MEM_DEPTH = 1024; 

    function new(mailbox mon2scb);
        this.mon2scb = mon2scb;
    endfunction

    task compare_with_golden(string golden_file_path);
        data_mem_t actual_data_mem;
        logic [31:0] golden_data_mem [0:MEM_DEPTH-1];
        
        mon2scb.get(actual_data_mem);
        $readmemh(golden_file_path, golden_data_mem);
        
        total_tests++;
        $display("\n================ [SCOREBOARD CHECKING DATA MEMORY] ================");
        
        for (int i = 0; i < MEM_DEPTH; i++) begin
            if (actual_data_mem[i] !== golden_data_mem[i]) begin
                $error("[%0t] [SCB-FAIL] Addr [0x%0h] Mismatch! Actual: 0x%0h | Golden: 0x%0h", 
                        $time, i, actual_data_mem[i], golden_data_mem[i]);
                error_cnt++;
            end
        end
        
        if (error_cnt == 0) begin
            $display("[%0t] [SCB-PASS] ALL DATA MEMORY LOCATIONS MATCH WITH GOLDEN DUMP!", $time);
        end
        $display("===================================================================\n");
    endtask

    task run();
    endtask

    function void report();
        $display("\n==========================================================");
        $display("             DATA MEMORY CHECK SUMMARY                    ");
        $display("==========================================================");
        $display(" Total Errors Detected   : %0d", error_cnt);
        $display("----------------------------------------------------------");
        if (error_cnt == 0)
            $display(" >>> TESTCASE RESULT : [ PASSED ] <<<");
        else
            $display(" >>> TESTCASE RESULT : [ FAILED ] <<<");
        $display("==========================================================\n");
    endfunction
endclass: scoreboard