`timescale 1ns / 1ps

module testbench_1_digit;
    reg [3:0] d;
    reg enable, load, up, clk, n_clr;
    wire [3:0] q;
    wire overflow;
    
    parameter period = 10;
    
    bcd_1_digit dut(.d(d), .enable(enable), .load(load), .up(up), .clk(clk), .n_clr(n_clr), .q(q), .co(overflow));
    
    initial begin
        $display("testbench starting");
        #100;
        // reset
        $display("resetting");
        n_clr = 1;
        #5;
        n_clr = 0;
        #5;
        if (q != 0 || overflow != 0)
            $display("reset failed");
        else
            $display("reset good");
        # 5 n_clr = 1;

        // load
        #period clk = 0;
        enable = 1;
        load = 1;
        d = 6;
        #period clk = 1;
        #period clk = 0;
        if(q != 6 || overflow != 0)
            $display("load failed");
//        else
//            $display("load good");
        
        // start incrementing
        load = 0;
        up = 1;
        // ready for clocks
        #period clk = 1;
            #period clk = 0;
        if(q != 7 || overflow != 0)
                $display("inc1 failed");
    
        #period clk = 1;
            #period clk = 0;
        if(q != 8 || overflow != 0)
                $display("inc2 failed");
    
        #period clk = 1;
            #period clk = 0;
        if(q != 9 || overflow != 0)
                $display("inc3 failed");
    
        #period clk = 1;
            #period clk = 0;
        if(q != 0 || overflow != 1)
                $display("inc4 failed");
            
        // set up for dec
        up = 0;
        
        // punch the clock
        #period clk = 1;
            #period clk = 0;
        if (q != 9 || overflow != 1)
            $display("dec failed");
        $display("testbench over");
        end
endmodule
