`timescale 1ns / 1ps
///refreshcounter - counts from 1 to 3 to swtich anode
module control_counter(
    input control_clock,
    output reg [1:0] control_counter = 0
);

    always@(posedge control_clock)
    begin
        if (control_counter == 2'd3)
            control_counter <= 0;
        else
            control_counter <= control_counter + 1;
    end
endmodule

