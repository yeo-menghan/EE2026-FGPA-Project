`timescale 1ns / 1ps

module tri_task(
    input basys_clock, 
    input [11:0] MIC_IN,
    output reg [8:0] led,
    output reg [6:0] seg,
    output [3:0] an
);

    wire [4:0] volume;
    
    assign an = 4'b1110;
    
    volume_lvl vv(.basys_clock(basys_clock), .MIC_IN(MIC_IN), .audio_level(volume));
        
    always @(posedge basys_clock)
    begin 
    case (volume)
        4'd1:
        begin
            seg <= 7'b1111001; //1
            led <= 9'b000000001;
        end
        
        4'd2:
        begin
            seg <= 7'b0100100; //2
            led <= 9'b000000011;

        end
           
        4'd3:
        begin
            seg <= 7'b0110000; //3
            led <= 9'b000000111;
        end
        
        4'd4:
        begin
            seg <= 7'b0011001; //4
            led <= 9'b000001111;

        end

        4'd5:
        begin
             seg <= 7'b0010010; //5  
            led <= 9'b000011111;

        end

        4'd6:
        begin
            seg <= 7'b0000010; //6
            led <= 9'b000111111;
        end

        4'd7:
        begin
            seg <= 7'b1111000; //7
            led <= 9'b001111111;
        end
    
        4'd8:
        begin
            seg <= 7'b0000000; //8
            led <= 9'b011111111;
        end

        4'd9:
        begin
            seg <= 7'b0001000; //9
            led <= 9'b111111111;
        end
        
        default:
        begin 
            seg <= 7'b0000000; //8
            led <= 9'b011111111;
        end

    endcase
    end
endmodule
