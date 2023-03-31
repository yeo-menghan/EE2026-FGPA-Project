`timescale 1ns / 1ps

module app_mux(
        input sys_clk, clk6p25, clk25M, clk10, clk10k, clk20k,
        input btnC, btnU, btnD, btnL, btnR, 
        input [15:0]sw, 
        input [6:0] x, 
        input [5:0] y, 
        input [12:0] pixel_idx,
        input [11:0] xpos,
        input [11:0] ypos,
        input left, middle, right, new_event, 
        input [11:0] MIC_IN,
        output reg [15:0] oled_data, 
        output reg [3:0]an, 
        output reg [6:0]seg, 
        output reg [15:0]led,
        output JX0,
        output JX1,
        output JX2,
        output JX3,        
        output dp
        );
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
    
    // Tricia's audio visualiser wire reg
    wire [15:0] oled_data_vis;
    wire [3:0] an_vis;
    wire [6:0] seg_vis;
    wire [15:0] led_vis;
    
    // Kai Ning's piano wire reg
    wire [15:0] oled_data_piano;
    wire [3:0] an_piano;
    wire [6:0] seg_piano;
    wire [15:0] led_piano;

    // Meng Hans' dino game wire reg
    wire [15:0] oled_data_dino;
    wire [3:0] an_dino;
    wire [6:0] seg_dino;
    wire [15:0] led_dino;
    
    // Tricia's task 
    wire [15:0] oled_data_tri_task;
    wire [3:0] an_tri_task;
    wire [6:0] seg_tri_task;
    wire [15:0] led_tri_task;

    // Kai Ning's task 
    wire [15:0] oled_data_kn_task;
    wire [3:0] an_kn_task;
    wire [6:0] seg_kn_task;
    wire [15:0] led_kn_task;
    wire [7:0] x_cursor_kn; 
    wire [6:0] y_cursor_kn;

    // Meng Han's task 
    wire [15:0] oled_data_mh_task;
    wire [3:0] an_mh_task;
    wire [6:0] seg_mh_task;
    wire [15:0] led_mh_task;
    
    menu menu(.clk(sys_clk), .btnC(btnC), .btnL(btnL), .btnR(btnR), .sw(sw),
            .x(x), .y(y), .xpos(xpos), .ypos(ypos),
            .left(left), .right(right),
           .app_state(app_state), .app_state_new(app_state_new),
           .menu_state(menu_state), .menu_state_new(menu_state_new),
           .led(led_menu),
           .x_cursor(x_cursor_menu), .y_cursor(y_cursor_menu),
           .pixel_idx(pixel_idx), .oled_data(oled_data_menu)); 
    
    tri_task tri_task(.basys_clock(sys_clk), .MIC_IN(MIC_IN),
             .led(led_tri_task), .seg(seg_tri_task), .an(an_tri_task));
    
    mh_task mh_task(.clk(clk6p25), .x(x), .y(y), .sw(sw), .led(led_mh_task), .oled_data(oled_data_mh_task));
    
    kn_task kn_task(.sys_clk(sys_clk), .left(left), .right(right), .middle(middle), .new_event(new_event), .xpos(xpos), .ypos(ypos), .x(x), .y(y),
       .oled_data(oled_data_kn_task), .x_cursor(x_cursor_kn), .y_cursor(y_cursor_kn));
    
    integrated_project integrated_project(.MIC_IN(MIC_IN), .clk(clk6p25), .clk10k(clk10k), .clk20k(clk20k), .x(x), .y(y), .sw(sw), .xpos(xpos), .ypos(ypos), .left(left), .right(right), .led(led_ip), .oled_data(oled_data_ip), .x_cursor(x_cursor_ip), .y_cursor(y_cursor_ip), .an(an_ip), .seg(seg_ip), .dp(dp));    
   
    // mh's dino game
    pongtest pongtest( .sys_clk(sys_clk), .btnC(btnC), .btnU(btnU), .btnD(btnD),
        .left(left), .right(right), .sw(sw), .x(x), .y(y),  .xpos(xpos), .ypos(ypos),
        .pixel_idx(pixel_idx), .oled_data(oled_data_dino),    
        .led(led_dino), .an(an_dino), .seg(seg_dino));
    
    // piano
    piano piano(.clk(sys_clk), .left(left),
    .sw(sw), .xpos(xpos), .ypos(ypos),
    .x(x), .y(y),
    .JX0(JX0), .JX1(JX1), .JX2(JX2), .JX3(JX3), .oled_data(oled_data_piano));
    
    // tricia's visualiser
    visualiser visualiser (.basys_clock(sys_clk), .clk6p25m(clk6p25), .clk20k(clk20k), .sw(sw),
        .MIC_IN(MIC_IN), .pixel_index(pixel_idx), .oled_data(oled_data_vis));
    
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
            an <= an_ip;
            seg <= seg_ip;
            led <= led_ip;
            x_cursor_reg <= x_cursor_ip;
            y_cursor_reg <= y_cursor_ip;
        end
        // Showing Dino game, BUG: not shown
        else if (app_state == 2) begin
            oled_data <= oled_data_dino;
            an <= an_dino;
            seg <= seg_dino;
            led <= led_dino;
        end
        // Showing visualiser
        else if (app_state == 3) begin
            oled_data <= oled_data_vis;
            an <= 4'b1111;
            seg <= 7'b1111111;
            led <= led_vis;
        end
        // piano
        else if (app_state == 4) begin
            oled_data <= oled_data_piano;
            an <= 4'b1111;
            seg <= 7'b1111111;
            led <= led_piano;
        end
        
        // Tricia's base task
        else if (app_state == 5) begin
            oled_data <= oled_data_tri_task;
            an <= an_tri_task;
            seg <= seg_tri_task;
            led <= led_tri_task;
        end
       
        // Kai Ning's base task
        else if (app_state == 6) begin
            oled_data <= oled_data_kn_task;
            an <= 4'b1111;
            seg <= 7'b1111111;
            led <= 16'b0000000000000000;
            x_cursor_reg <= x_cursor_kn;
            y_cursor_reg <= y_cursor_kn;
        end
        
        // Meng Han's base task
        else if (app_state == 7) begin
            oled_data <= oled_data_mh_task;
            an <= 4'b1111;
            seg <= 7'b1111111;
            led <= led_mh_task;
        end

        else begin
            an <= 4'b1111;
            seg <= 7'b1111111;
            led <= 16'b0000000000000000;
        end           

    end // always @
    
endmodule

