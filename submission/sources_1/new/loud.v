`timescale 1ns / 1ps

//change image when it is "noisy"
module loud(
    input basys_clock, clk6p25m,
    input [12:0] pixel_index,
//    input [4:0] vol,
    output reg [15:0] oled_data
);
     
    wire freq_clk;
    clock_divider freq_clkm(.sys_clk(basys_clock), .freq(1), .clk_output(freq_clk)); //1hz
    
    reg [15:0] pic1[6143:0];
    reg [15:0] pic2[6143:0];
            
    initial begin
    $readmemh("sign.mem",pic1);
    $readmemh("keep_quiet.mem",pic2);
    end
     
    reg [3:0] noisy_count = 0;
    always@(posedge freq_clk)
    begin
        noisy_count <=  noisy_count + 1;
    end
        
    always @ (posedge clk6p25m)
    begin 
        if (noisy_count > 8)
            oled_data <= pic2[pixel_index];
        else
            oled_data <= pic1[pixel_index];
    end 
endmodule

