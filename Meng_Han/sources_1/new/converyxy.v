`timescale 1ns / 1ps
/*
    96x64 = 6144 = 0b1100000000000 (13 bits)
*/

module convertxy(input [12:0] pixel_index, output [6:0] x, output [5:0] y);
// TODO
//    assign x = 95 - (pixel_index%96); // flip the x and y values around to suit the oled display
//    assign  y  = 95 - (pixel_index/96);
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
endmodule
