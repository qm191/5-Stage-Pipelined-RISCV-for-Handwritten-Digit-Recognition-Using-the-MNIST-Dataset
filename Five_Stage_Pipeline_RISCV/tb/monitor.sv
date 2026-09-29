class monitor;
    virtual riscv_if vif;
    mailbox mon2scb;

    function new(virtual riscv_if vif, mailbox mon2scb);
        this.vif     = vif;
        this.mon2scb = mon2scb;
    endfunction

    task capture_cpu_dump();
        data_mem_t captured_mem;
        
        $display("[%0t] [MONITOR] Capturing Data Memory Dump (RAM)...", $time);
        
        
        for(int i = 0; i < 1024; i++) begin
            captured_mem[i] = vif.data_mem[i];
        end
        
        
        mon2scb.put(captured_mem);
    endtask

    task run();
        
    endtask
endclass: monitor