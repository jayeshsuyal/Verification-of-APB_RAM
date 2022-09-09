class monitor;

    transaction  tr;
    mailbox #(transaction) mbx;
    virtual apb_if vif;

    function new();
    this.mbx = mbx;
    endfunction

    task run();
        tr =new(); //handler for the transaction class
        forever 
        begin
            @(posedge vif.pclk);
            if(vif.psel && !vif.penable) 
            begin
                
                    @(posedge vif.pclk);
                    if(vif.psel && vif.penable && pwrite)begin
                        @(posedge vif.pclk);
                        tr.pwdata <=vif.pwdata;
                        tr.paddr<= vif.paddr;
                        tr.pwrite <= vif.pwrite; //write = 1;
                        tr.pslverr <= vif.pslverr;
                        $display("[MON]: WRITE_DATA: %0d, ADDR: %0d"tr.pwdata,tr.paddr);
                         @(posedge vif.pclk); ///4 clocks driver class so 4 class in mon;
                    end
                    else if (vif.psel && vif.penable && !pwrite) begin
                        @(posedge vif.pclk);
                        tr.prdata <=vif.prdata;
                        tr.paddr<= vif.paddr;
                        tr.pwrite <= vif.pwrite; //write = 0;
                        tr.pslverr <= vif.pslverr;
                        $display("[MON]: READ_DATA: %0d, ADDR: %0d"tr.prdata,tr.paddr);
                        @(posedge vif.pclk);
                    end
                end
        end
    endtask
endclass