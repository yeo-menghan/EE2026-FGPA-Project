`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2023 11:17:29
// Design Name: 
// Module Name: audio_led_display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module led_display(
    input basys_clock, MISO, 
    output sclk, clk_samp,
    output reg [8:0] led,
    output reg [6:0] seg,
    output [3:0] an
);

    wire [11:0] peak_volume;
    wire clock_20k;
    
    assign an = 4'b1110;
    
    peak_intensity uaa(.basys_clock(basys_clock), .MISO(MISO), .clk_samp(clk_samp), .sclk(sclk), .peak_vol(peak_volume));

     always @(posedge basys_clock) begin 
        if (peak_volume < 2276) 
        begin
            seg <= 7'b1111001; //1
            //led[0] <=  1;
            led <= 9'b000000001;
        end
        else if (peak_volume < 2503)
        begin
            seg <= 7'b0100100; //2
//            led[1:0] <=  1;
            led <= 9'b000000011;

        end
        else if (peak_volume < 2730)
        begin
            seg <= 7'b0110000; //3
//            led[2:0] <=  1;
            led <= 9'b000000111;
        end
        else if (peak_volume < 2957)
        begin
            seg <= 7'b0011001; //4
//            led[3:0] <=  1;
            led <= 9'b000001111;

        end
        else if (peak_volume < 3185)
        begin
             seg <= 7'b0010010; //5  
//            led[4:0] <=  1;
            led <= 9'b000011111;

        end
        else if (peak_volume < 3412)
        begin
            seg <= 7'b0000010; //6
//            led[5:0] <=  1;
            led <= 9'b000111111;
        end
        else if (peak_volume < 3640)
        begin
            seg <= 7'b1111000; //7
//            led[6:0] <=  1;
            led <= 9'b001111111;
        end
        else if (peak_volume < 3868)
        begin
            seg <= 7'b0000000; //8
//            led[7:0] <=  1;
            led <= 9'b011111111;
        end
        else begin
            seg <= 7'b0001000; //9
//            led[8:0] <= 1;
            led <= 9'b111111111;
        end
    end
endmodule

/*
module audio_led_display(
    input basys_clock, MISO, 
    output clk_samp, sclk,
    output reg [8:0] led,
    output reg [8:0] num_light
);
    
    wire [11:0] peak_volume;
//    wire clock_20k;
    
//    custom_clock clk(basys_clock, 2499, clock_20k);
    peak_intensity uu(.basys_clock(basys_clock), .MISO(MISO), .clk_samp(clk_samp), .sclk(sclk), .peak_vol(peak_volume));
    
    //divide into 9 volume levels
    always @(posedge basys_clock) begin 
        if (peak_volume == 2048) 
        begin
            num_light <= 0;
            led[0] <=  1;
        end
        else if (peak_volume < 2304)
        begin
            num_light <=1;
            led[1:0] <=  1;
        end
        else if (peak_volume < 2506)
        begin
            num_light <=2;
            led[2:0] <=  1;
        end
        else if (peak_volume < 2816)
        begin
            num_light <=3;
            led[3:0] <=  1;
        end
        else if (peak_volume < 3027)
        begin
            num_light <=4;
            led[4:0] <=  1;
        end
        else if (peak_volume < 3328)
        begin
            num_light <=5;
            led[5:0] <=  1;
        end
        else if (peak_volume < 3584)
        begin
            num_light <=6;
            led[6:0] <=  1;
        end
        else if (peak_volume < 3840)
        begin
            num_light <=7;
            led[7:0] <=  1;
        end
        else begin
            num_light <= 8;
            led[8:0] <= 1;
        end
    end
   
endmodule
*/
