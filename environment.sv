class environment;

    //handler for the classes
    generator gen;
    driver dr;
    monitor mon;
    scoreboard sco;

    //events declared previous classes
    event nextgd; //gen -> drv
    event nextgs; // gen -> sco

    //mailbox declaration
    mailbox #(transaction) gdmbx; // gen -> drv
    mailbox #(transaction) msmbx; // mon -> sco
    

    //declaration of interface.
    virtual apb_if vif;

    function new();
        gdmbx = new();
        msmbx = new();

        gen = new(gdmbx);
        drv = new(gdmbx);

        mon = new(msmbx);
        sco = new(msmbx);

        gen.drvnext = nextgd;
        drv.drvnext = nextgd;

        gen.sconext = nextgs;
        sco.sconext = nextgs;

    endfunction
    
    task pre_test();
        drv.reset();
    endtask

    task test();
        fork
            gen.run();
            drv.run();
            mon.run();
            sco.run();
        join_any
    endtask

    task post_test();
        wait(gen.done.triggered);  
        $finish();
    endtask

    task run();
        pre_test();
        test();
        post_test();
    endtask


endclass