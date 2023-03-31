`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2023 10:15:50
// Design Name: 
// Module Name: debouncer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module debouncer(input button, clk, output pulse);

    wire a, b;
    
    dff dff1(.clk(clk), .D(button), .Q(a));
    dff dff2(.clk(clk), .D(a), .Q(b));
    
    assign pulse = a & ~b;

endmodule
