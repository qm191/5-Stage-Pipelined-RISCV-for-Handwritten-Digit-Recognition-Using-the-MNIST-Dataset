class driver;
    virtual riscv_if vif;
    mailbox gen2drv;
    event cpu_finished; 

    function new(virtual riscv_if vif, mailbox gen2drv);
        this.vif     = vif;
        this.gen2drv = gen2drv;
    endfunction

    task load_and_run();
        transaction tr;
        forever begin
            gen2drv.get(tr);
            
            $display("[%0t] [DRIVER] Loading Instr: %s | Data: %s", $time, tr.instr_hex_file, tr.data_hex_file);
            
            
            vif.rst_n <= 1'b0;
            
            vif.load_hex(tr.instr_hex_file, tr.data_hex_file);
            
            repeat(5) @(posedge vif.clk); 
            
            vif.rst_n <= 1'b1;
            $display("[%0t] [DRIVER] CPU Release Reset - Execution Started...", $time);

            repeat(tr.run_cycles) @(posedge vif.clk);
            
            $display("[%0t] [DRIVER] Complete %0d simulation cycles.", $time, tr.run_cycles);
            -> cpu_finished; 
        end
    endtask
    task run();
        load_and_run();
    endtask
endclass: driver