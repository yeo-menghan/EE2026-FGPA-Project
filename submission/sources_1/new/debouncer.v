`timescale 1ns / 1ps

module debouncer(input button, clk, output pulse);

    wire a, b;
    
    dff dff1(.clk(clk), .D(button), .Q(a));
    dff dff2(.clk(clk), .D(a), .Q(b));
    
    assign pulse = a & ~b;

endmodule
