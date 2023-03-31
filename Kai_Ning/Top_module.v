`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2023 00:18:17
// Design Name: 
// Module Name: Top_module
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


module Top_module(
input basys_clock, 
input SW5,
input btnC, btnU,
output JX0, JX1, JX2, JX3,
output cs, sdin, sclk, d_cn, resn, vccen, pmoden,
output LED1, LED2,
inout ps2_clk, ps2_data
);

//CALCULATOR MODULES
//wire clk20k;
//wire clk25M;
wire clk6p25m;
//flexi_clock clk20khz (.sys_clk(basys_clock), .freq(20000), .clk(clk20k));
//flexi_clock clk20Mhz (.sys_clk(basys_clock), .freq(25000000), .clk(clk25M));
flexi_clock clk6_25M (.sys_clk(basys_clock), .freq(6250000), .clk(clk6p25m));

 
 wire [15:0] oled_data;
 wire [12:0] pixel_idx;
 wire reset;
 wire frame_begin;
 wire sending_pixels;
 wire sample_pixel;
 
Oled_Display b(.clk(clk6p25m), .reset(reset), .frame_begin(frame_begin), .sending_pixels(sending_pixels),
     .sample_pixel(sample_pixel), .pixel_index(pixel_idx), .pixel_data(oled_data), .cs(cs), .sdin(sdin), .sclk(sclk), .d_cn(d_cn), .resn(resn), .vccen(vccen),
     .pmoden(pmoden));

 wire [6:0] x_coord;
 wire [5:0] y_coord;
 convertXY convertxy(.pixel_idx(pixel_idx), .x(x_coord), .y(y_coord));
 
wire [11:0] xpos;
wire [11:0] ypos;
wire [3:0] zpos;
wire left, middle, right, new_event;
   
MouseCtl c(.clk(clk6p25m), .rst(0), .xpos(xpos), .ypos(ypos), .zpos(zpos), .left(left), .middle(middle), .right(right), .new_event(new_event), .value(0), .setx(0), .sety(0), .setmax_x(0), .setmax_y(0), .ps2_clk(ps2_clk), .ps2_data(ps2_data));

wire left_d;
debouncer debouncer_left(.button(left), .clk(clk6p25m), .pulse(left_d));

//calculator_main calc(.clk(clk6p25m), .left(left_d), .x_coord(x_coord), .y_coord(y_coord), .xpos(xpos), .ypos(ypos), .pixel_idx(pixel_idx), .oled_data(oled_data));       
 
 piano_design piano(.clk(clk6p25m), .left(left_d), .SW5(SW5), .xpos(xpos), .ypos(ypos), .x(x_coord), .y(y_coord), .JX0(JX0), .JX1(JX1), .JX2(JX2), .JX3(JX3), .oled_data(oled_data)); 

endmodule
