`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2023 16:16:25
// Design Name: 
// Module Name: Group_Integration
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
module Group_Integration(
input basys_clock, 
input [6:0]x,
input [5:0]y,
output cs, sdin, sclk, d_cn, resn, vccen, pmoden,
inout ps2_clk, ps2_data,
output reg LED1, LED2, 
output reg [6:0] mouse_click = 0
 );

 reg [15:0] oled_data;
 wire [12:0] my_pixel_index;
 wire reset;
 wire frame_begin;
 wire sending_pixels;
 wire sample_pixel;
 
 wire clk6p25m;
 clock_6_25MHz z(basys_clock, clk6p25m); 
 
 Oled_Display Display(.clk(clk6p25m), .reset(reset), .frame_begin(frame_begin), .sending_pixels(sending_pixels),
  .sample_pixel(sample_pixel), .pixel_index(my_pixel_index), .pixel_data(oled_data), .cs(cs), .sdin(sdin), .sclk(sclk), .d_cn(d_cn), .resn(resn), .vccen(vccen),
  .pmoden(pmoden));
           
     wire [11:0] xpos;
     wire [11:0] ypos;
     wire [3:0] zpos;
     wire left, middle, right, new_event;
     
MouseCtl mouse(
      .clk(basys_clock), .rst(0), 
      .xpos(xpos), .ypos(ypos), .zpos(zpos), 
      .left(left), .middle(middle), .right(right), 
      .new_event(new_event),
      .value(0),
      .setx(0), .sety(0),
      .setmax_x(0), .setmax_y(0), 
      .ps2_clk(ps2_clk), .ps2_data(ps2_data)
      );
      
      reg [7:0] x_cursor; 
      reg [6:0] y_cursor;
      
  always @(posedge basys_clock) begin
       x_cursor <= (xpos * 10) / 101; 
       y_cursor <= ypos * 10 / 101;
       
       if (x == x_cursor && y == y_cursor) begin
       oled_data <= 16'b11111_000000_00000;
        if (left == 1) begin
            LED1 <= 1;
            if ((mouse_click & 7'b1111110) && (x>=8&&x<=30&&y>=3&&y<=7)) mouse_click <= (mouse_click | 7'b0000001);
            else if ((mouse_click & 7'b1111101) && (x>=26&&x<=30&&y>=3&&y<=28)) mouse_click <= (mouse_click | 7'b0000010);
            else if ((mouse_click & 7'b1111011) && (x>=26&&x<=30&&y>=28&&y<=48)) mouse_click <= (mouse_click | 7'b0000100);
            else if ((mouse_click & 7'b1110111) && (x>=8&&x<=30&&y>=44&&y<=48)) mouse_click <= (mouse_click | 7'b0001000);
            else if ((mouse_click & 7'b1101111) && (x>=8&&x<=12&&y>=28&&y<=48)) mouse_click <= (mouse_click | 7'b0010000);
            else if ((mouse_click & 7'b1011111) && (x>=8&&x<=12&&y>=3&&y<=28)) mouse_click <= (mouse_click | 7'b0100000);
            else if ((mouse_click & 7'b0111111) && (x>=8&&x<=30&&y>=25&&y<=29)) mouse_click <= (mouse_click | 7'b1000000);
        end
        
        else if (right == 1) begin
            LED2 <= 1;
            if ((mouse_click | 7'b0000001) && (x>=8&&x<=30&&y>=3&&y<=7)) mouse_click <= (mouse_click & 7'b1111110);
            else if ((mouse_click | 7'b0000010) && (x>=26&&x<=30&&y>=3&&y<=28)) mouse_click <= (mouse_click & 7'b1111101);
            else if ((mouse_click | 7'b0000100) && (x>=26&&x<=30&&y>=28&&y<=48)) mouse_click <= (mouse_click & 7'b1111011);
            else if ((mouse_click | 7'b0001000) && (x>=8&&x<=30&&y>=44&&y<=48)) mouse_click <= (mouse_click & 7'b1110111);
            else if ((mouse_click | 7'b0010000) && (x>=8&&x<=12&&y>=28&&y<=48)) mouse_click <= (mouse_click & 7'b1101111);
            else if ((mouse_click | 7'b0100000) && (x>=8&&x<=12&&y>=3&&y<=28)) mouse_click <= (mouse_click & 7'b1011111);
            else if ((mouse_click | 7'b1000000) && (x>=8&&x<=30&&y>=25&&y<=29)) mouse_click <= (mouse_click & 7'b0111111);
        end
        end
//       `else mouse_click = 0;       
  end
    
endmodule
