`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2023 02:37:52
// Design Name: 
// Module Name: temp_main
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
module temp_main(
input basys_clock, 
inout ps2_clk, ps2_data,
output LED1,
output cs, sdin, sclk, d_cn, resn, vccen, pmoden  //for oled display
);

Test_Mouse_Cursor x(
.basys_clock(basys_clock), 
.cs(cs), .sdin(sdin), .sclk(sclk), .d_cn(d_cn), .resn(resn), .vccen(vccen), .pmoden(pmoden),
.LED1(LED1),
.ps2_clk(ps2_clk), .ps2_data(ps2_data)
);

endmodule
