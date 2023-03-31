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
    output reg [15:0] led,
    output reg [3:0]an, 
    output reg [6:0]seg
    );
    
    // Display Gameover text
    wire [15:0] oled_menu_gameover;
    menu_gameover gameover_display (sys_clk, pixel_idx, oled_menu_gameover);
    
    // Collision init
    reg collided_cactus = 0; 
    reg collided_laser = 0;
    
    // Scoreboard on the 7-seg, adapted from online
    reg [26:0] one_second_counter; // counter for generating 1 second clock enable
    wire one_second_enable;// one second enable for counting numbers
    reg [15:0] displayed_number; // counting number to be displayed
    reg [3:0] LED_BCD;
    reg [19:0] refresh_counter; 
    wire [1:0] LED_activating_counter; 
    
    always @(posedge sys_clk or posedge btnC) begin
        if(btnC==1)begin
            one_second_counter <= 0;
        end
        else if(collided_laser || collided_cactus) begin
            one_second_counter <= one_second_counter; // freeze counter
        end
        else begin
            if(one_second_counter>=99999999) 
                 one_second_counter <= 0;
            else
                one_second_counter <= one_second_counter + 1;
        end
    end 
     assign one_second_enable = (one_second_counter==99999999)?1:0;
     always @(posedge sys_clk or posedge btnC)
        begin
            if(btnC==1)
                displayed_number <= 0;
            else if(one_second_enable==1)
                displayed_number <= displayed_number + 1;
        end
        always @(posedge sys_clk or posedge btnC)
        begin 
            if(btnC==1)
                refresh_counter <= 0;
            else
                refresh_counter <= refresh_counter + 1;
        end 
        assign LED_activating_counter = refresh_counter[19:18];
        always @(*) begin
        case(LED_activating_counter)
        2'b00: begin
            an = 4'b0111;             // activate LED1 and Deactivate LED2, LED3, LED4
            LED_BCD = displayed_number/1000;            // the first digit of the 16-bit number
              end
        2'b01: begin
           an = 4'b1011;             // activate LED2 and Deactivate LED1, LED3, LED4
            LED_BCD = (displayed_number % 1000)/100;            // the second digit of the 16-bit number
              end
        2'b10: begin
           an = 4'b1101;             // activate LED3 and Deactivate LED2, LED1, LED4
            LED_BCD = ((displayed_number % 1000)%100)/10;            // the third digit of the 16-bit number
                end
        2'b11: begin
           an = 4'b1110;             // activate LED4 and Deactivate LED2, LED3, LED1
            LED_BCD = ((displayed_number % 1000)%100)%10;            // the fourth digit of the 16-bit number    

               end
        endcase
        end
        always @(*) begin
           case(LED_BCD)
           4'b0000: seg = 7'b1000000; // "0"     
           4'b0001: seg = 7'b1111001; // "1" 
           4'b0010: seg = 7'b0100100; // "2" 
           4'b0011: seg = 7'b0110000; // "3" 
           4'b0100: seg = 7'b0011001; // "4" 
           4'b0101: seg = 7'b0010010; // "5" 
           4'b0110: seg = 7'b0000010; // "6" 
           4'b0111: seg = 7'b1111000; // "7" 
           4'b1000: seg = 7'b0000000; // "8"     
           4'b1001: seg = 7'b0011000; // "9" 
           default: seg = 7'b1000000; // "0"
           endcase
        end
  
    // clocks
    wire clk5, clk10, clk50;
    clock_divider clk5_div (.sys_clk(sys_clk), .freq(5), .clk_output(clk5)); // 5Hz
    clock_divider clk10_div (.sys_clk(sys_clk), .freq(10), .clk_output(clk10)); // 10Hz
    clock_divider clk50_div (.sys_clk(sys_clk), .freq(50), .clk_output(clk50)); // 50Hz
    
    wire border_t, border_b, border_l, border_r, border;
    assign border_t = (x>=0&&x<=96&&y>=0&&y<=2); 
    assign border_l = (x>=0&&x<=2&&y>=0&&y<=64); 
    assign border_r = (x>=94&&x<=96&&y>=0&&y<=64); 
    assign border = border_t || border_l || border_r;
    
    // assign obstacle status registers & colours
    wire pad_on, sq_pad_on, ground_on, rect_ground_on, cactus_on, sq_cactus_on;
    wire [15:0] cactus_rgb, pad_rgb, bg_rgb, ground_rgb, border_rgb;
    assign pad_rgb = 16'b00000_000000_00000; // black paddle
    assign bg_rgb = 16'b11111_111111_11111; // white background
    assign ground_rgb = 16'b00000_111111_11111; // aqua background
    assign border_rgb   = 16'b00000_000000_11111;    // blue walls
    assign cactus_rgb = 16'b00000_111111_00000; // green cactus
    
    // 15 x 15 Dino Paddle Init
    parameter PAD_SIZE = 15;
    wire[6:0] x_pad_l, x_pad_r;
    wire[5:0] y_pad_t, y_pad_b; // paddle vertical boundaries
    reg [5:0] y_pad_reg = 20; // starting position
    reg[6:0] x_pad_reg = 20;
    reg [6:0] x_pad_next;
    reg[5:0] y_pad_next; 
    parameter PAD_VELOCITY = 5;
    
    wire [3:0] addr, col;   
    reg [14:0] data;        
    wire data_bit;           
    
    always @(*) begin
    case(addr)
        4'b0000: data = 15'b00000000000000;
        4'b0001: data = 15'b01111110000000;
        4'b0010: data = 15'b01111110000000;
        4'b0011: data = 15'b01111110000000;
        4'b0100: data = 15'b00001110000000;
        4'b0101: data = 15'b00001110000000;
        4'b0110: data = 15'b00001111000000;
        4'b0111: data = 15'b00000111110000;
        4'b1000: data = 15'b00000111111110;
        4'b1001: data = 15'b00000111111100;
        4'b1010: data = 15'b00000011111100;
        4'b1011: data = 15'b00000000111000;
        4'b1100: data = 15'b00000000001000;
        4'b1101: data = 15'b00011110000000;
        4'b1110: data = 15'b00000000000000;
    endcase
    end
    
    // Dino paddle boundaries
    assign x_pad_l = x_pad_reg;
    assign y_pad_t = y_pad_reg;
    assign x_pad_r = x_pad_l + PAD_SIZE - 1;
    assign y_pad_b = y_pad_t + PAD_SIZE - 1;
    assign sq_pad_on = (x_pad_l <= x) && (x <= x_pad_r) &&
               (y_pad_t <= y) && (y <= y_pad_b);
    assign addr = y[5:0] - y_pad_t[5:0];   
    assign col = x[6:0] - x_pad_l[6:0];    
    assign data_bit = data[col];        
    assign pad_on = sq_pad_on & data_bit;      
  
    
    // Moving Cactus test
    wire [3:0] addr_cactus, col_cactus;  
    reg [9:0] data_cactus;             
    wire data_bit_cactus;                   
    
    parameter CACTUS_SIZE = 10;
    wire[6:0] x_cactus_l, x_cactus_r;
    wire[5:0] y_cactus_t, y_cactus_b; // paddle vertical boundaries
    reg [5:0] y_cactus_reg = 40; // starting position, will be shifted into always
    reg[6:0] x_cactus_reg = 60; // starting position, will be shifted into always
    parameter CACTUS_VELOCITY = 3;
   
    always @* begin 
       case(addr_cactus)
           4'b0000: data_cactus = 10'b0000110000;
           4'b0001: data_cactus = 10'b0000110000;
           4'b0010: data_cactus = 10'b0100110000;
           4'b0011: data_cactus = 10'b0100110010;
           4'b0100: data_cactus = 10'b0100110010;
           4'b0101: data_cactus = 10'b0000110010;
           4'b0110: data_cactus = 10'b0000111100;
           4'b0111: data_cactus = 10'b0000110000;
           4'b1000: data_cactus = 10'b0000110000;
           4'b1001: data_cactus = 10'b0000110000;
       endcase
    end
    
    assign x_cactus_l = x_cactus_reg;
    assign y_cactus_t = y_cactus_reg;
    assign x_cactus_r = x_cactus_l + CACTUS_SIZE - 1;
    assign y_cactus_b = y_cactus_t + CACTUS_SIZE - 1;
    assign sq_cactus_on = (x_cactus_l <= x) && (x <= x_cactus_r) &&
                       (y_cactus_t <= y) && (y <= y_cactus_b);
    
    assign addr_cactus = y[5:0] - y_cactus_t[5:0];   
    assign col_cactus = x[6:0] - x_cactus_l[6:0];   
    assign data_bit_cactus = data_cactus[col_cactus];         
    assign cactus_on = sq_cactus_on & data_bit_cactus;     
    
    // Register controls for paddle
    always @(posedge sys_clk or posedge btnC) begin
       if(btnC == 1) begin
           y_pad_reg <= 20;
           x_pad_reg <= 20;
       end
       else begin
           y_pad_reg <= y_pad_next;
           x_pad_reg <= x_pad_next;
       end
    end
    
    always @(posedge clk10) begin
        if(x_cactus_l == 2) begin // reset ground_x1 and continue to move leftwards
          x_cactus_reg <= 90 - CACTUS_VELOCITY;
          y_cactus_reg <= y_cactus_reg;
        end
        else begin // keep moving leftwards
            x_cactus_reg <= x_cactus_reg - CACTUS_VELOCITY; // move leftwards
            y_cactus_reg <= y_cactus_reg;
        end
        
        // collide when they're in the same position at the same time!
        if(x_cactus_l >= 5 && x_cactus_l < 18 && y_pad_b >= 40 && y_pad_b <= 50) begin
            x_cactus_reg <= x_cactus_reg; // no move
            collided_cactus <= 1;
            led[4] <= 1;
        end
        else begin
            collided_cactus <= 0;
            led[4] <= 0;
        end
    end
    
    // moving laser beams        
    reg [5:0] random_y1 = 40, random_y2 = 45;
    wire [5:0] random_y1_w, random_y2_w;
    assign random_y1_w = random_y1;
    assign random_y2_w = random_y2;
    parameter ground_xdef = 7'd96;
    parameter GROUND_LENGTH1 = 10;
    parameter GROUND_LENGTH2 = 10; 
    reg signed [6:0] ground_x1 = 50; // starting pos
    reg signed [6:0] ground_x2 = ground_xdef; // starting pos
    wire ground_x1_d, ground_x2_d;
    assign ground_x1_d = (y == random_y1_w) && (ground_x1 + GROUND_LENGTH1 >= x) && (x >= ground_x1);
    assign ground_x2_d = (y == random_y2_w) && (ground_x2 + GROUND_LENGTH2 >= x) && (x >= ground_x2);
    
    always @(posedge clk50) begin

        if(ground_x1 == 3) begin // reset ground_x1 and continue to move leftwards
            if(random_y1 >= y_pad_t && random_y1 <= y_pad_b) begin
                collided_laser <= 1;
            end
            else begin
                collided_laser <= 0;
            end
            ground_x1 <= ground_xdef - 1;
            ground_x2 <= ground_x2 - 1;
            random_y1 <= one_second_counter % 17 + 15;
        end
        else if (ground_x2 == 3) begin
            if(random_y2 >= y_pad_t && random_y2 <= y_pad_b) begin
                collided_laser <= 1;
            end
            else begin
                collided_laser <= 0;
            end
            ground_x1 <= ground_x1 - 1;
            ground_x2 <= ground_xdef - 1;
            random_y2 <= one_second_counter % 17 + 20;
        end
        else begin // keep moving leftwards
            ground_x1 <= ground_x1 - 1;
            ground_x2 <= ground_x2 - 1;
        end    
    end
 
    // Static Ground
    wire [3:0] addr_ground, col_ground;   
    reg [95:0] data_ground;            
    wire data_bit_ground;                   
    
    parameter GROUND_W = 96;
    parameter GROUND_Y = 9;
    wire[6:0] x_ground_l, x_ground_r;
    wire[5:0] y_ground_t, y_ground_b; 
    reg [5:0] y_ground_reg = 50; // starting position
    reg[6:0] x_ground_reg = 0;
    parameter GROUND_VELOCITY = 1;

    always @(*) begin 
        case(addr_ground)
            4'b0000: data_ground = 96'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
            4'b0001: data_ground = 96'b000000000000000000000000100000000000100000000000000000001000000000000000000000000000000000001000;
            4'b0010: data_ground = 96'b000000000000000000000000100000000000100000000000000000001000000000000000000000000000000000001000;
            4'b0011: data_ground = 96'b010000000000000010000000000000000010000100000000000100000000000000000010000000000000000000100000;
            4'b0100: data_ground = 96'b010000000000000010000000000000000010000100000000000100000000000000000010000000000000000000100000;
            4'b0101: data_ground = 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000;
            4'b0110: data_ground = 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000;
            4'b0111: data_ground = 96'b000000000001001000000000000010100000000000000100000000000000000000000000001000000000000000000000;
            4'b1000: data_ground = 96'b000000000001001000000000000010100000000000000100000000000000000000000000001000000000000000000000;
        endcase
    end
    
    assign x_ground_l = x_ground_reg;
    assign y_ground_t = y_ground_reg;
    assign x_ground_r = x_ground_l + GROUND_W - 1;
    assign y_ground_b = y_ground_t + GROUND_Y - 1;

    assign rect_ground_on = (x_ground_l <= x) && (x <= x_ground_r) &&
                        (y_ground_t <= y) && (y <= y_ground_b);
    
    assign addr_ground = y[5:0] - y_ground_t[5:0];   
    assign col_ground = x[6:0] - x_ground_l[6:0];  
    assign data_bit_ground = data_ground[col_ground];        
    assign ground_on = rect_ground_on & data_bit_ground;      
   
    // paddle control & display
    always @(posedge sys_clk) begin
        y_pad_next = y_pad_reg; // no move
        
        if(left == 1 || btnD == 1 || sw[2] == 1) begin
            y_pad_next = y_pad_reg + PAD_VELOCITY; // move down
        end
        else if (right == 1 || btnU == 1 || sw[3] == 1) begin
            y_pad_next = y_pad_reg - PAD_VELOCITY; // move up
        end
       
       if (y_pad_b == 50) begin // touches ground
            y_pad_next = y_pad_reg - PAD_VELOCITY; // move up by 1
       end
       
        if(collided_cactus || collided_laser) begin // collsion
            y_pad_next = y_pad_reg; // no move
        end
    end
    
    // Display control
    always @(posedge sys_clk) begin
        if(pad_on) begin
            oled_data = pad_rgb;
        end
        else if(ground_x1_d) begin
            oled_data = ground_rgb;
        end
        else if(ground_x2_d) begin
            oled_data = ground_rgb;
        end
        else if(cactus_on) begin
            oled_data = cactus_rgb;
        end
        else if(ground_on) begin
            oled_data = ground_rgb;
        end
        else if(border) begin
            oled_data = border_rgb;
        end
        else begin
            oled_data = bg_rgb;
        end
        
        if(collided_cactus == 1 || collided_laser == 1) begin
            oled_data = oled_menu_gameover;
        end    
    end

endmodule
