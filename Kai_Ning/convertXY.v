`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2023 00:30:36
// Design Name: 
// Module Name: convertXY
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


module convertXY(input [12:0] pixel_idx, output [6:0] x, output [5:0] y);

    assign x = pixel_idx%96;
    assign y = pixel_idx/96;
    
endmodule

module convertcoord(input xpos, input ypos, output [6:0] x_cursor, output [5:0] y_cursor);

    assign x_cursor = (xpos * 10) / 101; 
    assign y_cursor = ypos * 10 / 101;
    //assign x_cursor = xpos / 43;
    //assign y_cursor = ypos / 64;

endmodule
