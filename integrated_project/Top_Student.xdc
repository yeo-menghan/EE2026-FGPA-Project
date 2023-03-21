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
    output rgb_cs, rgb_sdin, rgb_sclk, rgb_d_cn, rgb_resn, rgb_vccen, rgb_pmoden 
   );
   
    integer i;
   
    // OLED init
    wire [15:0] led_temp;
    reg [15:0] oled_data = 16'b0000000000000000; // set to white first 
    wire [15:0] oled_data_temp;
    wire frame_begin; // start from 0
    wire [12:0] pixel_index; // current pixel being updated, goes from 0 to 6143
    wire [6:0] x;
    wire [5:0] y;
    wire sending_pixels;
    wire sample_pixel;
    reg reset = 0;

    // Clocks
    wire clk6p25; 
    clock_divider clk6p25m(.basys_clock(basys_clock), .m(32'b111), .my_clock_output(clk6p25));
    
    // Mouse 
    reg mouse_click;
    
    // OLED
    Oled_Display unit_oled_one (.clk(clk6p25),.reset(reset),.frame_begin(frame_begin),.sending_pixels(sending_pixels),.sample_pixel(sample_pixel),.pixel_index(pixel_index),.pixel_data(oled_data),
    .cs(rgb_cs), .sdin(rgb_sdin),.sclk(rgb_sclk),.d_cn(rgb_d_cn),.resn(rgb_resn),.vccen(rgb_vccen), .pmoden(rgb_pmoden));
    convertxy convertxy(.pixel_index(pixel_index), .x(x), .y(y));
    oled_program oled_program(.clk(clk6p25), .x(x), .y(y), .sw(sw), .mouse_click(mouse_click), .led(led_temp), .oled_data(oled_data_temp));    
    
    
    always @ (posedge basys_clock) begin 
        for(i = 0; i < 7; i=i+1) begin
            mouse_click = i;
        end
        oled_data <= oled_data_temp; // update oled_data
        led <= led_temp;
        
    end

endmodule