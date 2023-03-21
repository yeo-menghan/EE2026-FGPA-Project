`timescale 1ns / 1ps

module mouse_program(
    input clk,             
    input [6:0] x,         
    input [5:0] y, 
    input [11:0] xpos,
    input [11:0] ypos,
    input left, right,
    output reg [15:0] led,       
    output reg [15:0]oled_data,
    output reg [6:0] mouse_click
    );
    reg [7:0] x_cursor; 
    reg [6:0] y_cursor;
    always @(posedge clk) begin
       x_cursor <= (xpos * 10) / 101; 
       y_cursor <= ypos * 10 / 101;
       
       if (x == x_cursor && y == y_cursor) begin
       oled_data <= 16'b11111_000000_00000;
        if (left == 1) begin
            led[0] <= 1;
            if ((mouse_click & 7'b1111110) && (x>=8&&x<=30&&y>=3&&y<=7)) mouse_click <= (mouse_click | 7'b0000001);
            else if ((mouse_click & 7'b1111101) && (x>=26&&x<=30&&y>=3&&y<=28)) mouse_click <= (mouse_click | 7'b0000010);
            else if ((mouse_click & 7'b1111011) && (x>=26&&x<=30&&y>=28&&y<=48)) mouse_click <= (mouse_click | 7'b0000100);
            else if ((mouse_click & 7'b1110111) && (x>=8&&x<=30&&y>=44&&y<=48)) mouse_click <= (mouse_click | 7'b0001000);
            else if ((mouse_click & 7'b1101111) && (x>=8&&x<=12&&y>=28&&y<=48)) mouse_click <= (mouse_click | 7'b0010000);
            else if ((mouse_click & 7'b1011111) && (x>=8&&x<=12&&y>=3&&y<=28)) mouse_click <= (mouse_click | 7'b0100000);
            else if ((mouse_click & 7'b0111111) && (x>=8&&x<=30&&y>=25&&y<=29)) mouse_click <= (mouse_click | 7'b1000000);
        end
        
        else if (right == 1) begin
            led[1] <= 1;
            if ((mouse_click | 7'b0000001) && (x>=8&&x<=30&&y>=3&&y<=7)) mouse_click <= (mouse_click & 7'b1111110);
            else if ((mouse_click | 7'b0000010) && (x>=26&&x<=30&&y>=3&&y<=28)) mouse_click <= (mouse_click & 7'b1111101);
            else if ((mouse_click | 7'b0000100) && (x>=26&&x<=30&&y>=28&&y<=48)) mouse_click <= (mouse_click & 7'b1111011);
            else if ((mouse_click | 7'b0001000) && (x>=8&&x<=30&&y>=44&&y<=48)) mouse_click <= (mouse_click & 7'b1110111);
            else if ((mouse_click | 7'b0010000) && (x>=8&&x<=12&&y>=28&&y<=48)) mouse_click <= (mouse_click & 7'b1101111);
            else if ((mouse_click | 7'b0100000) && (x>=8&&x<=12&&y>=3&&y<=28)) mouse_click <= (mouse_click & 7'b1011111);
            else if ((mouse_click | 7'b1000000) && (x>=8&&x<=30&&y>=25&&y<=29)) mouse_click <= (mouse_click & 7'b0111111);        end
        end
    end
endmodule
