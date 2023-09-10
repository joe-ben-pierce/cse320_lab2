`timescale 1ns / 1ps


module bcd_1_digit(
    d,
    enable, load, up, clk, n_clr,
    q,
    co
    );
    input [3:0] d;
    input enable, load, up, clk, n_clr;
    output reg [3:0] q;
    output reg co;
    
    always @(posedge clk, negedge n_clr) begin
        if (!n_clr) begin
            q <= 0;
            co <= 0;
        end
        else if (load & enable) begin
            q <= d;
            co <= 0;
        end
        else if (!load & enable & up) begin
            q <= (q < 9) ? q + 1: 0; // hopefully '<' is an unsigned comparison (fingers crossed)
            co <= q == 9;
        end
        else if (!load & enable & !up) begin
            q <= (q > 0) ? q - 1: 9;
            co <= (q > 0) ? 0: 1; // if it underflowed to 9 should cout go? Not clear.
        end
        else begin
            // directions don't specify what to do here
            // I guess enable is off so don't do anything?
            q <= q;
            co <= co;
        end
    end
endmodule


module bcd_2_digit(
    d1, d2,
    enable, load, up, clk, n_clr,
    q1, q2,
    co
    );
    input [3:0] d1, d2;
    input enable, load, up, clk, n_clr;
    output [3:0] q1, q2;
    output co;
    assign co = cout_tens;
    wire cout_ones;
    wire cout_tens;
    bcd_1_digit ones(.d(d1), .enable(en1), .load(load), .up(up), .clk(clk), .n_clr(n_clr), .q(q1), .co(cout_ones));
    bcd_1_digit tens(.d(d2), .enable(en2), .load(load), .up(up2), .clk(clk), .n_clr(n_clr), .q(q2), .co(cout_tens));
    
    wire overflow = cout_ones & (q1 == 0);
    wire underflow = cout_ones & (q1 == 9);
    wire up2 = overflow;
    wire en2 = enable & (load | overflow | underflow);
    wire en1 = enable & !(!up && q1 == 0 && q2 == 0) & !(up && q1 == 9 && q2 == 9);
    
    
endmodule
