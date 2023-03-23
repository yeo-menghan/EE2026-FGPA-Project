`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2023 16:18:00
// Design Name: 
// Module Name: blah
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
module random(
    output [3:0] number
);
    assign number = 7;
endmodule


module combined(
    input basys_clock, MISO,
    output sclk, clk_samp, dp,
    output [3:0] an,
    output [6:0] seg,
    output reg [8:0] led
);
    //unless 20k of basys is not enough, make a separate frequency clock
    wire custom_clock;   
    custom_clock custom(basys_clock, 499, custom_clock);
   
    wire [1:0] control_counter;
    wire [3:0] value;  //from function passed from oled
    wire [4:0] vol;  //from function passed from vol  
    wire [3:0] digit; //mux of number from oled and volume
    
    
    assign digit = (control_counter == 0) ? vol : value;
    
    //for volume, to obtain volume level
    vol_level volume(.basys_clock(custom_clock), .MISO(MISO), .sclk(sclk), .clk_samp(clk_samp), .audio_level(vol));
    //the funcction to be passed
    random random(.number(value));
    control_counter countercontrol(.control_clock(custom_clock), .control_counter(control_counter));
    an_control ancontrol(.control_counter(control_counter), .an(an));
    segment segment(.digit(digit), .seg(seg));
    //led leds(basys_clock, MISO, sclk, clk_samp, led);
    
    
    always@(vol)
        begin
            case(vol)
                4'd1:
                led <= 9'b000000001;
                4'd2:
                led <= 9'b000000011;
                4'd3:
                led <= 9'b000000111;
                4'd4:
                led <= 9'b000001111;
                4'd5:
                led <= 9'b000011111;
                4'd6:
                led <= 9'b000111111;
                4'd7:
                led <= 9'b001111111;
                4'd8:
                led <= 9'b011111111;
                4'd9:
                led <= 9'b111111111;
             endcase
         end
         
         
endmodule


//bcd to cathode
module segment(
    input [3:0] digit,
    output reg [6:0] seg = 0
);

    always@(digit)
    begin
        case(digit)
            4'd0:
                seg = 7'b1100000;
            4'd1:
                seg = 7'b1111001;
            4'd2:
                seg = 7'b0100100;
            4'd3:
                seg = 7'b0110000;
            4'd4:
                seg = 7'b0011001;
            4'd5:
                seg = 7'b0010010;
            4'd6:
                seg = 7'b0000010;
            4'd7:
                seg = 7'b1111000;
            4'd8:
                seg = 7'b0000000;
            4'd9:
                seg = 7'b0010000;
            default
                seg = 7'b1111111;
        endcase
    end
endmodule


//anode_control
module an_control(
    input [1:0] control_counter,
    output reg [3:0] an = 0
);
    
    always@(control_counter)
    begin
        case(control_counter)
            4'd0:
                an <= 4'b1110;
            4'd1:
                an <= 4'b1011;
            4'd2:
                an <= 4'b0111;
            default:
                an <= 4'b1111;
        endcase
    end
endmodule


//refreshcounter
module control_counter(
    input control_clock,
    output reg [1:0] control_counter = 0
);

    always@(posedge control_clock)
    begin
        control_counter <= control_counter + 1;
//        if (control_counter == 2)
//        begin
//            control_counter <=0;
//        end
    end
endmodule


//bcd control
//depends on the input of the reg/wire
//not required if the wire is directed to the segment number, module segment
//module anode(
//    input [1:0] control_clock,
//    output reg [3:0] an
//);

//    always @(control_clock)
//    begin
//        case(control_clock)
//            2'b00:
//                an <= 4'b1110;
//            2'b01:
//                an <= 4'b1101;
//            2'b10: 
//                an <= 4'b1011;
//            2'b11:
//                an <= 4'b0111;
//            default:
//                an<=4'b0000;
//        endcase
//    end

//endmodule 

