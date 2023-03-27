`timescale 1ns / 1ps

module clock_divider(
    input sys_clk, 
    input [31:0] freq,
    output reg clk_output = 0
    );
    
    reg [31:0] count = 0;
    reg [31:0] m;
    
    always @ (posedge sys_clk) begin
        m = 100000000/(2*freq) - 1;
        count <= (count == m) ? 0 : count + 1; 
        clk_output <= (count == 0) ? ~clk_output : clk_output;
    end
    
endmodule