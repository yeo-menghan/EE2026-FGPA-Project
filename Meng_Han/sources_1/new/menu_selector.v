`timescale 1ns / 1ps

// TODO: insert mouse capabilities

module menu_selector(input clk, btnC, btnL, btnR, input [15:0]sw,
                    input [6:0] x, input [5:0] y, input [11:0] xpos, input [11:0] ypos,
                    input left, right,
                    input [4:0]app_state, output reg [4:0]app_state_new,
                    input [4:0]menu_state, output reg [4:0]menu_state_new,
                    output reg [7:0] x_cursor, output reg [6:0] y_cursor
                     );
    
    reg [31:0] counter = 0;
    
    always @ (posedge clk) begin
        if (app_state == 0) begin // Displaying the menu
            counter <= 0;
            // insert parallel left-click & scrollable mouse capabilities
            
            if (btnL == 1) begin 
                menu_state_new <= (menu_state >= 1) ? menu_state - 1 : 6; // loop back to 6
            end
            else if (btnR == 1) begin
                menu_state_new <= (menu_state <= 5) ? menu_state + 1 : 0; // loop back to 0
            end
            else if (btnC == 1) begin
                app_state_new <= menu_state + 1;
            end
        end
        
        // insert right mouse click to go back?
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
    end

endmodule
