`timescale 1ns / 1ps

module mouse_program(
    input clk,             
    input [6:0] x,         
    input [5:0] y, 
    input [11:0] xpos,
    input [11:0] ypos,
    input [6:0] mouse_click_input,
    input left, middle, right,
    output reg [15:0] led,       
    output reg [6:0] mouse_click_output,
    output reg [7:0] x_cursor,
    output reg [6:0] y_cursor
    );

    always @(posedge clk) begin
//       x_cursor <= (xpos * 10) / 101; 
//       y_cursor <= (ypos * 10) / 101;
       // for 3x3 cursor
       // TODO BUG out of frame
       x_cursor <= (xpos * 10) / 101;
       y_cursor <= (ypos & 10) / 101;
               
        if (left == 1) begin
            led[0] <= 1;
            led[1] <= 0;
//            if ((mouse_click_input[0] == 0) && (x_cursor>=8&&x_cursor<=30&&y_cursor>=3&&y_cursor<=7)) begin mouse_click_output[0] <= 1; end // set mouse_click_output to 1 if initial is 0 and within the rectangle
//            else if ((mouse_click_input[1] == 0) && (x_cursor>=26&&x_cursor<=30&&y_cursor>=3&&y_cursor<=28)) begin mouse_click_output[1] <= 1; end
//            else if ((mouse_click_input[2] == 0) && (x_cursor>=26&&x_cursor<=30&&y_cursor>=28&&y_cursor<=48)) begin mouse_click_output[2] <= 1; end
//            else if ((mouse_click_input[3] == 0) && (x_cursor>=8&&x_cursor<=30&&y_cursor>=44&&y_cursor<=48)) begin mouse_click_output[3] <= 1; end
//            else if ((mouse_click_input[4] == 0) && (x_cursor>=8&&x_cursor<=12&&y_cursor>=28&&y_cursor<=48)) begin mouse_click_output[4] <= 1; end
//            else if ((mouse_click_input[5] == 0) && (x_cursor>=8&&x_cursor<=12&&y_cursor>=3&&y_cursor<=28)) begin mouse_click_output[5] <= 1; end
//            else if ((mouse_click_input[6] == 0) && (x_cursor>=8&&x_cursor<=30&&y_cursor>=25&&y_cursor<=29)) begin mouse_click_output[6] <= 1; end
            if ((mouse_click_input[0] == 0) && x_cursor == (x>=8&&x<=30) && y_cursor == (y>=3&&y<=7)) begin mouse_click_output[0] <= 1; end // set mouse_click_output to 1 if initial is 0 and within the rectangle
            else if ((mouse_click_input[1] == 0) && x_cursor == (x>=26&&x<=30) && y_cursor == (y>=3&&y<=28)) begin mouse_click_output[1] <= 1; end
            else if ((mouse_click_input[2] == 0) && x_cursor == (x>=26&&x<=30) && y_cursor == (y>=28&&y<=48)) begin mouse_click_output[2] <= 1; end
            else if ((mouse_click_input[3] == 0) && x_cursor == (x>=8&&x<=30) && y_cursor == (y>=44&&y<=48)) begin mouse_click_output[3] <= 1; end
            else if ((mouse_click_input[4] == 0) && x_cursor == (x>=8&&x<=12) && y_cursor == (y>=28&&y<=48)) begin mouse_click_output[4] <= 1; end
            else if ((mouse_click_input[5] == 0) && x_cursor == (x>=8&&x<=12) && y_cursor == (y>=3&&y<=28)) begin mouse_click_output[5] <= 1; end
            else if ((mouse_click_input[6] == 0) && x_cursor == (x>=8&&x<=30) && y_cursor == (y>=25&&y<=29)) begin mouse_click_output[6] <= 1; end
        end
       
        else if (right == 1) begin
            led[1] <= 1;
            led[0] <= 0;
           if ((mouse_click_input[0] == 1) && x_cursor == (x>=8&&x<=30) && y_cursor == (y>=3&&y<=7)) begin mouse_click_output[0] <= 0; end // set mouse_click_output to 1 if initial is 0 and within the rectangle
            else if ((mouse_click_input[1] == 1) && x_cursor == (x>=26&&x<=30) && y_cursor == (y>=3&&y<=28)) begin mouse_click_output[1] <= 0; end
            else if ((mouse_click_input[2] == 1) && x_cursor == (x>=26&&x<=30) && y_cursor == (y>=28&&y<=48)) begin mouse_click_output[2] <= 0; end
            else if ((mouse_click_input[3] == 1) && x_cursor == (x>=8&&x<=30) && y_cursor == (y>=44&&y<=48)) begin mouse_click_output[3] <= 0; end
            else if ((mouse_click_input[4] == 1) && x_cursor == (x>=8&&x<=12) && y_cursor == (y>=28&&y<=48)) begin mouse_click_output[4] <= 0; end
            else if ((mouse_click_input[5] == 1) && x_cursor == (x>=8&&x<=12) && y_cursor == (y>=3&&y<=28)) begin mouse_click_output[5] <= 0; end
            else if ((mouse_click_input[6] == 1) && x_cursor == (x>=8&&x<=30) && y_cursor == (y>=25&&y<=29)) begin mouse_click_output[6] <= 0; end
        end
        else begin
            led[0] <= 0;
            led[1] <= 0;
        end
    end // always
endmodule
