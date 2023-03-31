`timescale 1ns / 1ps

module menu_gameover(
    input clk, [12:0] pixel_idx,
    output reg [15:0] oled_data
    );
 
 reg[15:0] r [0:6143];
 initial begin
     $readmemh("gameover.mem", r);
 end
 always @ (posedge clk) begin 
    oled_data = r[pixel_idx];
 end
   
endmodule