`timescale 1ns / 1ps

module oled_program(
    input clk,             
    input [6:0] x,         
    input [5:0] y, 
    input [15:0] sw,
    input [3:0] mouse_click, // mouse_click will provide a range from 0-6 and correspond to the oled_seg
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
    assign oled_seg[0] = (x>=8&&x<=30&&y>=3&&y<=7);
    assign oled_seg[1] = (x>=26&&x<=30&&y>=3&&y<=28);
    assign oled_seg[2] = (x>=26&&x<=30&&y>=28&&y<=48);
    assign oled_seg[3] = (x>=8&&x<=30&&y>=44&&y<=48);
    assign oled_seg[4] = (x>=8&&x<=12&&y>=28&&y<=48);
    assign oled_seg[5] = (x>=8&&x<=12&&y>=3&&y<=28);
    assign oled_seg[6] = (x>=8&&x<=30&&y>=25&&y<=29);
    
    // 7-segment outlines (hard-coded)
    wire [6:0] oled_seg_outline;
    assign oled_seg_outline[0] = (x>=8&&x<=30&&(y==3||y==7));
    assign oled_seg_outline[1] = ((x==26||x==30)&&y>=3&&y<=27);
    assign oled_seg_outline[2] = ((x==26||x==30)&&y>=28&&y<=48);
    assign oled_seg_outline[3] = (x>=8&&x<=30&&(y==44||y==48));
    assign oled_seg_outline[4] = ((x==8||x==12)&&y>=28&&y<=48);
    assign oled_seg_outline[5] = ((x==8||x==12)&&y>=3&&y<=27);
    assign oled_seg_outline[6] = (x>=8&&x<=30&&(y==25||y==29));   
    wire oled_seg_outline_combined;
    assign oled_seg_outline_combined = oled_seg_outline[0] || oled_seg_outline[1] || oled_seg_outline[2] || oled_seg_outline[3] || oled_seg_outline[4] || oled_seg_outline[5] || oled_seg_outline[6];
     
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
        if(sw[15] == 1) begin // set switch 15 as the reset switch
            if (entire_screen) begin
                oled_data = black;
            end
        end  
        
        oled_data = black;
        
        // border will always be turned on
        if (border) begin // border on
            oled_data = green;
        end
        
        // oled_seg outline will always be turned on
        if(oled_seg_outline_combined) begin
            oled_data = white;
        end
        
        // switch on based on the clicks
        // possible bug: only 1 light up at a time? Need to ensure that the value of mouse_click can be altered using the mouse
        // convert this to a 7 bit binary signal and loop through to check whether the click is registered within the system?
        case(mouse_click)
            3'b000: begin // correspond to oled_seg[0]
                if(oled_seg[0]) begin
                    oled_data = white;
                end
            end
            3'b001: begin
                if(oled_seg[1]) begin
                    oled_data = white;
                end
            end
            3'b010: begin
                if(oled_seg[2]) begin
                    oled_data = white;
                end
            end
            3'b011: begin
                if(oled_seg[3]) begin
                    oled_data = white;
                end
            end
            3'b100: begin
                if(oled_seg[4]) begin
                    oled_data = white;
                end
            end
            3'b101: begin
                if(oled_seg[5]) begin
                    oled_data = white;
                end
            end
            3'b110: begin
                if(oled_seg[6]) begin
                    oled_data = white;
                end
            end  
        endcase
     
    end
endmodule
