class transaction;

    typedef enum int {write = 0, read = 1, random = 2 , error = 3} type_op;

    randc type_op oper;
    rand bit [31:0] paddr;
    rand bit[31:0] pwdata;
    rand bit [31:0] prdata;
    bit psel;
    bit penable;
    bit pwrite;
    bit pslverr;

    constraint wdata_c{pwdata> 0 , pwdata <5};
    constraint addr_c {paddr > 0, paddr< 10};

    function void display(input string tag);
        $display("[%0s] - oper:%0s, ADDR: %0d, WDATA: %0d, RDATA: %0d, SEL:%0d, ENEABLE:%0d, WRITE: %0d, ERROR%0d",tag,oper,paddr,pwdata,prdata,psel,penable,pwrite,pslverr);
    endfunction


    function transaction copy();
        copy = new();
        copy.oper = this.oper;
        copy.paddr = this.paddr;
        copy.pwdata = this.pwdata;
        copy.prdata = this.prdata;
        copy.psel = this.psel;
        copy.penable = this.penable;
        copy.pwrite = this.pwrite;
        copy.pslverr = this.pslverr;
    endfunction
endclass