`timescale 1ns / 1ps

module display(
    //for oled
    input clk6p25m, basys_clock,
    input [12:0] pixel_index,
    output reg [15:0] oled_data,
    //for clock
    input [11:0] MIC_IN
);
    
     //assigning coordinates (from 0 to 6143)
     wire [7:0] xx; //96
     wire [6:0] yy;  //64
     assign xx = pixel_index%96;
     assign yy = pixel_index/96;
     
     //drawing borders of the box
     wire top, left, right, bottom, box;
     assign top = (xx>=37 && xx<=58 && yy>=19 && yy<=20); 
     assign left = (xx>=37 && xx<=38 && yy>=21 && yy<=42); 
     assign right = (xx>=57 && xx<=58 && yy>=21 && yy<=42); 
     assign bottom = (xx>=37 && xx<=58 && yy>=41 && yy<=42); 
     assign box = top || left || right || bottom;
     
     //custom pixels increase for volume depending on volume level
     reg [5:0] increase; //the increase in height of volume bar for main bar
     wire [4:0] vol;
     edited_volume_level vollvl(.basys_clock(basys_clock), .MIC_IN(MIC_IN), .audio_level(vol));
     
     always@(vol)
     begin
        case(vol)
            4'd1:
            increase <= 2;
            4'd2:
            increase <= 4;
            4'd3:
            increase <= 6;
            4'd4:
            increase <= 8;
            4'd5:
            increase <= 10;
            4'd6:
            increase <= 12;
            4'd7:
            increase <= 14;
            4'd8:
            increase <= 16;
            4'd9:
            increase <= 18;
            default:
            increase <= 0;
        endcase
     end
  
     //to change position of bars
     wire clk;
     wire [3:0] control_counter;
     clock_divider rr(basys_clock, 4, clk);
     change_bars count(.control_clock(clk), .control_counter(control_counter));
     
     
     //visualiser
     reg [10:0] peak;
     always@(*)
     begin
        case(control_counter)
            4'd0:
                peak[0] <= (xx>=37 && xx<=38 && yy>=(18-increase) && yy<=18) || (xx>=57 && xx<=58 && yy>=43 && yy<=(43+increase))  || (xx>=59 && xx<=(59+increase) && yy>=19 && yy<=20) || (xx<=36 && xx>=(36-increase) && yy>=41 && yy<=42);
            4'd1:
                peak[1] <= (xx>=39 && xx<=40 && yy>=(18-increase) && yy<=18) || (xx>=55 && xx<=56 && yy>=43 && yy<=(43+increase))  || (xx>=59 && xx<=(59+increase) && yy>=21 && yy<=22) || (xx<=36 && xx>=(36-increase) && yy>=39 && yy<=40);
            4'd2:
                peak[2] <= (xx>=41 && xx<=42 && yy>=(18-increase) && yy<=18) || (xx>=53 && xx<=54 && yy>=43 && yy<=(43+increase))  || (xx>=59 && xx<=(59+increase) && yy>=23 && yy<=24) || (xx<=36 && xx>=(36-increase) && yy>=37 && yy<=38);
            4'd3:
                peak[3] <= (xx>=43 && xx<=44 && yy>=(18-increase) && yy<=18) || (xx>=51 && xx<=52 && yy>=43 && yy<=(43+increase))  || (xx>=59 && xx<=(59+increase) && yy>=25 && yy<=26) || (xx<=36 && xx>=(36-increase) && yy>=35 && yy<=36);
            4'd4:
                peak[4] <= (xx>=45 && xx<=46 && yy>=(18-increase) && yy<=18) || (xx>=49 && xx<=50 && yy>=43 && yy<=(43+increase))  || (xx>=59 && xx<=(59+increase) && yy>=27 && yy<=28) || (xx<=36 && xx>=(36-increase) && yy>=33 && yy<=34);
            4'd5:
                peak[5] <= (xx>=47 && xx<=48 && yy>=(18-increase) && yy<=18)|| (xx>=47 && xx<=48 && yy>=43 && yy<=(43+increase))  || (xx>=59 && xx<=(59+increase) && yy>=29 && yy<=30) || (xx<=36 && xx>=(36-increase) && yy>=31 && yy<=32);
            4'd6:
                peak[6] <= (xx>=49 && xx<=50 && yy>=(18-increase) && yy<=18)|| (xx>=45 && xx<=46 && yy>=43 && yy<=(43+increase))  || (xx>=59 && xx<=(59+increase) && yy>=31 && yy<=32) || (xx<=36 && xx>=(36-increase) && yy>=29 && yy<=30);
            4'd7:
                peak[7] <= (xx>=51 && xx<=52 && yy>=(18-increase) && yy<=18) || (xx>=43 && xx<=44 && yy>=43 && yy<=(43+increase))  || (xx>=59 && xx<=(59+increase) && yy>=33 && yy<=34) || (xx<=36 && xx>=(36-increase) && yy>=27 && yy<=28);
            4'd8:
                peak[8] <= (xx>=53 && xx<=54 && yy>=(18-increase) && yy<=18) || (xx>=41 && xx<=42 && yy>=43 && yy<=(43+increase))  || (xx>=59 && xx<=(59+increase) && yy>=35 && yy<=36) || (xx<=36 && xx>=(36-increase) && yy>=25 && yy<=26);
            4'd9:
                peak[9] <= (xx>=55 && xx<=56 && yy>=(18-increase) && yy<=18) || (xx>=39 && xx<=40 && yy>=43 && yy<=(43+increase))  || (xx>=59 && xx<=(59+increase) && yy>=37 && yy<=38) || (xx<=36 && xx>=(36-increase) && yy>=23 && yy<=24);
            4'd10:
                 peak[10] <= (xx>=57 && xx<=58 && yy>=(18-increase) && yy<=18) || (xx>=37 && xx<=38 && yy>=43 && yy<=(43+increase))  || (xx>=59 && xx<=(59+increase) && yy>=39 && yy<=40) || (xx<=36 && xx>=(36-increase) && yy>=21 && yy<=22);                    
            default:
                  peak <= (xx>=0 && xx<=1 && yy>=0 && yy<=1);
          endcase
     end

    
     reg [8:0] lvl_bar;
     always@(*)
     begin
     case(vol)
         4'd1:
             lvl_bar[0] <= (xx>=6 && xx<=20 && yy>=50 && yy<=54) || (yy>=50 && yy<=54 && xx>=76 && xx<=90);
         4'd2:
         begin
             lvl_bar[0] <= (xx>=6 && xx<=20 && yy>=50 && yy<=54) || (yy>=50 && yy<=54 && xx>=76 && xx<=90);
             lvl_bar[1] <= (xx>=6 && xx<=20 && yy>=45 && yy<=49) || (yy>=45 && yy<=49 && xx>=76 && xx<=90);    
         end
         4'd3:
         begin
             lvl_bar[0] <= (xx>=6 && xx<=20 && yy>=50 && yy<=54) || (yy>=50 && yy<=54 && xx>=76 && xx<=90);
             lvl_bar[1] <= (xx>=6 && xx<=20 && yy>=45 && yy<=49) || (yy>=45 && yy<=49 && xx>=76 && xx<=90);    
             lvl_bar[2] <= (xx>=6 && xx<=20 && yy>=40 && yy<=44) || (yy>=40 && yy<=44 && xx>=76 && xx<=90);
         end
         4'd4:
         begin
             lvl_bar[0] <= (xx>=6 && xx<=20 && yy>=50 && yy<=54) || (yy>=50 && yy<=54 && xx>=76 && xx<=90);
             lvl_bar[1] <= (xx>=6 && xx<=20 && yy>=45 && yy<=49) || (yy>=45 && yy<=49 && xx>=76 && xx<=90);    
             lvl_bar[2] <= (xx>=6 && xx<=20 && yy>=40 && yy<=44) || (yy>=40 && yy<=44 && xx>=76 && xx<=90);
             lvl_bar[3] <= (xx>=6 && xx<=20 && yy>=35 && yy<=39) || (yy>=35 && yy<=39 && xx>=76 && xx<=90);
         end
         4'd5:
         begin
             lvl_bar[0] <= (xx>=6 && xx<=20 && yy>=50 && yy<=54) || (yy>=50 && yy<=54 && xx>=76 && xx<=90);
             lvl_bar[1] <= (xx>=6 && xx<=20 && yy>=45 && yy<=49) || (yy>=45 && yy<=49 && xx>=76 && xx<=90);    
             lvl_bar[2] <= (xx>=6 && xx<=20 && yy>=40 && yy<=44) || (yy>=40 && yy<=44 && xx>=76 && xx<=90);
             lvl_bar[3] <= (xx>=6 && xx<=20 && yy>=35 && yy<=39) || (yy>=35 && yy<=39 && xx>=76 && xx<=90);
             lvl_bar[4] <= (xx>=6 && xx<=20 && yy>=30 && yy<=34) || (yy>=30 && yy<=34 && xx>=76 && xx<=90);
         end
         4'd6:
         begin
             lvl_bar[0] <= (xx>=6 && xx<=20 && yy>=50 && yy<=54) || (yy>=50 && yy<=54 && xx>=76 && xx<=90);
             lvl_bar[1] <= (xx>=6 && xx<=20 && yy>=45 && yy<=49) || (yy>=45 && yy<=49 && xx>=76 && xx<=90);    
             lvl_bar[2] <= (xx>=6 && xx<=20 && yy>=40 && yy<=44) || (yy>=40 && yy<=44 && xx>=76 && xx<=90);
             lvl_bar[3] <= (xx>=6 && xx<=20 && yy>=35 && yy<=39) || (yy>=35 && yy<=39 && xx>=76 && xx<=90);
             lvl_bar[4] <= (xx>=6 && xx<=20 && yy>=30 && yy<=34) || (yy>=30 && yy<=34 && xx>=76 && xx<=90);
             lvl_bar[5] <= (xx>=6 && xx<=20 && yy>=25 && yy<=29) || (yy>=25 && yy<=29 && xx>=76 && xx<=90);
         end
         4'd7:
         begin
             lvl_bar[0] <= (xx>=6 && xx<=20 && yy>=50 && yy<=54) || (yy>=50 && yy<=54 && xx>=76 && xx<=90);
             lvl_bar[1] <= (xx>=6 && xx<=20 && yy>=45 && yy<=49) || (yy>=45 && yy<=49 && xx>=76 && xx<=90);    
             lvl_bar[2] <= (xx>=6 && xx<=20 && yy>=40 && yy<=44) || (yy>=40 && yy<=44 && xx>=76 && xx<=90);
             lvl_bar[3] <= (xx>=6 && xx<=20 && yy>=35 && yy<=39) || (yy>=35 && yy<=39 && xx>=76 && xx<=90);
             lvl_bar[4] <= (xx>=6 && xx<=20 && yy>=30 && yy<=34) || (yy>=30 && yy<=34 && xx>=76 && xx<=90);
             lvl_bar[5] <= (xx>=6 && xx<=20 && yy>=25 && yy<=29) || (yy>=25 && yy<=29 && xx>=76 && xx<=90);
             lvl_bar[6] <= (xx>=6 && xx<=20 && yy>=20 && yy<=24) || (yy>=20 && yy<=24 && xx>=76 && xx<=90);  
         end
         4'd8:
         begin
             lvl_bar[0] <= (xx>=6 && xx<=20 && yy>=50 && yy<=54) || (yy>=50 && yy<=54 && xx>=76 && xx<=90);
             lvl_bar[1] <= (xx>=6 && xx<=20 && yy>=45 && yy<=49) || (yy>=45 && yy<=49 && xx>=76 && xx<=90);    
             lvl_bar[2] <= (xx>=6 && xx<=20 && yy>=40 && yy<=44) || (yy>=40 && yy<=44 && xx>=76 && xx<=90);
             lvl_bar[3] <= (xx>=6 && xx<=20 && yy>=35 && yy<=39) || (yy>=35 && yy<=39 && xx>=76 && xx<=90);
             lvl_bar[4] <= (xx>=6 && xx<=20 && yy>=30 && yy<=34) || (yy>=30 && yy<=34 && xx>=76 && xx<=90);
             lvl_bar[5] <= (xx>=6 && xx<=20 && yy>=25 && yy<=29) || (yy>=25 && yy<=29 && xx>=76 && xx<=90);
             lvl_bar[6] <= (xx>=6 && xx<=20 && yy>=20 && yy<=24) || (yy>=20 && yy<=24 && xx>=76 && xx<=90);
             lvl_bar[7] <= (xx>=6 && xx<=20 && yy>=15 && yy<=19) || (yy>=15 && yy<=19 && xx>=76 && xx<=90);
         end
         4'd9:
         begin
             lvl_bar[0] <= (xx>=6 && xx<=20 && yy>=50 && yy<=54) || (yy>=50 && yy<=54 && xx>=76 && xx<=90);
             lvl_bar[1] <= (xx>=6 && xx<=20 && yy>=45 && yy<=49) || (yy>=45 && yy<=49 && xx>=76 && xx<=90);    
             lvl_bar[2] <= (xx>=6 && xx<=20 && yy>=40 && yy<=44) || (yy>=40 && yy<=44 && xx>=76 && xx<=90);
             lvl_bar[3] <= (xx>=6 && xx<=20 && yy>=35 && yy<=39) || (yy>=35 && yy<=39 && xx>=76 && xx<=90);
             lvl_bar[4] <= (xx>=6 && xx<=20 && yy>=30 && yy<=34) || (yy>=30 && yy<=34 && xx>=76 && xx<=90);
             lvl_bar[5] <= (xx>=6 && xx<=20 && yy>=25 && yy<=29) || (yy>=25 && yy<=29 && xx>=76 && xx<=90);
             lvl_bar[6] <= (xx>=6 && xx<=20 && yy>=20 && yy<=24) || (yy>=20 && yy<=24 && xx>=76 && xx<=90);
             lvl_bar[7] <= (xx>=6 && xx<=20 && yy>=15 && yy<=19) || (yy>=15 && yy<=19 && xx>=76 && xx<=90);
             lvl_bar[8] <= (xx>=6 && xx<=20 && yy>=10 && yy<=14) || (yy>=10 && yy<=14 && xx>=76 && xx<=90);
         end
         default:
         begin
            lvl_bar[0] <= (xx>=6 && xx<=20 && yy>=50 && yy<=54) || (yy>=50 && yy<=54 && xx>=76 && xx<=90);
            lvl_bar[1] <= (xx>=6 && xx<=20 && yy>=45 && yy<=49) || (yy>=45 && yy<=49 && xx>=76 && xx<=90);   
            lvl_bar[2] <= (xx>=6 && xx<=20 && yy>=40 && yy<=44) || (yy>=40 && yy<=44 && xx>=76 && xx<=90);
            lvl_bar[3] <= (xx>=6 && xx<=20 && yy>=35 && yy<=39) || (yy>=35 && yy<=39 && xx>=76 && xx<=90);
            lvl_bar[4] <= (xx>=6 && xx<=20 && yy>=30 && yy<=34) || (yy>=30 && yy<=34 && xx>=76 && xx<=90);
            lvl_bar[5] <= (xx>=6 && xx<=20 && yy>=25 && yy<=29) || (yy>=25 && yy<=29 && xx>=76 && xx<=90);
            lvl_bar[6] <= (xx>=6 && xx<=20 && yy>=20 && yy<=24) || (yy>=20 && yy<=24 && xx>=76 && xx<=90);
            lvl_bar[7] <= (xx>=6 && xx<=20 && yy>=15 && yy<=19) || (yy>=15 && yy<=19 && xx>=76 && xx<=90);
            lvl_bar[8] <= (xx>=6 && xx<=20 && yy>=10 && yy<=14) || (yy>=10 && yy<=14 && xx>=76 && xx<=90);    
        end
        endcase
    end


     //colouring - assign oled value
     always @(posedge clk6p25m)  
     begin
        if(peak[0]) 
        begin
            oled_data = 16'b11111_000000_00000; //red
        end
        else if(peak[1]) 
        begin
            oled_data = 16'b01111_000000_00001; //light red
        end
        else if(peak[2]) 
        begin
            oled_data = 16'b01111_001111_00000; //orange
        end
        else if(peak[3]) 
        begin
            oled_data = 16'b11111_011111_00001; //dirty yellow
        end
        else if(peak[4]) 
        begin
            oled_data = 16'b11111_111111_00000; //yellow
        end
        else if(peak[5]) 
        begin
            oled_data = 16'b00001_011111_00000; //light green
        end
        else if(peak[6]) 
        begin
            oled_data = 16'b00000_111111_00000; //green
        end
        else if(peak[7]) 
        begin
            oled_data = 16'b00000_000000_01111; //light blue 
        end
        else if(peak[8]) 
        begin
            oled_data = 16'b00000_000000_11111; //blue
        end
        else if(peak[9]) 
        begin
            oled_data = 16'b00111_000011_01111; //purple
        end
        else if(peak[10]) 
        begin
            oled_data = 16'b01111_000011_11111; //violet
        end
//        else if(peak) 
//        begin
//            oled_data = 16'b00000_111111_00000;
//        end
       else if(lvl_bar[0]) 
       begin
           oled_data = 16'b00000_000000_11111; //dark blue
       end
       else if(lvl_bar[1]) 
       begin
           oled_data = 16'b00000_000000_01111; //light blue
       end
       else if(lvl_bar[2]) 
       begin
           oled_data = 16'b00000_111111_00011; //dark green
       end
       else if(lvl_bar[3]) 
       begin
           oled_data = 16'b00001_001111_00000; //light green
       end
       else if(lvl_bar[4]) 
       begin
           oled_data = 16'b11111_111111_00000; //yellow
       end
       else if(lvl_bar[5]) 
       begin
           oled_data = 16'b01111_001111_00000; //orange
       end
       else if(lvl_bar[6]) 
       begin
           oled_data = 16'b01111_000011_00000; //light red
       end
       else if(lvl_bar[7]) 
       begin
           oled_data = 16'b11111_000000_00000; //darker red 
       end
       else if(lvl_bar[8]) 
       begin
           oled_data = 16'b11111_000000_00011; //darkest red
       end
        else if(box) 
        begin
           oled_data = 16'b01111_011111_00111;
        end
        
        else 
            oled_data = 16'b00000_000000_00000;
     end  
     
endmodule


//counter for changing the bars
module change_bars(
    input control_clock,
    output reg [3:0] control_counter = 0
);

    always@(posedge control_clock)
    begin
        if (control_counter == 4'd10)
            control_counter <=0;
        else
         control_counter <= control_counter + 1;
    end
endmodule