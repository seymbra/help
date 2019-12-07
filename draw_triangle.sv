`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2019 04:50:55 PM
// Design Name: 
// Module Name: draw_triangle
// Additional Comments:  
//  Triangle algorithm from "A more efficient
//  triangle rasterization algorithm implemented in FPGA" by X Qang, F Guo, M Zhu.
//  https://ieeexplore.ieee.org/document/6376782
// 
//////////////////////////////////////////////////////////////////////////////////


module draw_triangle (  input vclock_in,
                                       input sysclk,
                                       input signed  [23:0] triangle   [2:0][3:0],
                                       input signed [12:0] hcount_in, 
                                       input signed [11:0] vcount_in,
                                       output logic [11:0] rgb_out
                                       );
    
    parameter X_OFFSET = 24,
                        Y_OFFSET = 24;
    
    logic signed [28:0] e1, e2, e3;
    logic [8:0] i = 1;
    logic [8:0] j = 1;
    logic ifflag=0;
    logic updateflag = 0;
    logic signed [19:0] x1, x2, x3;
    logic signed [19:0] y1, y2, y3;
    logic [11:0] pixel = 0;


//    assign rgb_out = pixel;                               
/*    always_ff @(posedge vclock_in) begin
//        if(~|hcount_in && ~|vcount_in) begin
//            updateflag = 1;
        for(int k = 0; k <20; k++) begin
            for(int l = 0; l<10; l++) begin
            
//                        x1 = j*X_OFFSET;
//                        x2 = (j+1)*X_OFFSET;
//                        y1 = i*Y_OFFSET;
//                        y2 = (i+1)*Y_OFFSET;
//                        y3 = (i+1)*Y_OFFSET;
//                        x3 = (j+1)*X_OFFSET;
//                        e1<=-(y2-y1)*(hcount_in-x1)+(x2-x1)*(vcount_in-y1);
//                        e2<=-(y3-y2)*(hcount_in-x2)+(x3-x2)*(vcount_in-y2);
//                        e3<=-(y1-y3)*(hcount_in-x3)+(x1-x3)*(vcount_in-y3);
//                        if((e1 >= 0) && (e2 >= 0) && (e3 >= 0)) begin
//                                pixel[3:0] <= block_colors[(i*10)+j][0]*15;
//                                pixel[7:4] <= block_colors[(i*10)+j][1]*15;
//                                pixel[11:8] <= block_colors[(i*10)+j][2]*15;
//                                end
//                        end // if check for color
                
                //indexing into game_board, first i iteration will result in all zeros when
                // checking for a color, thus separate if to catch that error and correct
                if( i == 0) begin
                    //offset x and y from gameboard vector to actual position
                    if( block_colors[j] >= 1) begin // if there is a piece of a tetronimo at this location
                        //set the x and y location in 2 dimensions
                        x1 = j*X_OFFSET;
                        x2 = (j+1)*X_OFFSET;
                        y1 = i*Y_OFFSET;
                        y2 = (i+1)*Y_OFFSET;
                        y3 = (i+1)*Y_OFFSET;
                        x3 = (j+1)*X_OFFSET;
                        e1<=-(y2-y1)*(hcount_in-x1)+(x2-x1)*(vcount_in-y1);
                        e2<=-(y3-y2)*(hcount_in-x2)+(x3-x2)*(vcount_in-y2);
                        e3<=-(y1-y3)*(hcount_in-x3)+(x1-x3)*(vcount_in-y3);
                        if((e1 >= 0) && (e2 >= 0) && (e3 >= 0)) begin
                                pixel[3:0] <= block_colors[(i*10)+j][0]*15;
                                pixel[7:4] <= block_colors[(i*10)+j][1]*15;
                                pixel[11:8] <= block_colors[(i*10)+j][2]*15;
                                end
                        end // if check for color
                    else begin
                        pixel <= 0;
                        end // if color check else
                end
                
                else begin
                    // complete repeat of code above with exception of indexing into block color array
                     if( block_colors[(i*10)+j] >= 1) begin // if there is a piece of a tetronimo at this location
                        x1 = j*X_OFFSET;
                        x2 = (j+1)*X_OFFSET;
                        y1 = i*Y_OFFSET;
                        y2 = (i+1)*Y_OFFSET;
                        y3 = (i+1)*Y_OFFSET;
                        x3 = (j+1)*X_OFFSET;
                        e1<=-(y2-y1)*(hcount_in-x1)+(x2-x1)*(vcount_in-y1);
                        e2<=-(y3-y2)*(hcount_in-x2)+(x3-x2)*(vcount_in-y2);
                        e3<=-(y1-y3)*(hcount_in-x3)+(x1-x3)*(vcount_in-y3);
                        if((e1 >= 0) && (e2 >= 0) && (e3 >= 0)) begin
                                pixel[3:0] <= block_colors[(i*10)+j][0]*15;
                                pixel[7:4] <= block_colors[(i*10)+j][1]*15;
                                pixel[11:8] <= block_colors[(i*10)+j][2]*15;
                                end
                        end // if check for color
                    else begin
                        pixel <= 0;
                        end // if color check else
                    end
                
                j <= j == 9? 0: j+1;
                end //j loop
            i <= i == 19? 0: i + 1;
            end // i loop
        end //always_ff  */
            

// Functioning code to draw one triangle.
always_ff @(posedge sysclk) begin
        e1 = - (y2-y1)*(hcount_in-x1)+(x2-x1)*(vcount_in-y1);
        e2 = - (y3-y2)*(hcount_in-x2)+(x3-x2)*(vcount_in-y2);
        e3 = - (y1-y3)*(hcount_in-x3)+(x1-x3)*(vcount_in-y3);
        if((e1 >= 0) && (e2 >= 0) && (e3 >= 0)) begin
                ifflag <= 1;
                pixel <= 12'hFFF;
                end
        else begin
            ifflag <= 0;
            pixel <= 0;
            end 
    
        end //always ff 400mhz


//looping every piece of the board every clock cycle
//always_ff @(posedge vclock_in) begin
//            for(int k = 0; k <20; k++) begin
//                for(int l = 0; l<10; l++) begin
//                //indexing into game_board, first i iteration will result in all zeros when
//                // checking for a color, thus separate if to catch that error and correct
//                if( i == 0) begin
//                    //offset x and y from gameboard vector to actual position
//                    if( block_colors[j] >= 1) begin // if there is a piece of a tetronimo at this location
//                        //set the x and y location in 2 dimensions
//                        x1 <= j*X_OFFSET;
//                        x2 <= (j+1)*X_OFFSET;
//                        y1 <= i*Y_OFFSET;
//                        y2 <= (i+1)*Y_OFFSET;
//                        y3 <= (i+1)*Y_OFFSET;
//                        x3 <= (j+1)*X_OFFSET;
//                        rgb_out <= pixel; //|pixel ? block_colors[j] : 0;
//                        end
////                    else begin
////                        rgb_out <= 0;
////                        end // if color check else
//                    end
                
//                else begin
//                    // complete repeat of code above with exception of indexing into block color array
//                     if( block_colors[(i*10)+j] >= 1) begin // if there is a piece of a tetronimo at this location
//                        x1 <= j*X_OFFSET;
//                        x2 <= (j+1)*X_OFFSET;
//                        y1 <= i*Y_OFFSET;
//                        y2 <= (i+1)*Y_OFFSET;
//                        y3 <= (i+1)*Y_OFFSET;
//                        x3 <= (j+1)*X_OFFSET;
//                        rgb_out <= pixel;// |pixel ? block_colors[ (i*10) + j ] : 0;
//                        end
////                    else begin
////                        rgb_out <= 0;
////                        end // if color check else
//                    end
//                j <= j == 9? 0: j+1;
//                end //j loop
//            i <= i == 19? 0: i + 1;
//            end // i loop
            
//            end //always_ff vclock
endmodule
