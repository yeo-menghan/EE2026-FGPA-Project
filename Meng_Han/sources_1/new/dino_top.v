`timescale 1ns / 1ps

module dino_top(
    input sys_clk, clk6p25, clk25M,
    input btnC, btnL, btnR, 
    input [15:0] sw,
    input x, y, input xpos, input ypos,
    input app_state,
    input [12:0] pixel_idx, output reg [15:0] oled_data,    
    output reg [15:0] led,
    output run, dead
    );
    localparam Screen_H = 64;
    localparam Screen_W = 96;
    
    wire [5:0] Ground_Y; // ground for the dino to walk on
    wire [6:0] dinoX;
    wire [5:0] dinoY;
    wire [6:0] ObstacleX;
    
    wire  animateClock;  // controls the animation of dino's foot step, and bird wings
    wire  ScoreClock;    // Speed of Score coutner (1s = 10 points)
    
    wire  rst;
    wire  jump;
    wire  duck;
    
    assign Ground_Y = Screen_H - (Screen_H >> 2);   // Ground Y coordinate assignment
   // 640 - 160 = 480 --> Bottom 25 %
    
    wire [10:0] difficulty = 11'd500;  // arbitrary number, fine-tune later
    
    // make edits to the current clock divider, need to possibly introduce a new clock divider or otherwise calibrate to the frequency needed
//    ClockDivider #(.velocity(4))   
//          animateClk (.clk(clk),
//                      .speed(animateClock));
       
//       ClockDivider #(.velocity(10))  // Period = 0.1s
//          ScoreClkv (.clk(clk),
//                     .speed(ScoreClock));
       
//       ClockDivider #(.velocity(50))  // Period = 0.1s
//          FPSClk (.clk(clk),
//                     .speed(Frame_Clk));
                          
//        ClockDivider #(.velocity(500))
//            MoveClk (.clk(clk),
//                       .speed(moveClk));

    
    reg collided; // collide with object
    wire dino_white; // the white part of the dino
    wire dino_black; // the black part of the dino
    wire obstacle_white; // the white part of the obstacle
    wire obstacle_black; // the black part of the obstacle
    
    always @(posedge sys_clk) begin
        if(rst) begin  // reset collision
            collided <= 0;
        end
        else begin
            collided <= dino_black & obstacle_black; // dun really understand the importance of this line, check
        end
        led[0] <= collided; // test
    end // always @
    
    
    // Game Delegate / gameFSM
    wire [1:0] gameState; // gameFSM, 00: alive, 01: collide, 10: dead
    
    // background delegate
    wire background_black;
    
    // scoreboard delegate
    wire scoreboard_black;
    
    // T-rex delegate
    
    
    // obstacles delegate
    
    
    // selecting colour
    wire isBlack;
    wire isWhite;
    wire isBackground;
    
    assign isBlack = dino_black | background_black | scoreboard_black | obstacle_black;
    assign isWhite = dino_white | obstacle_white;
    assign isBackground = (x>0) && (x<=Screen_W) && (y>0) && (y<=Screen_H) && !isBlack; // definition of background here is vague. do we actually need this?
      
    always @(posedge clk25M) begin
        if(isWhite) begin
            oled_data = 16'b11111_111111_11111;
        end
        
        else if(isBlack) begin
            oled_data = 16'b0;
        end
        
        else if(isBackground) begin
            oled_data = 16'b11111_111111_11111;
        end
        
        else begin //default black
            oled_data = 16'b0;
        end 
    end
    
    // are these needed?
    assign run = gameState[1];
    assign dead = gameState[0];
    
endmodule
