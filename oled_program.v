`timescale 1ns / 1ps

module oled_program(
    input clk,             
    input [7:0] x,         
    input [6:0] y, 
    input [15:0] sw,
    output reg [15:0]led,       
    output reg [15:0]oled_data
    );
    reg border_on, num1_on, num2_on, num3_on;   
    wire entire_screen;
    assign entire_screen = (x>=0 && x <=95 && y>=0 && y <=63);
    wire border_horizontal, border_vertical, border;
    assign border_horizontal = (x>=0&&x<=57&&y>=57&&y<=59); // horizontal line
    assign border_vertical = (x>=57&&x<=59&&y>=0&&y<=57); // vertical line
    assign border = border_horizontal || border_vertical;
   
    // using 7-segment logic to create numbers
    wire [6:0] oled_seg;
    assign oled_seg[0] = (x>=10&&x<=30&&y>=5&&y<=7);
    assign oled_seg[1] = (x>=28&&x<=30&&y>=7&&y<=27);
    assign oled_seg[2] = (x>=28&&x<=30&&y>=28&&y<=48);
    assign oled_seg[3] = (x>=10&&x<=30&&y>=46&&y<=48);
    assign oled_seg[4] = (x>=10&&x<=12&&y>=28&&y<=48);
    assign oled_seg[5] = (x>=10&&x<=12&&y>=7&&y<=27);
    assign oled_seg[6] = (x>=10&&x<=30&&y>=27&&y<=29);
    
    // numbers 1, 2 & 3
    wire num1, num2, num3;
    assign num1 = oled_seg[1] || oled_seg[2];
    assign num2 = oled_seg[0] || oled_seg[1] || oled_seg[3] || oled_seg[4] || oled_seg[6];
    assign num3 = oled_seg[0] || oled_seg[1] || oled_seg[2] || oled_seg[3] || oled_seg[6];
   
    // assign colours for the oled screen
    wire [15:0] green, white, black, red;
    assign green = 16'b00000_111111_00000;
    assign red = 16'b11111_000000_00000;
    assign black = 16'b00000_000000_00000;
    assign white = 16'b11111_111111_11111;
    
    always @ (posedge clk) begin
        if(sw[15] == 0) begin // set switch 15 as the kill switch
            border_on = sw[8];
            num1_on = sw[1];
            num2_on = sw[2];
            num3_on = sw[3];
        end
        
        oled_data = black;
        
        if (border_on == 1 && border) begin // border on
            oled_data = green;
        end
        else if(border_on == 0 && border) begin // border off
            oled_data = black;
        end
        
        // TODO: turn on 1 switch and not be affected by the other 2 switches
        if (num1_on == 1 && num2_on == 0 & num3_on == 0 && num1) begin
            oled_data = white;
        end      
        if (num2_on == 1 && num1_on == 0 && num3_on == 0 && num2) begin
            oled_data = white;
           
        end
        if(num3_on == 1 && num1_on == 0 && num2_on == 0 && num3) begin
            oled_data = white;
//            if(num1_on == 1 || num2_on == 1) begin
//                num1_on = 0;
//                num2_on = 0;
//            end
        end
    end
endmodule
