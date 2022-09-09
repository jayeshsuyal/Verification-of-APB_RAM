module apb_ram (
  input presetn,
  input pclk,
  input psel,
  input penable,
  input pwrite,
  input [31:0] paddr, pwdata,
  output reg [31:0] prdata,
  output reg pready, pslverr
);
  
  reg [31:0] mem [32];
  
  typedef enum {idle = 0, setup = 1, access = 2, transfer = 3} state_type;
 
  state_type state = idle, next_state = idle; 
  
  always@(posedge pclk)
    begin
      if(presetn == 1'b0) 
      begin
        state <= idle;
        prdata <= 32'h00000000;
        pready <= 1'b0;
         pslverr <= 1'b0;
        for(int i = 0; i < 32; i++) begin
          mem[i] <= 0;
        end
       end 
      else 
        begin
    
      case(state)
      idle : 
      begin
        prdata <= 32'h00000000;
        pready <= 1'b0;
        pslverr <= 1'b0;
        
        if((psel == 1'b0) && (penable == 1'b0)) 
            begin
            state <= setup;
            end
      end
      
      setup: ///start of transaction
      begin
           if((psel == 1'b1) && (penable == 1'b0)) begin
            if(paddr < 32) begin 
            state <= access;
            pready <= 1'b1;
            end
            else
            begin
            state <= access;
            pready <= 1'b0;
            end
           end
            else
            state <= setup;
      end
        
      access: 
      begin 
        if(psel && pwrite && penable) 
          begin
            if(paddr < 32) 
            begin
            mem[paddr] <= pwdata;
            state <= transfer;
            pslverr <= 1'b0;
            end
            else 
            begin
            state <= transfer;
            pready <= 1'b1;
            pslverr <= 1'b1;
            end
          end
        else if ( psel && !pwrite && penable)
            begin
            if(paddr < 32) 
            begin
            prdata <= mem[paddr];
            state <= transfer;
            pready <= 1'b1;
            pslverr <= 1'b0;
            end
            else 
            begin
            state <= transfer;
            pready <= 1'b1;
            pslverr <= 1'b1;
            prdata <= 32'hxxxxxxxx;
            end
          end
       end      
        transfer: begin
          state <= setup;
          pready <= 1'b0;
          pslverr <= 1'b0;
        end
        
  
      
      default : state <= idle;
   
      endcase
      
    end
  end
  
  
endmodule