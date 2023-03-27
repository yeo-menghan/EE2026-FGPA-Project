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
    input basys_clk, 
    input [15:0] sw,
    input btnL, btnR, btnC, btnU, btnD,
//    input  J_MIC3_Pin3_R, J_MIC3_Pin3_L,  // Connect from this signal to Audio_Capture.v
//    output J_MIC3_Pin1_R, J_MIC3_Pin1_L,  // Connect to this signal from Audio_Capture.v
//    output J_MIC3_Pin4_R, J_MIC3_Pin4_L,   // Connect to this signal from Audio_Capture.v
    output reg [15:0] led,
    output reg [3:0] an,
    output reg [6:0] seg,
    output rgb_cs, rgb_sdin, rgb_sclk, rgb_d_cn, rgb_resn, rgb_vccen, rgb_pmoden,
    inout PS2Data, PS2Clk
   );
   
   // LEDs, anodes, segments and buttons
    wire [15:0] led_temp;
    wire [3:0] an_temp;
    wire [6:0] seg_temp;
    wire btnC_w, btnU_w, btnD_w, btnL_w, btnR_w;

    // Clocks TODO: change to frequency input instead
    wire clk6p25, clk25M; 
    clock_divider clk6p25m(.sys_clk(basys_clk), .freq(6250000), .clk_output(clk6p25));
    clock_divider clk25Mm (.sys_clk(basys_clk), .freq(25000000), .clk_output(clk25M));
    // OLED init
    wire [15:0] oled_data;
    wire [12:0] pixel_index; // current pixel being updated, goes from 0 to 6143
    wire [6:0] x;
    wire [5:0] y;
    wire frame_begin, sending_pixels, sample_pixel;
    Oled_Display unit_oled_one (.clk(clk6p25),.reset(0),.frame_begin(frame_begin),.sending_pixels(sending_pixels),.sample_pixel(sample_pixel),.pixel_index(pixel_index),.pixel_data(oled_data),
       .cs(rgb_cs), .sdin(rgb_sdin),.sclk(rgb_sclk),.d_cn(rgb_d_cn),.resn(rgb_resn),.vccen(rgb_vccen), .pmoden(rgb_pmoden));
    
    convertxy convertxy(.pixel_index(pixel_index), .x(x), .y(y));
  
    // Mouse init
    wire left_w, right_w, middle_w;
    wire [11:0] xpos;
    wire [11:0] ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    MouseCtl mouse(.clk(basys_clk), .rst(0), .xpos(xpos), .ypos(ypos), .zpos(zpos), .left(left), .middle(middle), .right(right), .new_event(new_event),
             .value(0),.setx(0), .sety(0),.setmax_x(0), .setmax_y(0), .ps2_clk(PS2Clk), .ps2_data(PS2Data));
      
    // Mouse    
//    mouse_program(.clk(basys_clock), .x(x), .y(y), .xpos(xpos), .ypos(ypos), .mouse_click_input(mouse_click_input), .left(left), .middle(middle), .right(right),
//          .led(led_temp), .mouse_click_output(mouse_click_output), .x_cursor(x_cursor), .y_cursor(y_cursor));
    
    // buttons debouncer
    debouncer debouncer_C(.button(btnC), .clk(clk25M), .pulse(btnC_w));
    debouncer debouncer_U(.button(btnU), .clk(clk25M), .pulse(btnU_w));
    debouncer debouncer_D(.button(btnD), .clk(clk25M), .pulse(btnD_w));
    debouncer debouncer_L(.button(btnL), .clk(clk25M), .pulse(btnL_w));
    debouncer debouncer_R(.button(btnR), .clk(clk25M), .pulse(btnR_w));
    debouncer debouncer_LeftMouse(.button(left), .clk(clk25M), .pulse(left_w));
    debouncer debouncer_RightMouse(.button(right), .clk(clk25M), .pulse(right_w));
    debouncer debouncer_MiddleMouse(.button(middle), .clk(clk25M), .pulse(middle_w));


        
   app_mux app_mux(
        .sys_clk(basys_clk), .clk6p25(clk6p25), .clk25M(clk25M),
        .btnC(btnC_w), .btnU(btnU_w), .btnD(btnD_w), .btnL(btnL_w), .btnR(btnR_w), 
        .sw(sw), .x(x), .y(y), .pixel_idx(pixel_index), .xpos(xpos), .ypos(ypos),
         .left(left_w), .middle(middle_w), .right(right_w), .new_event(new_event), 
         .oled_data(oled_data), .an(an_temp), .seg(seg_temp), .led(led_temp)
   );
         
    always @ (posedge basys_clk) begin 
        an <= an_temp;
        seg <= seg_temp;
        led <= led_temp;    
    end

endmodule