`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2023 10:09:16
// Design Name: 
// Module Name: peak_intensity
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


module peak_intensity(
    input basys_clock,
    input [11:0] MIC_IN,
    output reg [11:0] peak_vol
);
    
    reg [31:0] count = 0;
    reg [11:0] value = 0;
     
    // Regular time interval of 0.2 second == 4_000 samples
    always @(posedge basys_clock) begin
        count <= count == 13'd3999 ? 0 : count + 1;
        //only accept values between 2048 and 4095
        value <= (MIC_IN >= 2048) ? MIC_IN : 0;
        peak_vol <= (count == 0) ? value : ((value > peak_vol) ? value : peak_vol);
    end
endmodule
