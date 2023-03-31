`timescale 1ns / 1ps
//anode_control - to assign which anode to light up
module an_control(
    input [1:0] control_counter,
    output reg [3:0] an = 0,
    output reg dp
);
    
    always@(control_counter)
    begin
        case(control_counter)
            2'd0:
            begin
                an <= 4'b1110;
                dp <= 1;
            end
            2'd1:
            begin
                an <= 4'b0111;
                dp <= 0;
            end
            2'd2:
            begin
                an <= 4'b1011;
                dp <= 1;
            end
            default:
            begin
                an <= 4'b1111;
                dp <= 1;
            end
        endcase
    end
endmodule