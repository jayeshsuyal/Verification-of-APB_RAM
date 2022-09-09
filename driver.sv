class driver;

    transaction datac; //datac - because it the data container from the gen/tr;
    virtual apb_if vif;

    event drvnext;

     function new(mailbox#(transaction) mbxgd);
        this.mbxgd = mbxgd;
    endfunction

    task reset();
        vif.presetn <= 1'b1; //active high reset
        vif.pwdata <= 0;
        vif.prdata <= 0;
        vif.paddr <= 0;
        vif.pwrite <= 0;
        vif.psel <= 1'b0;
        vif.penable <= 1'b0;
        repeat (5) @(posedge vif.pclk)
        vif.presetn <= 1'b0;
        repeat (5) @(posedge vif.pclk)
        $display("RESET COMPLETE..!!");
    endtask

    task run();
        forever begin
            mbxgd.get(datac);
             if(vif.oper == 0) begin    //write
                vif.psel <= 1'b1;
                vif.penable <= 1'b0;
                vif.pwrite <= 1;
                vif.paddr <= datac.paddr;
                vif.pwdata <= datac.pwdata;
                @(posedge vif.pclk)
                vif.penable <= 1'b1;
                repeat(2) @(posedge vif.pclk) //extra clock cycle
                vif.psel <= 1'b0;
                vif.penable <= 1'b0;
                vif.pwrite <= 0;
                $display("WRITE:- DATA: %0d, ADDR: %0d", vif.pwdata,vif.paddr);
             end
             else if (vif.oper==1) begin //read
                vif.psel <= 1'b1;
                vif.penable <= 1'b0;
                vif.pwrite <= 0;
                vif.paddr <= datac.paddr;
                vif.pwdata <= datac.pwdata;
                @(posedge vif.pclk)
                vif.penable <= 1'b1;
                repeat(2) @(posedge vif.pclk) //extra clock cycle
                vif.psel <= 1'b0;
                vif.penable <= 1'b0;
                vif.pwrite <= 0;
                $display("READ:- DATA: %0d, ADDR: %0d", vif.pwdata,vif.paddr);
             end
             else if (vif.oper == 2) begin  //radomization
                vif.psel <= 1'b1;
                vif.penable <= 1'b0;
                vif.pwrite <= vif.pwrite;
                vif.paddr <= datac.paddr;
                vif.pwdata <= datac.pwdata;
                @(posedge vif.pclk)
                vif.penable <= 1'b1;
                repeat(2) @(posedge vif.pclk) //extra clock cycle
                vif.psel <= 1'b0;
                vif.penable <= 1'b0;
                vif.pwrite <= 0;
                $display("RANDOM OPERATION");
             end
             else if (vif.oper == 3) begin         //error
                vif.psel <= 1'b1;
                vif.penable <= 1'b0;
                vif.pwrite <= 1;
                vif.paddr <= $urandom_range(32,100);
                vif.pwdata <= datac.pwdata;
                @(posedge vif.pclk)
                vif.penable <= 1'b1;
                repeat(2) @(posedge vif.pclk) //extra clock cycle
                vif.psel <= 1'b0;
                vif.penable <= 1'b0;
                vif.pwrite <= 0;
                $display("READ:- DATA: %0d, ADDR: %0d", vif.pwdata,vif.paddr);
             end
            
            -> drvnext;
        end    
    endtask
endclass