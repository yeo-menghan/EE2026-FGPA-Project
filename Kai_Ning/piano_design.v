`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2023 23:23:37
// Design Name: 
// Module Name: piano_design
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module piano_design(
input clk, left, SW5,
input [11:0]xpos, input [11:0]ypos,
input [6:0]x, input [5:0]y,
output JX0,
output JX1,
output JX2,
output JX3,
output reg [15:0] oled_data

    );
   parameter [15:0] black = 16'b00000_000000_00000;
   parameter [15:0] white = 16'b11111_111111_11111;
   parameter [15:0] grey = 16'b10011_110100_11100;
   
   reg [6:0] x_cursor;
   reg [5:0] y_cursor; 

wire clock50, clock20, clock4185, clock4420, clock4780, clock5100, clock5300, clock5650, clock6070, clock6380, clock6830, clock7230, clock7640, clock8070, clock8500, clock8850, clock9210, clock9650;
     my_clock clk50M(clk, 50000000, clock50);
     my_clock clk20k(clk, 20000, clock20);
     my_clock clk4185(clk, 4185, clock4185);
     my_clock clk4420(clk, 4420, clock4420);
     my_clock clk4780(clk, 4780, clock4780);
     my_clock clk5100(clk, 5100, clock5100);
     my_clock clk5300(clk, 5300, clock5300);
     my_clock clk5650(clk, 5650, clock5650);
     my_clock clk6070(clk, 6070, clock6070);
     my_clock clk6380(clk, 6380, clock6380);
     my_clock clk6830(clk, 6830, clock6830);
     my_clock clk7230(clk, 7230, clock7230);
     my_clock clk7640(clk, 7640, clock7640);
     my_clock clk8070(clk, 8070, clock8070);
     my_clock clk8500(clk, 8500, clock8500);
     my_clock clk8850(clk, 8500, clock8850);
     my_clock clk9210(clk, 9210, clock9210);
     my_clock clk9650(clk, 9650, clock9650);  
   
   reg [11:0] audio0 = 0, audio1 = 0, audio2 = 0, audio3 = 0, audio4 = 0, audio5 = 0, audio6 = 0, audio7 = 0, audio8 = 0, audio9 = 0, audio10 = 0, audio11 = 0, audio12 = 0, audio13 = 0, audio14 = 0, audio15 = 0;
   reg [11:0] audio_output = 0;
   reg [31:0] timer = 3000000;
   reg generate_signal = 0;
   reg [4:0] m = 0;
   reg [31:0] count = 3000000;
   reg [4:0] counter = 0;
   
    always @ (posedge clk) begin

          x_cursor <= (xpos * 10) / 101; 
          y_cursor <= ypos * 10 / 101;
            
          if (left == 1 || SW5 == 1) begin
              if (
              (x_cursor >= 3 && x_cursor < 10 && y_cursor >= 0 && y_cursor < 28) || (x_cursor >= 3 && x_cursor < 12 && y_cursor >= 28 && y_cursor <=63)
              ) m = 1;
              else if (
              (x_cursor >= 10 && x_cursor < 15 && y_cursor >= 0 && y_cursor < 28)
              ) m = 2;
              else if (
              (x_cursor >= 15 && x_cursor < 20 && y_cursor >= 0 && y_cursor < 28) || (x_cursor >= 13 && x_cursor < 22 && y_cursor >= 28 && y_cursor <=63)
              ) m = 3;
              else if (
              (x_cursor >= 20 && x_cursor < 25 && y_cursor >= 0 && y_cursor < 28)
              ) m = 4;
              else if (
              (x_cursor >= 25 && x_cursor < 32 && y_cursor >= 0 && y_cursor < 28) || (x_cursor >= 23 && x_cursor < 32 && y_cursor >= 28 && y_cursor <=63)
              ) m = 5;
              else if (
              (x_cursor >= 33 && x_cursor < 40 && y_cursor >= 0 && y_cursor < 28) || (x_cursor >= 33 && x_cursor < 42 && y_cursor >= 28 && y_cursor <=63)
              ) m = 6;
              else if (
              (x_cursor >= 40 && x_cursor < 45 && y_cursor >= 0 && y_cursor < 28)
              ) m = 7;
              else if (
              (x_cursor >= 45 && x_cursor < 50 && y_cursor >= 0 && y_cursor < 28) || (x_cursor >= 43 && x_cursor < 52 && y_cursor >= 28 && y_cursor <=63)
              ) m = 8; 
              else if (
              (x_cursor >= 50 && x_cursor < 55 && y_cursor >= 0 && y_cursor < 28)
              ) m = 9;
              else if (
              (x_cursor >= 55 && x_cursor < 60 && y_cursor >= 0 && y_cursor < 28) || (x_cursor >= 53 && x_cursor < 62 && y_cursor >= 28 && y_cursor <=63)
              ) m = 10;
              else if (
              (x_cursor >= 60 && x_cursor < 65 && y_cursor >= 0 && y_cursor < 28)
              ) m = 11;
              else if (
              (x_cursor >= 65 && x_cursor < 72 && y_cursor >= 0 && y_cursor < 28) || (x_cursor >= 63 && x_cursor < 72 && y_cursor >= 28 && y_cursor <=63)
              ) m = 12;
              else if (
              (x_cursor >= 73 && x_cursor < 80 && y_cursor >= 0 && y_cursor < 28) || (x_cursor >= 73 && x_cursor < 82 && y_cursor >= 28 && y_cursor <=63)
              ) m = 13;
              else if (
              (x_cursor >= 80 && x_cursor < 85 && y_cursor >= 0 && y_cursor < 28)
              ) m = 14;
              else if (
              (x_cursor >= 85 && x_cursor < 90 && y_cursor >= 0 && y_cursor < 28) || (x_cursor >= 83 && x_cursor < 92 && y_cursor >= 28 && y_cursor <=63)
              ) m = 15;
              else if (
              (x_cursor >= 90 && x_cursor < 92 && y_cursor >= 0 && y_cursor < 28)
              ) m = 16;
              else m = 0;
              
             generate_signal <= 1;
                            
          end   
             
              
             if (generate_signal) begin
                 timer <= timer - 1;
                 if (timer == 0) begin
                     timer <= 3000000;
                     generate_signal <= 0;
                     end
                 end
           
        if (x == x_cursor && y== y_cursor) 
              oled_data <= 16'b11111_000000_00000;
        else if (
            (x >= 0 && x < 3 && y >= 0 && y <=63) || (x >= 32 && x < 33 && y >= 0 && y < 28) || (x >= 72 && x < 73 && y >= 0 && y < 28) || (x > 92 && x <= 95 && y >= 0 && y <=63) ||
            (x >= 12 && x < 13 && y >= 28 && y <=63) || (x >= 22 && x < 23 && y >= 28 && y <=63) || (x >= 32 && x < 33 && y >= 28 && y <=63) || (x >= 42 && x < 43 && y >= 28 && y <=63) || (x >= 52 && x < 53 && y >= 28 && y <=63) || (x >= 62 && x < 63 && y >= 28 && y <=63) || (x >= 72 && x < 73 && y >= 28 && y <=63)|| (x >= 82 && x < 83 && y >= 28 && y <=63)
            ) oled_data <= grey;
        else if (
            (x >= 3 && x < 10 && y >= 0 && y < 28) || (x >= 15 && x < 20 && y >= 0 && y < 28) || (x >= 25 && x < 32 && y >= 0 && y < 28) || (x >= 33 && x < 40 && y >= 0 && y < 28) || (x >= 45 && x < 50 && y >= 0 && y < 28) || (x >= 55 && x < 60 && y >= 0 && y < 28) || (x >= 65 && x < 72 && y >= 0 && y < 28) || (x >= 73 && x < 80 && y >= 0 && y < 28) || (x >= 85 && x < 90 && y >= 0 && y < 28) ||
            (x >= 3 && x < 12 && y >= 28 && y <=63) || (x >= 13 && x < 22 && y >= 28 && y <=63) || (x >= 23 && x < 32 && y >= 28 && y <=63) || (x >= 33 && x < 42 && y >= 28 && y <=63) || (x >= 43 && x < 52 && y >= 28 && y <=63) || (x >= 53 && x < 62 && y >= 28 && y <=63) || (x >= 63 && x < 72 && y >= 28 && y <=63) || (x >= 73 && x < 82 && y >= 28 && y <=63) || (x >= 83 && x < 92 && y >= 28 && y <=63)
            ) oled_data <= white;
        else if (
            (x >= 10 && x < 15 && y >= 0 && y < 28) || (x >= 20 && x < 25 && y >= 0 && y < 28) || (x >= 40 && x < 45 && y >= 0 && y < 28) || (x >= 50 && x < 55 && y >= 0 && y < 28) || (x >= 60 && x < 65 && y >= 0 && y < 28) || (x >= 80 && x < 85 && y >= 0 && y < 28) || (x >= 90 && x < 92 && y >= 0 && y < 28)
            ) oled_data <= black;   
    end
    
       always @ (posedge clock4185)
           begin
           if (generate_signal) begin
               audio0 <= (audio0 == 0) ? 12'b010000000000 : 0;
           end
       end
       
        always @ (posedge clock4420)
             begin
             if (generate_signal) begin
                 audio1 <= (audio1 == 0) ? 12'b010000000000 : 0;
             end
         end
         
        always @ (posedge clock4780)
               begin
               if (generate_signal) begin
                   audio2 <= (audio2 == 0) ? 12'b010000000000 : 0;
               end
           end
     
       always @ (posedge clock5100)
                 begin
                 if (generate_signal) begin
                     audio3 <= (audio3 == 0) ? 12'b010000000000 : 0;
                 end
             end   
       always @ (posedge clock5300)
                   begin
                   if (generate_signal) begin
                       audio4 <= (audio4 == 0) ? 12'b010000000000 : 0;
                   end
               end 
       always @ (posedge clock5650)
                     begin
                     if (generate_signal) begin
                         audio5 <= (audio5 == 0) ? 12'b010000000000 : 0;
                     end
                 end  
       always @ (posedge clock6070)
                       begin
                       if (generate_signal) begin
                           audio6 <= (audio6 == 0) ? 12'b010000000000 : 0;
                       end
                   end            
       always @ (posedge clock6380)
                         begin
                         if (generate_signal) begin
                             audio7 <= (audio7 == 0) ? 12'b010000000000 : 0;
                         end
                     end             
       always @ (posedge clock6830)
                       begin
                       if (generate_signal) begin
                           audio8 <= (audio8 == 0) ? 12'b010000000000 : 0;
                       end
                   end             
       always @ (posedge clock7230)
                        begin
                        if (generate_signal) begin
                            audio9 <= (audio9 == 0) ? 12'b010000000000 : 0;
                        end
                    end      
       always @ (posedge clock7640)
                        begin
                        if (generate_signal) begin
                             audio10 <= (audio10 == 0) ? 12'b010000000000 : 0;
                        end
                     end      
       always @ (posedge clock8070)
                        begin
                        if (generate_signal) begin
                             audio11 <= (audio11 == 0) ? 12'b010000000000 : 0;
                        end
                      end      
       always @ (posedge clock8500)
                        begin
                        if (generate_signal) begin
                             audio12 <= (audio12 == 0) ? 12'b010000000000 : 0;
                        end
                      end      
       always @ (posedge clock8850)
                        begin
                        if (generate_signal) begin
                            audio13 <= (audio13 == 0) ? 12'b010000000000 : 0;
                        end
                       end   
     always @ (posedge clock9210)
                        begin
                        if (generate_signal) begin
                             audio14 <= (audio14 == 0) ? 12'b010000000000 : 0;
                        end
                     end      
      always @ (posedge clock9650)
                       begin
                       if (generate_signal) begin
                             audio15 <= (audio15 == 0) ? 12'b010000000000 : 0;
                        end
                      end      
                      
       always @ (posedge clk) begin
       if (SW5 == 0) begin
       case (m)
        1: audio_output <= audio0;
        2: audio_output <= audio1;
        3: audio_output <= audio2;
        4: audio_output <= audio3;
        5: audio_output <= audio4;
        6: audio_output <= audio5;
        7: audio_output <= audio6;
        8: audio_output <= audio7;
        9: audio_output <= audio8;
        10: audio_output <= audio9;
        11: audio_output <= audio10;
        12: audio_output <= audio11;
        13: audio_output <= audio12;
        14: audio_output <= audio13;
        15: audio_output <= audio14;
        16: audio_output <= audio15;
        endcase
        end
        
        else if (SW5 == 1) begin
        count <= count - 1;
        if (count == 0) begin
            counter <= counter + 1; 
            count <= 3000000; 
        end
        case (counter)
        0: begin
        audio_output <= audio0;
        end
        1: begin
        audio_output <= audio2;
        end
        2: begin
        audio_output <= audio4;
        end
        3: begin
        audio_output <= audio0;
        end        
        4: begin
        audio_output <= audio0;
        end        
        5: begin
        audio_output <= audio2;
        end        
        6: begin
        audio_output <= audio4;
        end        
        7: begin
        audio_output <= audio0;
        end        
        8: begin
        audio_output <= audio4;
        end        
        9: begin
        audio_output <= audio5;
        end        
        10: begin
        audio_output <= audio9;
        end        
        11: begin
        audio_output <= 0;
        end
        default: counter = 0;
        endcase
        end
        end
                                                  
       Audio_Output boomz(
       .CLK(clock50), 
       .START(clock20),
       .DATA1(audio_output), 
       .DATA2(0),
       //.RST(0),
       .D1(JX1),
       .D2(JX2),
       .CLK_OUT(JX3),
       .nSYNC(JX0));
    
endmodule
