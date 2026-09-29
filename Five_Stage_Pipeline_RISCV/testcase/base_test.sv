class base_test;
    environment env;
    virtual riscv_if vif;

    function new(virtual riscv_if vif_i);
        this.vif = vif_i;
    endfunction 

    function void build();
        env = new(vif);
        env.build();
    endfunction

    task run_program(string instr_hex, string data_hex, string golden_dump, int cycles = 100);
        transaction tr = new();
        tr.instr_hex_file   = instr_hex;
        tr.data_hex_file    = data_hex;
        tr.golden_dump_file = golden_dump;
        tr.run_cycles       = cycles; 
        
        
        env.gen.send_trans(tr);
       
        @(env.drv.cpu_finished);
        
       
        env.mon.capture_cpu_dump();
      
        env.sb.compare_with_golden(golden_dump);
    endtask

    virtual task run_scenario();
    endtask

    task run_test();
        build();
       
        env.run();
        
        run_scenario();
       
        #10ns;
        env.report();
        $display("[%0t] [BASE_TEST] End System Dump Simulation", $time);
        $finish;
    endtask
endclass: base_test