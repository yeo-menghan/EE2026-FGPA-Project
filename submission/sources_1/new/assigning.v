`timescale 1ns / 1ps
module assigning (
    input [3:0] num,
    output reg [3:0] value1, value2
);
    always @(*)
    begin
        case(num)
        4'd0:
        begin
            value1 <= 0;
            value2 <= 1;
        end
        4'd1:
        begin
            value1 <= 0;
            value2 <= 2;
        end
        4'd2:
        begin
            value1 <= 0;
            value2 <= 3;
        end
        4'd3:
        begin
            value1 <= 0;
            value2 <= 4;
        end
        4'd4:
        begin
            value1 <= 0;
            value2 <= 5;
        end
        4'd5:
        begin
            value1 <= 0;
            value2 <= 6;
        end
        4'd6:
        begin
            value1 <= 0;
            value2 <= 7;
       end
       4'd7:
       begin
            value1 <= 0;
            value2 <= 8;
        end
        4'd8:
        begin
            value1 <= 0;
            value2 <= 9;
        end
        4'd9:
        begin
            value1 <= 1;
            value2 <= 0;
        end
        default:
        begin
            value1 <= 10;
            value2 <= 10;
        end
        endcase
    end
endmodule
