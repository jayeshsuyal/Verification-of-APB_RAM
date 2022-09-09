class scoreboard;
    transaction tr;
    mailbox #(transaction) mbx;
    event sconext;

    bit [31:0] pwdata [12] = '{default:0};
    bit [31:0] rdata = 0;

    function new();
        this.mbx = mbx;
    endfunction

    task run();
        forever begin
            mbx.get(tr);
            $display("[SCO]: WDATA- %0d, RDATA: %0d, ADDR: %0d, PWRITE: %0d"tr.pwdata,tr.prdata,tr.paddr,tr.pwrite);

            if((tr.pwrite == 1'b1) && (psel ==1'b0)) //write
            begin
                pwdata[tr.paddr] <= tr.pwdata;
                $display("WRITE:%0d, WDATA:, ADDR: %0d", tr.pwrite, pwdata,tr.paddr);
            end
            else if ((tr.pwrite == 1'b0) && (psel ==1'b0)) begin
                rdata <= pwdata[tr.paddr];
                if(rdata == tr.prdata)
                    $display("DATA MATCHED");
                else
                    $display("DATA MISMATCHED");
            end
            else if (pse1 == 1'b1) begin
                $display("SLV ERRROR OCCURED");
            end
            -> sconext;
        end

    endtask


endclass