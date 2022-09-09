interface apb_if vif;

  logic presetn;
  logic pclk;
  logic psel;
  logic penable;
  logic pwrite;
  logic [31:0] paddr, pwdata;
  logic reg [31:0] prdata;
  logic reg pready, pslverr;
    
endinterface