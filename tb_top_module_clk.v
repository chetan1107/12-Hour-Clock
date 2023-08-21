`timescale 1ns/1ps
module tb_top_module_clk();

    // Inputs
    reg clk;
    reg reset;
    reg ena;

    // Outputs
   
    wire pm;
    wire [7:0] hh;
    wire [7:0] mm;
    wire [7:0] ss;

    // Instantiate the clock module
    top_module_clk dut (   clk,
     reset,
     ena,
     pm,
     hh,
     mm,
     ss
    );

always #5 clk=~clk;

    // Testbench stimulus
    initial begin
clk<= 0;
        reset <= 1'b0;
        ena <= 1'b0;
  end



initial begin
$dumpfile ("tb_result.vcd");
$dumpvars (0, tb_top_module_clk);
#7
           reset <= 1'b1;
        ena <= 1'b0;
        // Reset and wait for a few clock cycles
        #12 reset <= 1'b0;

        // Enable the clock module
        ena <= 1'b1;

        // Wait for some time to see the clock changes
        #200000;

        // Disable the clock module
        ena <= 1'b0;

        // Finish simulation
        $finish;
    end

endmodule
