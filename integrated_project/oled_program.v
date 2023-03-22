`timescale 1ns / 1ps

module oled_program(
    input clk,             
    input [6:0] x,         
    input [5:0] y, 
    input [15:0] sw,
    input [6:0] mouse_click, 
    input [6:0] x_mouse,
    input [5:0] y_mouse,
    output reg [15:0]led,       
    output reg [15:0]oled_data,
    output reg [3:0]correct_number
    );
    integer i;
        
    wire entire_screen;
    assign entire_screen = (x>=0 && x <=95 && y>=0 && y <=63);
    
    wire border_horizontal, border_vertical, border;
    assign border_horizontal = (x>=0&&x<=57&&y>=57&&y<=59); // horizontal line
    assign border_vertical = (x>=57&&x<=59&&y>=0&&y<=57); // vertical line
    assign border = border_horizontal || border_vertical;
   
    wire [6:0] oled_seg;
    // segments are differ from outline by 1 pixel to prevent overlap
    assign oled_seg[0] = (x>=9&&x<=29&&y>=4&&y<=6);
    assign oled_seg[1] = (x>=27&&x<=29&&y>=4&&y<=27);
    assign oled_seg[2] = (x>=27&&x<=29&&y>=29&&y<=47);
    assign oled_seg[3] = (x>=9&&x<=29&&y>=45&&y<=47);
    assign oled_seg[4] = (x>=9&&x<=11&&y>=29&&y<=47);
    assign oled_seg[5] = (x>=9&&x<=11&&y>=4&&y<=27);
    assign oled_seg[6] = (x>=9&&x<=29&&y>=26&&y<=28);
    
    wire [5:0] squares;
    assign squares[0] = (x>=27&&x<=29&&y>=4&&y<=6);
    assign squares[1] = (x>=27&&x<=29&&y>=27&&y<=29);
    assign squares[2] = (x>=27&&x<=29&&y>=45&&y<=47);
    assign squares[3] = (x>=9&&x<=11&&y>=4&&y<=6);
    assign squares[4] = (x>=9&&x<=11&&y>=27&&y<=29);
    assign squares[5] = (x>=9&&x<=11&&y>=45&&y<=47);
    
    // 7-segment outlines (hard-coded)
    wire [6:0] oled_seg_outline;
    assign oled_seg_outline[0] = (x>=8&&x<=30&&(y==3||y==7));
    assign oled_seg_outline[1] = ((x==26||x==30)&&y>=3&&y<=28);
    assign oled_seg_outline[2] = ((x==26||x==30)&&y>=28&&y<=48);
    assign oled_seg_outline[3] = (x>=8&&x<=30&&(y==44||y==48));
    assign oled_seg_outline[4] = ((x==8||x==12)&&y>=28&&y<=48);
    assign oled_seg_outline[5] = ((x==8||x==12)&&y>=3&&y<=28);
    assign oled_seg_outline[6] = (x>=8&&x<=30&&(y==25||y==29));   
    wire oled_seg_outline_combined;
    assign oled_seg_outline_combined = oled_seg_outline[0] || oled_seg_outline[1] || oled_seg_outline[2] || oled_seg_outline[3] || oled_seg_outline[4] || oled_seg_outline[5] || oled_seg_outline[6];
     
    // numbers in 7-bit format to compare with mouse_click
    wire num0, num1, num2, num3, num4, num5, num6, num7, num8, num9;
    assign num0 = 7'b0;
    assign num1 = 7'b0000110;
    assign num2 = 7'b1011011;
    assign num3 = 7'b1001111;
    assign num4 = 7'b1100110;
    assign num5 = 7'b1101101;
    assign num6 = 7'b1111101;
    assign num7 = 7'b0000111;
    assign num8 = 7'b1111111;
    assign num9 = 7'b1100111;
       
    // assign colours for the oled screen
    wire [15:0] green, white, black, red;
    assign green = 16'b00000_111111_00000;
    assign red = 16'b11111_000000_00000;
    assign black = 16'b00000_000000_00000;
    assign white = 16'b11111_111111_11111;
    
    always @ (posedge clk) begin
        oled_data = black;        
        
        // read from right to left
        // check number
           // if 0, turn that oled_seg to black
           // if 1, turn that oled_seg to white
        // bit-shift left by 1
        
      if(x==x_mouse || y==y_mouse) begin
          oled_data = 16'b1111_000000_00000;
      end
      
      else begin
        for(i = 0; i < 7; i = i+1) begin    
            if(mouse_click[i] == 0) begin
                if(oled_seg[i]) begin
                    oled_data = black;
                end
                case(i)
                    0: if(mouse_click[1] == 1 || mouse_click[5] == 1) begin if(squares[0] || squares[5]) begin oled_data = white; end end
                    1: if(mouse_click[0] == 1 || mouse_click[2] == 1 || mouse_click[6] == 1) begin if (squares[0] || squares[1]) begin oled_data = white; end end
                    2: if(mouse_click[1] == 1 || mouse_click[3] == 1 || mouse_click[6] == 1) begin if(squares[1] || squares[2]) begin oled_data = white; end end
                    3: if(mouse_click[2] == 1 || mouse_click[4] == 1) begin if(squares[2] || squares[5]) begin oled_data = white; end end
                    4: if(mouse_click[3] == 1 || mouse_click[5] == 1 || mouse_click[6] == 1) begin if(squares[4] || squares[5]) begin oled_data = white; end end
                    5: if(mouse_click[0] == 1 || mouse_click[4] == 1 || mouse_click[6] == 1) begin if(squares[3] || squares[4]) begin oled_data = white; end end
                    6: if(mouse_click[1] == 1 || mouse_click[2] == 1 || mouse_click[4] == 1 || mouse_click[5] == 1) begin if(squares[1] || squares[4]) begin oled_data = white; end end
                endcase
            end
            else if (mouse_click[i] == 1) begin
                if(oled_seg[i]) begin
                    oled_data = white;
                end
            end  
        end
        // border will always be turned on
        if (border) begin // border on
           oled_data = green;
        end
        // oled_seg outline will always be turned on
        if(oled_seg_outline_combined) begin
           oled_data = white;
        end
      end
        // check correct number, return the number
        case(mouse_click) 
            num0: correct_number = 4'b0000;
            num1: correct_number = 4'b0001;
            num2: correct_number = 4'b0010;
            num3: correct_number = 4'b0011;
            num4: correct_number = 4'b0100;
            num5: correct_number = 4'b0101;
            num6: correct_number = 4'b0110;
            num7: correct_number = 4'b0111;
            num8: correct_number = 4'b1000;
            num9: correct_number = 4'b1001;
            default: correct_number = 4'b1111;
        endcase
                
       
        if(sw[15] == 1) begin // set switch 15 as the reset switch
            if (entire_screen) begin
             oled_data = black;
            end
        end  
    end // always @
endmodule
