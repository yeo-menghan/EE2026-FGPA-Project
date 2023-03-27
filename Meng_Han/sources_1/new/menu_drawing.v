`timescale 1ns / 1ps

module menu_drawing(
    input clk, [12:0] pixel_idx,
    output reg [15:0] oled_data
    );
 
 reg[15:0] r [0:6143];
 initial begin
    // replace drawing.mem with appropriate drawing after testing
     $readmemh("drawing.mem", r);
 end
 always @ (posedge clk) begin 
    oled_data = r[pixel_idx];
 end
   
endmodule