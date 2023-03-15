`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2023 13:23:23
// Design Name: 
// Module Name: seven_seg
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


module seven_seg(
        input basys_clock, MISO, 
        output sclk, clk_samp, 
        output reg an0, 
        output reg [6:0] seg,
        output [8:0] led
    );
    
    wire [8:0] num_light; 
           
    audio_led_display mm(.basys_clock(basys_clock), .MISO(MISO), .clk_samp(clk_samp), .sclk(sclk), .led(led), .num_light(num_light));

       
    always @(posedge basys_clock) begin 
        an0 <= 0;
        if (num_light == 0)
            begin
                seg <= 7'b1111001; //1
            end
        else if (num_light == 1)
            begin
                seg <= 7'b0100100; //2
            end        
        else if (num_light == 2)
            begin
                seg <= 7'b0110000; //3
            end
        else if (num_light == 3)
            begin
                seg <= 7'b0011001; //4
            end
        else if (num_light == 4)
            begin
                seg <= 7'b0010010; //5   
            end
        else if (num_light == 5)
            begin
                seg <= 7'b0000010; //6
            end
        else if (num_light == 6)
            begin
                seg <= 7'b1111000; //7
            end
        else
            begin
                seg <= 7'b0000000; //8
            end
    end
    
endmodule
