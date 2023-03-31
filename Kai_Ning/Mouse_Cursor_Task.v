`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2023 09:51:13
// Design Name: 
// Module Name: Mouse_Cursor_Task
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
module Test_Mouse_Cursor (
input basys_clock, 
output cs, sdin, sclk, d_cn, resn, vccen, pmoden,
output LED1,
inout ps2_clk, ps2_data
);

 wire clk6p25m;
 clock_6_25MHz z(basys_clock, clk6p25m); 

 reg [15:0] oled_data;
 wire [12:0] my_pixel_index;
 wire reset;
 wire frame_begin;
 wire sending_pixels;
 wire sample_pixel;
 
 Oled_Display Cursor(.clk(clk6p25m), .reset(reset), .frame_begin(frame_begin), .sending_pixels(sending_pixels),
  .sample_pixel(sample_pixel), .pixel_index(my_pixel_index), .pixel_data(oled_data), .cs(cs), .sdin(sdin), .sclk(sclk), .d_cn(d_cn), .resn(resn), .vccen(vccen),
  .pmoden(pmoden));
 
 wire [7:0] x_coord;
 wire [6:0] y_coord;
 wire [11:0] xpos;
 wire [11:0] ypos;
 wire [3:0] zpos;
 wire left, middle, right, new_event;
 
    assign x_coord = my_pixel_index % 96;
    assign y_coord = my_pixel_index / 96;

 MouseCtl control(
 .clk(basys_clock), .rst(0), 
 .xpos(xpos), .ypos(ypos), .zpos(zpos), 
 .left(left), .middle(middle), .right(right), 
 .new_event(new_event),
 .value(0),
 .setx(0), .sety(0),
 .setmax_x(0), .setmax_y(0), 
 .ps2_clk(ps2_clk), .ps2_data(ps2_data)
 );
      
 reg state; 
 reg [7:0] x_cursor; 
 reg [6:0] y_cursor;
 
 wire middle_pressed;
 reg middle_last;
 assign middle_pressed = (middle_last == 0) && (middle == 1);
 
 always @ (posedge basys_clock) begin
    middle_last <= middle;
    if (middle_pressed) begin
    state <= ~state;
 end
 end
 
  always @ (posedge basys_clock) begin
   
  if (state) begin
     x_cursor <= (xpos * 10) / 101; 
     y_cursor <= ypos * 10 / 101;
     if (x_coord == x_cursor && y_coord == y_cursor) begin
           oled_data <= 16'b11111_000000_00000;
     end
     else begin
           oled_data <= 16'b00000_00000_00000;
     end
    end
     
  else begin
     x_cursor <= (xpos * 10) / 103 + 1 ; 
     y_cursor <= ypos * 10 / 104 + 1;
     
     if(x_coord>=x_cursor-1 && x_coord<=x_cursor+1 && y_coord >= y_cursor-1 && y_coord <= y_cursor+1) begin
           oled_data = 16'b00000_111111_00000;
     end
 
     else begin
           oled_data <= 16'b00000_00000_00000;
  end
   
  end
  end
 endmodule