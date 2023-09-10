`timescale 1ns / 1ps

module testbench_2_digit;
    reg [3:0] d1, d2;
    wire [3:0] q1, q2;
    
    reg en, load, up, clk, n_clr;
    wire co;
    bcd_2_digit dut(
        .d1(d1), 
        .d2(d2),
        .enable(en),
        .load(load),
        .up(up),
        .clk(clk),
        .n_clr(n_clr),
        .q1(q1),
        .q2(q2),
        .co(co)
    );
    
    
    initial begin
        $display("2 digit test bench 1 start");
        // reset
        #100;
        #5 n_clr = 1;
        #5 n_clr = 0;
        #5 n_clr = 1;
        
        if(q1 != 0 || q2 != 0 || co != 0)
            $display("reset failed");
        
        en = 1;
        load = 1;
        d1 = 7;
        d2 = 9;
        
        #10 clk = 0;
        #10 clk = 1;
        if(q1 != 7 || q2 != 9 || co != 0)
            $display("load failed");
        
        load = 0;
        up = 1;
        // increment 3 times
        #10 clk = 0;
        #10 clk = 1;
        if(q1 != 8 || q2 != 9 || co != 0)
            $display("inc 1 failed");
        #10 clk = 0;
        #10 clk = 1;
        if(q1 != 9 || q2 != 9 || co != 0)
            $display("inc 2 failed");
        #10 clk = 0;
        #10 clk = 1;
        if(q1 != 9 || q2 != 9 || co != 1)
            $display("inc 3 failed (the one where it stays at 99)");
            
        up = 0;
        // decrement 4 times
        #10 clk = 0;
        #10 clk = 1;
        if(q1 != 8 || q2 != 9 || co != 0)
            $display("dec 1 failed");
        #10 clk = 0;
        #10 clk = 1;
        if(q1 != 7 || q2 != 9 || co != 0)
            $display("dec 2 failed");
        #10 clk = 0;
        #10 clk = 1;
        if(q1 != 6 || q2 != 9 || co != 0)
            $display("dec 3 failed)");
        
        #10 clk = 0;
        #10 clk = 1;
        if(q1 != 5 || q2 != 9 || co != 0)
            $display("dec 4 failed)");
        
        en = 0;
        // do nothing for 2 clocks
        repeat (2) begin
            #10 clk = 0;
            #10 clk = 1;
            if(q1 != 5 || q2 != 9 || co != 0)
                $display("do nothing failed");
            else
                $display("do nothing good");
        end
        $display("2 digit test bench 1 over");
    end
endmodule
