`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.02.2023 09:33:55
// Design Name: 
// Module Name: clock_20kHz
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


module clock_20kHz(
input basys_clock,
output reg clk20khz = 0
    );
    
 reg [31:0] COUNT = 4'b0000;
    always @ (posedge basys_clock) 
    begin
        COUNT <= (COUNT == 2499) ? 0 : COUNT + 1;
        clk20khz <= (COUNT == 0) ? ~clk20khz : clk20khz;
    end
  
endmodule

module clock_6_25MHz(
input basys_clock,
output reg clk6p25m = 0
);

    reg [31:0] COUNT = 4'b0000;
       always @ (posedge basys_clock)
       begin
        COUNT <= (COUNT == 7) ? 0 : COUNT + 1;
        clk6p25m <= (COUNT == 0) ? ~clk6p25m : clk6p25m;
       end
endmodule

module flexi_clock(
    input sys_clk,
    input [31:0] freq,
    output reg clk = 0
    );
    
    reg [31:0] count = 0;
    reg [31:0] m;
    
    always @ (posedge sys_clk) begin
    m = 100000000/(2*freq) - 1;
    count <= (count == m) ? 0 : count + 1; //20Hz
    clk <= (count == 0) ? ~clk : clk;
    end
    
    
    
endmodule
        

