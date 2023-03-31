`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
        input basys_clock,     // 100MHz clock                        
        input MISO,            // J_MIC3_Pin3, serial mic input
        //        input sw1,             //switch 1  //still need?
        output clk_samp,       // J_MIC3_Pin1
        output sclk,          // J_MIC3_Pin4, MIC3 serial clock
        //        output [11:0] led,
        =        output [3:0] an,
        output [6:0] seg
        input [15:0] sw,
        output reg [15:0] led,
        // outputs from Oled_Display
        output rgb_cs, rgb_sdin, rgb_sclk, rgb_d_cn, rgb_resn, rgb_vccen, rgb_pmoden 
    );
    
//    audio_input_testing yy(.basys_clock(basys_clock), .J_MIC_Pin3(MISO), .sw1(sw1), .J_MIC_Pin1(clk_samp), .J_MIC_Pin4(sclk), .LED(led));
    

    // for OLED display
    wire [15:0] led_temp;
    reg [15:0] oled_data = 16'b0000000000000000; // set to white first 
    wire [15:0] oled_data_temp;
    wire frame_begin; // start from 0
    wire [12:0] pixel_index; // current pixel being updated, goes from 0 to 6143
    wire [7:0] x;
    wire [6:0] y;
    wire sending_pixels;
    wire sample_pixel;
    wire clk6p25; // try to phase this out and be more specific with naming conventions
    reg reset = 0;

    led_display dd( .basys_clock(basys_clock), .MISO(MISO), .sclk(sclk), .clk_samp(clk_samp), .an(an), .seg(seg), .led(led) );

    // Meng Han: Oled display
    clock_divider clk6p25m(.basys_clock(basys_clock), .m(32'b111), .my_clock_output(clk6p25));
    Oled_Display unit_oled_one (.clk(clk6p25),.reset(reset),.frame_begin(frame_begin),.sending_pixels(sending_pixels),.sample_pixel(sample_pixel),.pixel_index(pixel_index),.pixel_data(oled_data),
    // tied to constraints and outputs
    .cs(rgb_cs), .sdin(rgb_sdin),.sclk(rgb_sclk),.d_cn(rgb_d_cn),.resn(rgb_resn),.vccen(rgb_vccen), .pmoden(rgb_pmoden));
    convertxy convertxy(.pixel_index(pixel_index), .x(x), .y(y));
    oled_program oled_program(.clk(clk6p25), .x(x), .y(y), .sw(sw), .led(led_temp), .oled_data(oled_data_temp));

//    wire clock_20k, clock_10;
//    wire [11:0] MIC_in;           // 12-bit audio sample data  
    
//    Audio_Input pp(basys_clock, clock_20k, J_MIC_Pin3, J_MIC_Pin1, J_MIC_Pin4, MIC_in);
   
//    custom_clock twenty_thousand(basys_clock, 2499, clock_20k);
//    custom_clock ten(basys_clock, 4999999, clock_10);
    
//    always @(posedge basys_clock)
//    begin
//        if (sw1) 
//        begin
//            led <= clock_10 ? MIC_in : led;
//        end
//        else begin
//            led <= clock_20k ? MIC_in : led;
//        end
    // Meng Han: Oled display    
    // oled_data <= oled_data_temp; // update oled_data
    // led <= led_temp;

//    end

endmodule