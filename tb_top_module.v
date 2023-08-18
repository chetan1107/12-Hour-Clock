module tb_top_module;

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
    top_module dut (
        .clk(clk),
        .reset(reset),
        .ena(ena),
        .pm(pm),      // No need to connect pm in the testbench
        .hh(hh),
        .mm(mm),
        .ss(ss)
    );

   wire observed_pm; // Additional wire to observe pm
    assign observed_pm = pm;

    // Clock generation
    reg clk_period = 10; // Adjust this value to set the clock period
    always #((clk_period)/2) clk = ~clk;

    // Testbench stimulus
    initial begin
        reset = 1;
        ena = 0;

        // Reset and wait for a few clock cycles
        #10 reset = 0;

        // Enable the clock module
        ena = 1;
// Test various scenarios
        #100;
        // Display the time and AM/PM value
        $display("Time: %d:%d:%d %s", hh, mm, ss, (observed_pm) ? "PM" : "AM");

        // Wait for some time to see the clock changes
        #200000;

        // Disable the clock module
        ena = 0;

        // Finish simulation
        $finish;
    end

endmodule
