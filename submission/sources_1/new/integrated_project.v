`timescale 1ns / 1ps
// BUG: cannot press the last if-else pertaining to the left == 1
    // trying posedge left and right

module integrated_project(
    input clk, clk10k, clk20k,            
    input [6:0] x,         
    input [5:0] y, 
    input [11:0] xpos,
    input [11:0] ypos,
    input left, right,
    input [15:0] sw,
    input [11:0] MIC_IN, 
    output reg [15:0]led,       
    output reg [15:0]oled_data,
    output reg [7:0] x_cursor,
    output reg [6:0] y_cursor,
    output reg [3:0]an, 
    output reg [6:0]seg,
    output dp
    );
    integer i;
    
    // Mouse capabilities
    reg [6:0] mouse_click_reg = 7'b0000000;
    wire [6:0] mouse_click;
    assign mouse_click =  mouse_click_reg; // mouse_click will take on the value of mouse_click_reg 
    
    // Audio in
    wire [3:0] an_w;
    wire [6:0] seg_w;
    reg [3:0] correct_number;
    wire [3:0] correct_number_w;
    assign correct_number_w = correct_number;
    wire [1:0] control_counter;
    wire [3:0] value1; // value 1 from oled
    wire [3:0] value2; // value 2 from oled
    wire [4:0] vol; // from function passed from vol
    wire [3:0] digit; // mux of number from oled and volume
    assign digit = (control_counter == 0) ? vol : ((control_counter == 1) ? value1 : value2);
    
    // Audio Programme
    volume_lvl volume(.basys_clock(clk), .MIC_IN(MIC_IN), .audio_level(vol));
    assigning assignment(.num(correct_number_w), .value1(value1), .value2(value2));
    control_counter countercontrol(.control_clock(clk10k), .control_counter(control_counter));
    an_control ancontrol(.control_counter(control_counter), .an(an_w), .dp(dp));
    seg_control seg_control(.digit(digit), .seg(seg_w));
//    always@(vol) begin
//       case(vol)
//           4'd1:
//           led <= 9'b000000001;
//           4'd2:
//           led <= 9'b000000011;
//           4'd3:
//           led <= 9'b000000111;
//           4'd4:
//           led <= 9'b000001111;
//           4'd5:
//           led <= 9'b000011111;
//           4'd6:
//           led <= 9'b000111111;
//           4'd7:
//           led <= 9'b001111111;
//           4'd8:
//           led <= 9'b011111111;
//           4'd9:
//           led <= 9'b111111111;
//        endcase
//    end 
    
    // screen & borders
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
    wire [6:0] num0, num1, num2, num3, num4, num5, num6, num7, num8, num9;
    assign num0 = 7'b0111111;
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
    
    reg[1:0] buffer;
    
    always @ (*) begin
        case(vol)
               4'd1:
               led <= 9'b000000001;
               4'd2:
               led <= 9'b000000011;
               4'd3:
               led <= 9'b000000111;
               4'd4:
               led <= 9'b000001111;
               4'd5:
               led <= 9'b000011111;
               4'd6:
               led <= 9'b000111111;
               4'd7:
               led <= 9'b001111111;
               4'd8:
               led <= 9'b011111111;
               4'd9:
               led <= 9'b111111111;
            endcase
        an <= an_w;
        seg <= seg_w;
      
        oled_data = black;        
        x_cursor <= (xpos * 10) / 101; 
        y_cursor <= (ypos * 10) / 101;
        
//         cursor click control
        if (left == 1) begin
            if ((mouse_click_reg[0] == 0) && (x_cursor>=8&&x_cursor<=30 && y_cursor>=3&&y_cursor<=7)) begin 
                mouse_click_reg[0] <= 1; 
            end 
            else if ((mouse_click_reg[1] == 0) && (x_cursor>=26&&x_cursor<=30 && y_cursor>=3&&y_cursor<=28)) begin 
                mouse_click_reg[1] <= 1; 
            end
            else if ((mouse_click_reg[2] == 0) && (x_cursor>=26&&x_cursor<=30 && y_cursor>=28&&y_cursor<=48)) begin 
                mouse_click_reg[2] <= 1; 
            end
            else if ((mouse_click_reg[3] == 0) && (x_cursor>=8&&x_cursor<=30 && y_cursor>=44&&y_cursor<=48)) begin 
                mouse_click_reg[3] <= 1; 
            end
          
            else if ((mouse_click_reg[6] == 0) && (x_cursor>=9&&x_cursor<=29 && y_cursor>=26&&y_cursor<=28)) begin 
                mouse_click_reg[6] <= 1; 
            end
             else if ((mouse_click_reg[5] == 0) && (x_cursor>=8&&x_cursor<=12 && y_cursor>=3&&y_cursor<=28)) begin 
                       mouse_click_reg[5] <= 1; 
           end
             else if ((mouse_click_reg[4] == 0) && (x_cursor>=8&&x_cursor<=12 && y_cursor>=28&&y_cursor<=48)) begin 
                         mouse_click_reg[4] <= 1; 
             end          
            else begin buffer[0] <= 1; end
        end
        
        else if (right == 1) begin
            if ((mouse_click_reg[0] == 1) && x_cursor>=8&&x_cursor<=30 && y_cursor>=3&&y_cursor<=7) begin mouse_click_reg[0] <= 0; end 
            else if ((mouse_click_reg[1] == 1) && x_cursor>=26&&x_cursor<=30 && y_cursor>=3&&y_cursor<=28) begin mouse_click_reg[1] <= 0; end
            else if ((mouse_click_reg[2] == 1) && x_cursor>=26&&x_cursor<=30 && y_cursor>=28&&y_cursor<=48) begin mouse_click_reg[2] <= 0; end
            else if ((mouse_click_reg[3] == 1) && x_cursor>=8&&x_cursor<=30 && y_cursor>=44&&y_cursor<=48) begin mouse_click_reg[3] <= 0; end
            else if ((mouse_click_reg[4] == 1) && x_cursor>=8&&x_cursor<=12 && y_cursor>=28&&y_cursor<=48) begin mouse_click_reg[4] <= 0; end
            else if ((mouse_click_reg[5] == 1) && x_cursor>=8&&x_cursor<=12 && y_cursor>=3&&y_cursor<=28) begin mouse_click_reg[5] <= 0; end
            else if ((mouse_click_reg[6] == 1) && x_cursor>=9&&x_cursor<=29 && y_cursor>=26&&y_cursor<=28) begin mouse_click_reg[6] <= 0; end                  
        end
      
        // cursor control
        if(x == x_cursor && y == y_cursor) begin // center dot of the cursor
          oled_data = 16'b11111_000000_00000;
        end 
        else if (x >= x_cursor-1 && x <= x_cursor+1 && y == y_cursor+1) begin
        // top row of the 3x3 cursor
            oled_data = 16'b11111_000000_00000;
        end
        else if (x >= x_cursor-1 && x <= x_cursor+1 && y == y_cursor-1) begin
        // bottom row of the 3x3 cursor
            oled_data = 16'b11111_000000_00000;
        end
        else if (x == x_cursor+1 && y >= y_cursor-1 && y <= y_cursor+1) begin
        // left column of the 3x3 cursor
            oled_data = 16'b11111_000000_00000;
        end
        else if (x== x_cursor-1 && y >= y_cursor-1 && y <= y_cursor+1) begin
        // right column of the 3x3 cursor
            oled_data = 16'b11111_000000_00000;
        end
      else begin
        for(i = 0; i < 7; i = i+1) begin    
            if(mouse_click[i] == 0) begin // 0 == black
                if(oled_seg[i]) begin
                    oled_data = black;
                end
            end  
        end
        for (i = 0; i < 7; i = i+1) begin
            if (mouse_click[i] == 1) begin // 1 == white
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
            num0: correct_number = 4'd0;
            num1: correct_number = 4'd1;
            num2: correct_number = 4'd2;
            num3: correct_number = 4'd3;
            num4: correct_number = 4'd4;
            num5: correct_number = 4'd5;
            num6: correct_number = 4'd6;
            num7: correct_number = 4'd7;
            num8: correct_number = 4'd8;
            num9: correct_number = 4'd9;
            default: correct_number = 4'd10;
        endcase       
        // BUG: multiple drivers for switch 15? 
        if(sw[15] == 1 && correct_number_w <= 4'd9) begin
            led[15] <= 1;
        end
        else begin
            led[15] <= 0;
        end
    end // always @
endmodule
