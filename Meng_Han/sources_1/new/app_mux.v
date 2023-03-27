`timescale 1ns / 1ps

// create a simple one to toggle between the various apps first before transitioning to a fully imaged version?
module app_mux(
        input sys_clk, clk6p25, clk25M, btnC, btnU, btnD, btnL, btnR, 
//        input [11:0] mic_in_R, 
//        input [11:0] mic_in_L, 
        input [15:0]sw, 
        input [6:0] x, 
        input [5:0] y, 
        input [12:0] pixel_idx,
        input [11:0] xpos,
        input [11:0] ypos,
        input left, middle, right, new_event, 
        output reg [15:0] oled_data, 
        output reg [3:0]an, 
        output reg [6:0]seg, 
        output reg [15:0]led);
   
    //mouse wire reg
    reg [7:0] x_cursor_reg; 
    reg [6:0] y_cursor_reg;    
    wire [7:0] x_cursor_menu; 
    wire [6:0] y_cursor_menu;
   
    // app / menu state wire reg
    reg [4:0] app_state = 0;
    wire [4:0] app_state_new;
    reg [4:0] menu_state = 0;
    wire [4:0] menu_state_new;
    wire [15:0] oled_data_menu;
    wire [15:0] led_menu;
    
    // integrated_project wire reg
    wire [15:0] oled_data_ip;    
    wire [3:0] an_ip;
    wire [6:0] seg_ip;
    wire [15:0] led_ip;
    wire [7:0] x_cursor_ip; 
    wire [6:0] y_cursor_ip;
    wire [3:0] correct_number;
    assign correct_number = 4'b1111;
    
    // audio visualiser wire reg
    wire [15:0] oled_data_vis;
    wire [3:0] an_vis;
    wire [6:0] seg_vis;
    wire [15:0] led_vis;
    
    // drawing game wire reg
    wire [15:0] oled_data_draw;
    wire [3:0] an_draw;
    wire [6:0] seg_draw;
    wire [15:0] led_draw;

    // dino game wire reg
    wire [15:0] oled_data_dino;
    wire [3:0] an_dino;
    wire [6:0] seg_dino;
    wire [15:0] led_dino;
    
    // subtasks, individual tasks wire reg
    wire [15:0] oled_data_A;
    wire [15:0] oled_data_B;
    wire [15:0] oled_data_C;
    
    menu menu(.clk(sys_clk), .btnC(btnC), .btnL(btnL), .btnR(btnR), .sw(sw),
            .x(x), .y(y), .xpos(xpos), .ypos(ypos),
            .left(left), .right(right),
           .app_state(app_state), .app_state_new(app_state_new),
           .menu_state(menu_state), .menu_state_new(menu_state_new),
           .led(led_menu),
           .x_cursor(x_cursor_menu), .y_cursor(y_cursor_menu),
           .pixel_idx(pixel_idx), .oled_data(oled_data_menu)); 

//    menu_selector menu_selector(.btnC(btnC), .btnL(btnL), .btnR(btnR),
//                                .sw(sw), .clk(sys_clk), .app_state(app_state), .app_state_new(app_state_new), 
//                                .menu_state(menu_state), .menu_state_new(menu_state_new));

    // Integrated task init
    // TODO: insert audio program
    integrated_project integrated_project(.clk(clk6p25), .x(x), .y(y), .sw(sw), .xpos(xpos), .ypos(ypos), .left(left), .right(right), .led(led_ip), .oled_data(oled_data_ip), .x_cursor(x_cursor_ip), .y_cursor(y_cursor_ip));    
    
    // Subtask A init
    
    // Subtask B init
    
    // Subtask C init
    
    // Dino init
    
//    dino_top dino_top();
    
    always @ (posedge sys_clk) begin
        //Menu Selection
        app_state <= app_state_new;
        menu_state <= menu_state_new;
        
        //Showing Menu
        if (app_state == 0) begin
            oled_data <= oled_data_menu;
            an <= 4'b1111;
            seg <= 7'b1111111;
            led <= led_menu;
            x_cursor_reg <= x_cursor_menu;
            y_cursor_reg <= y_cursor_menu;
        end
        
        //Showing Integrated Project
        else if (app_state == 1) begin
            oled_data <= oled_data_ip;
            an <= 4'b1111;
            seg <= 7'b1111111;
            led <= led_ip;
            x_cursor_reg <= x_cursor_ip;
            y_cursor_reg <= y_cursor_ip;
        end
        // Showing Dino game
        else if (app_state == 2) begin
           oled_data <= oled_data_dino;
           an <= 4'b1111;
           seg <= 8'b11111111;
           led <= 16'b0000000000000000;
        end
        // Showing visualiser
        else if (app_state == 3) begin
            oled_data <= oled_data_vis;
            an <= 4'b1111;
            seg <= 7'b1111111;
            led <= 16'b0000000000000001;
        end
        // Showing drawing game
          else if (app_state == 4) begin
              oled_data <= oled_data_draw;
              an <= 4'b1111;
              seg <= 7'b1111111;
              led <= 16'b0000000000000000;
          end
        
        // Showing Subtask A
          else if (app_state == 5) begin
              oled_data <= oled_data_A;
              an <= 4'b1111;
              seg <= 7'b1111111;
              led <= 16'b0000000000000000;
          end
        
        // Showing Subtask B
          else if (app_state == 6) begin
              oled_data <= oled_data_B;
              an <= 4'b1111;
              seg <= 7'b1111111;
              led <= 16'b0000000000000000;
          end
        
        // Showing Subtask C
         else if (app_state == 7) begin
             oled_data <= oled_data_C;
             an <= 4'b1111;
             seg <= 7'b1111111;
             led <= 16'b0000000000000000;
         end
        else begin
            an <= 4'b1111;
            seg <= 7'b1111111;
        led <= 16'b0000000000000000;
        end           
        
    end // always @
    
endmodule

