`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2023 21:18:23
// Design Name: 
// Module Name: my_clock
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


module my_clock(
    input basys_clock,
    input [31:0] freq,
    output reg clk
    );
    
    reg [31:0] count = 0;
    reg [31:0] m;
    
    always @ (posedge basys_clock) begin
       m = 100000000/(2*freq) - 1;
       count <= (count == m) ? 0 : count + 1;
       clk <= (count == 0) ? ~clk : clk;
    end
endmodule