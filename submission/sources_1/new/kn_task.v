`timescale 1ns / 1ps

// BUG: green screen shown instead of any thing

module kn_task(
    input sys_clk,
    input left, right, middle, new_event,
    input [6:0] x,         
   input [5:0] y, 
   input [11:0] xpos,
   input [11:0] ypos,
    output reg [15:0] oled_data,
    output reg [7:0] x_cursor,
    output reg [6:0] y_cursor
);

 reg state; 
 wire middle_pressed;
 reg middle_last;

 assign middle_pressed = (middle_last == 0) && (middle == 1);
 
 always @ (posedge sys_clk) begin
    middle_last <= middle;
    if (middle_pressed) begin
    state <= ~state;
 end
 end
 
  always @ (posedge sys_clk) begin
   
  if (state) begin
     x_cursor <= (xpos * 10) / 101; 
     y_cursor <= ypos * 10 / 101;
     if (x == x_cursor && y == y_cursor) begin
           oled_data <= 16'b11111_000000_00000;
     end
     else begin
           oled_data <= 16'b00000_00000_00000;
     end
    end
     
  else begin
     x_cursor <= (xpos * 10) / 103 + 1 ; 
     y_cursor <= ypos * 10 / 104 + 1;
     
     if(x>=x_cursor-1 && x<=x_cursor+1 && y>= y_cursor-1 && y <= y_cursor+1) begin
           oled_data = 16'b00000_111111_00000;
     end
     else begin
           oled_data <= 16'b00000_00000_00000;
    end
  end
  end
 endmodule