`timescale 1ns / 1ps

// integrate menu selector with menu? so that mouse state won't have to bounce back and forth

module menu(
        input clk, btnC, btnL, btnR, input [15:0]sw,
        input [6:0] x, input [5:0] y, input [11:0] xpos, input [11:0] ypos,
        input left, right,
        input [4:0]app_state, output reg [4:0]app_state_new,
        input [4:0]menu_state, output reg [4:0]menu_state_new,
        output reg [15:0] led,
        output reg [7:0] x_cursor, output reg [6:0] y_cursor,
        input [12:0] pixel_idx, output reg [15:0] oled_data);

    wire [15:0] oled_menu_ip, oled_menu_A, oled_menu_B, oled_menu_C, oled_menu_visualiser, oled_menu_drawing, oled_menu_dino;
    reg [31:0] counter = 0;
   
   wire border_left, border_right;
   assign border_left = (x==15&&y>=0&&y<=63);
   assign border_right = (x==80&&y>=0&&y<=63); 
   
    menu_visualiser visualiser_display (clk, pixel_idx, oled_menu_visualiser);
    menu_drawing drawing_display (clk, pixel_idx, oled_menu_drawing);
    menu_dino dino_display (clk, pixel_idx, oled_menu_dino);
    menu_IP IP_display (clk, pixel_idx, oled_menu_ip);
    menu_A A_display (clk, pixel_idx, oled_menu_A);
    menu_B B_display (clk, pixel_idx, oled_menu_B);
    menu_C C_display (clk, pixel_idx, oled_menu_C);
    
    always @ (posedge clk) begin
        // insert mouse capabilities and tie in with each of the cases
          led[13] <= 1;
          x_cursor <= (xpos * 10) / 101; 
          y_cursor <= (ypos * 10) / 101;
            if (app_state == 0) begin // Displaying the menu
                 counter <= 0;
                 // insert parallel left-click & scrollable mouse capabilities
                 if (btnL == 1) begin 
                     menu_state_new <= (menu_state >= 1) ? menu_state - 1 : 6; // loop back to 6
                 end
                 else if (btnR == 1) begin
                     menu_state_new <= (menu_state <= 5) ? menu_state + 1 : 0; // loop back to 0
                 end
                 else if ((btnC == 1) || (x_cursor == (x>=15&&x<=80) && (left == 1))) begin
                     app_state_new <= menu_state + 1;
                 end
                 
                 if(x_cursor == (x<15)) begin
                    led[14] <= 1;
                 end
                 
                 if(left == 1) begin
                    led[0] <= 1;
                    if (x_cursor == (x<15)) begin
                        menu_state_new <= (menu_state >= 1) ? menu_state - 1 : 6; // loop back to 6
                    end
                    else if ((x_cursor == (x>=80))) begin
                         menu_state_new <= (menu_state >= 1) ? menu_state - 1 : 6; // loop back to 6
                    end
                    else if (x_cursor == (x>=15&&x<=80))begin
                        app_state_new <= menu_state + 1;
                    end
                 end
               
             end
              else if (sw[15] == 1) begin
                 if (counter == 25000000) begin
                     counter <= 0;
                     app_state_new <= 0; // Back to menu
                 end
                 else begin
                     counter <= counter + 1;
                 end
             end
             else begin
                 counter <= 0;
             end
       
            // cursor control
             if(x == x_cursor && y == y_cursor) begin // center dot of the cursor
               oled_data = 16'b11111_000000_00000;
             end 
             else if (x >= x_cursor-1 && x <= x_cursor+1 && y == y_cursor+1) begin
             // top row of the 3x3 cursor
                 oled_data = 16'b11111_000000_00000;
             end
             else if (x >= x_cursor-1 && x <= x_cursor+1 && y == y_cursor-1) begin
             // bottom row of the 3x3 cursor
                 oled_data = 16'b11111_000000_00000;
             end
             else if (x == x_cursor+1 && y >= y_cursor-1 && y <= y_cursor+1) begin
             // left column of the 3x3 cursor
                 oled_data = 16'b11111_000000_00000;
             end
             else if (x== x_cursor-1 && y >= y_cursor-1 && y <= y_cursor+1) begin
             // right column of the 3x3 cursor
                 oled_data = 16'b11111_000000_00000;
             end
            else begin
            case (menu_state)
                0: oled_data = oled_menu_ip;  //integrated project
                1: oled_data = oled_menu_dino; // dino game
                2: oled_data = oled_menu_visualiser; // audio visualiser
                3: oled_data = oled_menu_drawing; // drawing game                    
                4: oled_data = oled_menu_A; // subtask A
                5: oled_data = oled_menu_B; // subtask B
                6: oled_data = oled_menu_C; // subtask C
            endcase
            end
            
            if(border_left) begin
                oled_data = 16'b00000_111111_00000;
            end
            if(border_right) begin
                oled_data = 16'b00000_111111_00000;
            end
    end
endmodule

