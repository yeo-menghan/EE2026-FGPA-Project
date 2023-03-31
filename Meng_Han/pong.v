`timescale 1ns / 1ps

module pongtest(
    input sys_clk,
    input btnC, // reset 
    input btnU, btnD,
    input left, right,
    input [15:0] sw,
    input [6:0] x,         
    input [5:0] y, 
    input [11:0] xpos,
    input [11:0] ypos,
    input [12:0] pixel_idx, 
    output reg [15:0] oled_data,    
    output reg [15:0] led
    );
    
    // clocks
    wire clk5;
    clock_divider clk5_div (.sys_clk(sys_clk), .freq(5), .clk_output(clk5)); // 5Hz
    
    parameter x_max = 96;
    parameter y_max = 64;
    
    // moving ground test
    // this is as opposed to the array method (whereby you just iterate across the array and display whatever's shown on the screen)
    parameter ground_xdef = 7'd96;
    parameter GROUND_LENGTH = 65; // entire screen
    parameter GROUND_Y1 = 50;
    parameter GROUND_Y2 = 55;
    reg signed [6:0] ground_x1 = 0; // starting pos
    reg signed [6:0] ground_x2 = ground_xdef; // starting pos
    wire ground_x1_d, ground_x2_d;
    assign ground_x1_d = (y == GROUND_Y1) && (ground_x1 + GROUND_LENGTH >= x) && (x >= ground_x1);
    assign ground_x2_d = (y == GROUND_Y2) && (x == ground_x2);
    
    // BUG: if it hits the wall, the whole thing disappears. 
    // Possible fix: when it hits the wall, stop and reduce the size by 1 from the left while it is still moving leftwards until it disappears. when it disappears, reset the size and position
    
    always @(posedge clk5) begin
        if(ground_x1 == -65) begin // reset ground_x1 and continue to move leftwards
            ground_x1 <= ground_xdef - 1;
            ground_x2 <= ground_x2 - 1;
        end
        else if (ground_x2 == -65) begin
            ground_x1 <= ground_x1 - 1;
            ground_x2 <= ground_xdef - 1;
        end
        else begin // keep moving leftwards
            ground_x1 <= ground_x1 - 1;
            ground_x2 <= ground_x2 - 1;
        end
    end
    
    // generating a 15 x 15 dino image
    parameter X_PAD_L = 20;
    parameter X_PAD_R = 34;
    parameter PAD_HEIGHT = 15;
    wire[5:0] y_pad_t, y_pad_b; // paddle vertical boundaries
    reg [5:0] y_pad_reg = 20; // starting position
    reg [5:0] y_pad_next; 
    parameter PAD_VELOCITY = 1;
    
    wire pad_on;
    wire [15:0] pad_rgb, bg_rgb, ground_rgb;
    assign pad_rgb = 16'b00000_000000_00000; // black paddle
    assign bg_rgb = 16'b00000_111111_11111; // aqua background
    assign ground_rgb = 16'b11111_111111_11111; // white background
    
    assign y_pad_t = y_pad_reg; // paddle top position
    assign y_pad_b = y_pad_t + PAD_HEIGHT - 1; // paddle bottom position
    assign pad_on = (X_PAD_L <= x) && (x <= X_PAD_R) && (y_pad_t <= y) && (y <= y_pad_b); // pixel within paddle boundaries

    
    // 'dino default', 15px x 15px
    wire [14:0] dino_default [0:14];
    assign dino_default[0] = 15'b11111111111111;
    assign dino_default[1] = 15'b11111110000001;
    assign dino_default[2] = 15'b11111110000001;
    assign dino_default[3] = 15'b11111110000001;
    assign dino_default[4] = 15'b11111110001111;
    assign dino_default[5] = 15'b11111110001111;
    assign dino_default[6] = 15'b11111100011111;
    assign dino_default[7] = 15'b10110000011111;
    assign dino_default[8] = 15'b10000000011111;
    assign dino_default[9] = 15'b10000000011111;
    assign dino_default[10] = 15'b11000000111111;
    assign dino_default[11] = 15'b11100001111111;
    assign dino_default[12] = 15'b11110111111111;
    assign dino_default[13] = 15'b11111110111111;
    assign dino_default[14] = 15'b11111111111111;
    
    // paddle register control
    always @(posedge sys_clk or posedge btnC) begin
        led[0] <= 1;
        if(btnC || sw[14] == 1) begin
            led[4] <= 1;
            y_pad_reg <= 20;
        end
        else begin
            y_pad_reg <= y_pad_next;
            led[4] <= 0;
        end
    end
    
    
    // paddle control & display
    always @(posedge sys_clk) begin
        oled_data = 16'b00000_000000_00000;        
        led[1] <= 1;
        y_pad_next = y_pad_reg; // no move
        
        if(left == 1 || btnD == 1 || sw[2] == 1) begin
            led[2] <= 1;
            y_pad_next = y_pad_reg + PAD_VELOCITY; // move down
        end
        else if (right == 1 || btnU == 1 || sw[3] == 1) begin
            led[3] <= 1;
            y_pad_next = y_pad_reg - PAD_VELOCITY; // move up
        end


        if(pad_on) begin
            oled_data = pad_rgb;
        end
        else if(ground_x1_d) begin
            oled_data = ground_rgb;
        end
        else if(ground_x2_d) begin
            oled_data = ground_rgb;
        end
        else begin
            oled_data = bg_rgb;
        end
    end

endmodule
