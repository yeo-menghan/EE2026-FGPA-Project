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
        output [8:0] led,
        output [3:0] an,
        output [6:0] seg
    );
    
//    audio_input_testing yy(.basys_clock(basys_clock), .J_MIC_Pin3(MISO), .sw1(sw1), .J_MIC_Pin1(clk_samp), .J_MIC_Pin4(sclk), .LED(led));
    
    led_display dd( .basys_clock(basys_clock), .MISO(MISO), .sclk(sclk), .clk_samp(clk_samp), .an(an), .seg(seg), .led(led) );

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
//    end

endmodule