`timescale 1ns / 1ps

module visualiser (
    //for audio
    input basys_clock, clk6p25m, clk20k, [15:0] sw,
    input [11:0] MIC_IN,
    input [12:0] pixel_index,
    output reg [15:0] oled_data
);
 //image for high volume
 wire [15:0] oled_data1;
 loud loud(.basys_clock(basys_clock), .clk6p25m(clk6p25m), .pixel_index(pixel_index), .oled_data(oled_data1));
 
 //normal volume visualiser 
 wire [15:0] oled_data2;
 display display(.clk6p25m(clk6p25m), .basys_clock(basys_clock), .pixel_index(pixel_index), .oled_data(oled_data2), .MIC_IN(MIC_IN));
 
 wire [4:0] volume;
 edited_volume_level lvl(.basys_clock(basys_clock), .MIC_IN(MIC_IN), .audio_level(volume));
 
 always @(*)
 begin  
    if (sw[6] == 1)
    begin
        if (volume >= 10)
        begin
            oled_data <= oled_data1;
        end
        else
        begin
            oled_data <= oled_data2;
        end
    end
    else
        oled_data <= oled_data2;
 end
endmodule
 