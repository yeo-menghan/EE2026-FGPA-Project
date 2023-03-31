`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2023 06:16:57
// Design Name: 
// Module Name: edited_volume_level
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


module edited_volume_level(
    input basys_clock, 
    input [11:0] MIC_IN,
    output reg [4:0] audio_level
);
    wire [11:0] peak_volume;
    
    peak_intensity up(.basys_clock(basys_clock), .MIC_IN(MIC_IN), .peak_vol(peak_volume));

    always @(posedge basys_clock) 
    begin
        if (peak_volume < 2276) 
        begin
           audio_level <= 1; 
        end
        else if (peak_volume < 2503)
        begin
           audio_level <= 2; 
        end
        else if (peak_volume < 2730)
        begin
           audio_level <= 3; 
        end
        else if (peak_volume < 2957)
        begin
           audio_level <= 4; 
        end
        else if (peak_volume < 3185)
        begin
            audio_level <= 5; 
        end
        else if (peak_volume < 3405)
        begin
           audio_level <= 6; 
        end
        else if (peak_volume < 3630)
        begin
            audio_level <= 7; 
        end
        else if (peak_volume < 3845)
        begin
            audio_level <= 8; 
        end
        else if (peak_volume <4055)
        begin
            audio_level <= 9;
        end
        else begin
            audio_level <= 10;
        end
    end

endmodule
