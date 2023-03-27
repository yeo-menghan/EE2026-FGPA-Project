`timescale 1ns / 1ps

module dff(input clk, D, output reg Q);
    
    always @ (posedge clk) begin
        Q <= D;
    end

endmodule
