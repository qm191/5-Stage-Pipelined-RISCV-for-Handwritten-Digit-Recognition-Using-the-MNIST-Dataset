class environment;
    generator  gen;
    driver     drv;
    monitor    mon;
    scoreboard sb;

    mailbox gen2drv;
    mailbox mon2scb;

    virtual riscv_if vif;

    function new(virtual riscv_if vif);
        this.vif = vif;
    endfunction

    function void build();
        $display("[%0t] [ENVIRONMENT] Building CPU Verification Components...", $time);
        gen2drv = new();
        mon2scb = new();

        gen = new(gen2drv);
        drv = new(vif, gen2drv);
        mon = new(vif, mon2scb);
        sb  = new(mon2scb);
    endfunction

    task run();
        fork
            gen.run();
            drv.run();
            mon.run();
            sb.run();
        join_none
    endtask

    function void report();
        if (sb != null) sb.report();
    endfunction
endclass: environment