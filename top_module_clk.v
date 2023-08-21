
module top_module_clk(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg  [7:0] hh,
    output reg [7:0] mm,
    output  reg [7:0] ss); 


wire ena_ss,ena_mm,ena_hh,resetss,resetmm,resethh;
    wire  [7:0] hhh,mmm,sss;
    reg [5:0] load;
    reg [23:0] d;
    
    always @(*) begin         //posedge clk will not cme in senstivity list 
         ss<=sss;
         mm<=mmm;
         hh<=hhh;
        if(reset) begin
            // pm<=0;
            load<=6'b111111;
            d<=24'h120000;
              
        end
        else if(ena & ({hh,mm,ss}=={8'h11,8'h59,8'h59}))begin
            load<=6'b110000;
            d<=24'h120000;     
        end
        else if(ena & ({hh,mm,ss}=={8'h12,8'h59,8'h59}))begin
          //  pm<=~pm;                  //causing infinte time
            load<=6'b110000;
            d<=24'h010000;     
        end
        else begin
            load<=0;
        end
    end
    
    always @(posedge clk) begin 
        pm <= (ena & ({hh,mm,ss}=={8'h11,8'h59,8'h59}))^pm;
    end


    
    assign ena_ss = sss[0] & sss[3] ;
    assign resetss = (sss==8'h59)?1'b1:1'b0; 
    bcd_counter ss0 (clk,resetss,load[0],d[3:0],ena,sss[3:0]);
    bcd_counter ss1 (clk,resetss,load[1],d[7:4],(ena_ss & ena),sss[7:4]);
    
    assign ena_mm = mmm[0] & mmm[3] & resetss;
    assign  resetmm = ((mmm==8'h59) & resetss)?1'b1:1'b0;
    bcd_counter mm0 (clk,resetmm,load[2],d[11:8],(resetss & ena),mmm[3:0]);
    bcd_counter mm1 (clk,resetmm,load[3],d[15:12],(ena_mm & ena),mmm[7:4]);
    
    assign ena_hh = hhh[0] & hhh[3] & resetss & resetmm;
   // assign resethh = (hhh==8'h12)?1:0; 
    bcd_counter hh0 (clk,resethh,load[4],d[19:16],(resetmm & ena),hhh[3:0]);
    bcd_counter hh1 (clk,resethh,load[5],d[23:20],(ena_hh & ena),hhh[7:4]);
    
    
endmodule

module bcd_counter(
input clk,
input reset,
input load,
input [3:0] d,
input enable,
output reg [3:0] q);
    always @(posedge clk) begin
        if(reset | (q==9 & enable))
            q<=0;
        else if(load)
            q<=d;
        else if(enable)
            q<=q+1;  
    end
endmodule
