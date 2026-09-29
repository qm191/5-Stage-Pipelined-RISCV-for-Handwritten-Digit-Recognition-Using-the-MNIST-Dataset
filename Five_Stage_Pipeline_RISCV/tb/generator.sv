class generator;
    mailbox gen2drv;

    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task send_trans(transaction tr);
        gen2drv.put(tr);
        $display("[%0t] [GENERATOR] Sent trans to Driver", $time);
    endtask

    task run();
    endtask
endclass: generator