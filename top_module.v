module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Declare registers for each BCD digit
    reg [3:0] sec0, sec1;
    reg [3:0] min0, min1;
    reg [3:0] hour0, hour1;

    // AM/PM indicator logic
    always @(posedge clk)
    begin
        if (reset)
            pm <= 0;
        else if ((hour0 == 4'd1) && (hour1 == 4'd1) && (min1 == 4'd5) && (min0 == 4'd9) && (sec1 == 4'd5) && (sec0 == 4'd9))
            pm <= ~pm;
    end

    // Seconds unit place counter
    always @(posedge clk)
    begin
        if (reset)
            sec0 <= 0;
        else if (ena)
        begin
            if (sec0 == 4'd9)
                sec0 <= 4'd0;
            else
                sec0 <= sec0 + 1;
        end
    end

    // Seconds tens place counter
    always @(posedge clk)
    begin
        if (reset)
            sec1 <= 0;
        else if (ena)
        begin
            if ((sec1 == 4'd5) && (sec0 == 4'd9))
                sec1 <= 4'd0;
            else if (sec0 == 4'd9)
                sec1 <= sec1 + 1;
        end
    end

    // Minutes unit place counter
    always @(posedge clk)
    begin
        if (reset)
            min0 <= 0;
        else if (ena)
        begin
            if ((min0 == 4'd9) && (sec1 == 4'd5) && (sec0 == 4'd9))
                min0 <= 4'b0;
            else if ((sec1 == 4'd5) && (sec0 == 4'd9))
                min0 <= min0 + 1;
        end
    end

    // Minutes tens place counter
    always @(posedge clk)
    begin
        if (reset)
            min1 <= 0;
        else if (ena)
        begin
            if ((min1 == 4'd5) && (min0 == 4'd9) && (sec1 == 4'd5) && (sec0 == 4'd9))
                min1 <= 4'd0;
            else if ((min0 == 4'd9) && (sec1 == 4'd5) && (sec0 == 4'd9))
                min1 <= min1 + 1;
        end
    end

    // Hours unit place counter
    always @(posedge clk)
    begin
        if (reset)
            hour0 <= 4'd2;
        else if (ena)
        begin
            if ((sec1 == 4'd5) && (sec0 == 4'd9) && (min1 == 4'd5) && (min0 == 4'd9))
            begin
                if ((hour0 == 4'd9) && (hour1 == 4'd0))
                    hour0 <= 4'd0;
                else if ((hour0 == 4'd2) && (hour1 == 4'd1))
                    hour0 <= 4'd1;
                else
                    hour0 <= hour0 + 1;
            end
        end
    end

    // Hours tens place counter
    always @(posedge clk)
    begin
        if (reset)
            hour1 <= 4'd1;
        else if (ena)
        begin
            if ((hour1 == 4'd1) && (hour0 == 4'd2) && (sec1 == 4'd5) && (sec0 == 4'd9) && (min1 == 4'd5) && (min0 == 4'd9))
                hour1 <= 4'd0;
            else if ((sec1 == 4'd5) && (sec0 == 4'd9) && (min1 == 4'd5) && (min0 == 4'd9) && (hour0 == 4'd9))
                hour1 <= hour1 + 1;
        end
    end

    // Assign outputs
    assign ss = {sec1, sec0};
    assign mm = {min1, min0};
    assign hh = {hour1, hour0};

endmodule
