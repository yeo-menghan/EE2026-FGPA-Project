`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: Tricia
//  STUDENT B NAME:
//  STUDENT C NAME: Kai Ning
//  STUDENT D NAME:  Meng Han
//
//////////////////////////////////////////////////////////////////////////////////
module Top_Student (
    input basys_clock, 
    input [15:0] sw,
    output reg [15:0] led,
   // outputs from Oled_Display
    output rgb_cs, rgb_sdin, rgb_sclk, rgb_d_cn, rgb_resn, rgb_vccen, rgb_pmoden,
    inout PS2Data, PS2Clk
   );
   
    integer i;
    wire [15:0] led_temp;
    
    // Clocks
    wire clk6p25; 
    clock_divider clk6p25m(.basys_clock(basys_clock), .m(32'b111), .my_clock_output(clk6p25));
    
    // OLED init
    reg [15:0] oled_data = 16'b0000000000000000; // set to white first 
    wire [15:0] oled_data_temp_oled;
    wire frame_begin; // start from 0
    wire [12:0] pixel_index; // current pixel being updated, goes from 0 to 6143
    wire [6:0] x;
    wire [5:0] y;
    wire sending_pixels;
    wire sample_pixel;
    reg reset = 0;
    Oled_Display unit_oled_one (.clk(clk6p25),.reset(reset),.frame_begin(frame_begin),.sending_pixels(sending_pixels),.sample_pixel(sample_pixel),.pixel_index(pixel_index),.pixel_data(oled_data),
       .cs(rgb_cs), .sdin(rgb_sdin),.sclk(rgb_sclk),.d_cn(rgb_d_cn),.resn(rgb_resn),.vccen(rgb_vccen), .pmoden(rgb_pmoden));
    convertxy convertxy(.pixel_index(pixel_index), .x(x), .y(y));
  
    // Mouse init
    wire [15:0] oled_data_temp_mouse;
    wire [11:0] xpos;
    wire [11:0] ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    // TODO: Implement Mouse middle
    reg [6:0] mouse_click_reg = 7'b0000000; // set everything to off
    wire [6:0] mouse_click;
    assign mouse_click = mouse_click_reg;
    MouseCtl mouse(.clk(basys_clock), .rst(0), .xpos(xpos), .ypos(ypos), .zpos(zpos), .left(left), .middle(middle), .right(right), .new_event(new_event),
             .value(0),.setx(0), .sety(0),.setmax_x(0), .setmax_y(0), .ps2_clk(PS2Clk), .ps2_data(PS2Data));
      
    //7-segment
    wire [3:0] correct_number;
    assign correct_number = 4'b1111;
     
    // OLED
    oled_program oled_program(.clk(clk6p25), .x(x), .y(y), .sw(sw), .mouse_click(mouse_click), .led(led_temp), .oled_data(oled_data_temp_oled), .correct_number(correct_number));    
         
    // Mouse
    mouse_program(.clk(basys_clock), .x(x), .y(y), .xpos(xpos), .ypos(ypos), .left(left), .middle(middle), .right(right),
       .led(led_temp), .oled_data(oled_data_temp_mouse), .mouse_click(mouse_click));
    
//    // OLED + Mouse integration
    wire oled_data_temp_combined;
    assign oled_data_temp_combined = oled_data_temp_mouse || oled_data_temp_oled;
   
    always @ (posedge basys_clock) begin 
        mouse_click_reg <= mouse_click;
//        oled_data <= oled_data_temp_mouse || oled_data_temp_oled;
        oled_data <= oled_data_temp_combined;
        led <= led_temp;    
    end

endmodule