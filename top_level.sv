`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2019 03:47:15 PM
// Design Name: 
// Module Name: top_level
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


module top_level( input clk_100mhz,
//                           input[15:0] sw,
                           input btnc, //btnu, btnl, btnr, btnd,
                           output  [3:0] vga_r,
                           output  [3:0] vga_b,
                           output  [3:0] vga_g,
                           output vga_hs,
                           output vga_vs//,
//                           output[15:0] led,
//                           output ca, cb, cc, cd, ce, cf, cg, dp,  // segments a-g, dp
//                           output[3:0] an    // Display location 0-7
                             );
    
    logic reset,make_build_list;
    logic tpd_delay = 0;
    logic top, bottom, north, east, south, west;
    logic clk_25mhz, clk_65mhz, clk_148mhz, clk_400mhz, vclock, sysclk;
                             
    logic [11:0] h_pixel = 200;
    logic [11:0] hcount;    // pixel number on current line
    logic [10:0] v_pixel = 100;
    logic [10:0] vcount;
    logic vsync, hsync, blank;
    
    logic write_enable = 0;
    logic [19:0] write_addr = 0;
    logic [19:0] read_addr = 0;     // line number
    logic [1:0] matrix_delay = 0;    
    logic [2:0] from_memory_a = 0;
    logic [2:0] from_memory_b = 0;
    
    logic [11:0] pixel;
    logic [11:0] line;
    logic [11:0] box;
    logic [11:0] triangle_to_store;
    logic [11:0] triangle [11:0];
    
    logic [3:0] x_loc = 0;
    logic [4:0] y_loc = 0;
    logic [3:0] z_loc = 0;
    
    logic [2:0] three_bit_counter = 0;
    logic [7:0] build_list_counter  = 0;
    logic [7:0] build_list_length = 0;
    
    logic [23:0] fov = 45;
    logic [5:0] state = 0;

    logic signed [23:0] point1 [3:0];
    logic signed [23:0] point2 [3:0];
    logic signed [23:0] point3 [3:0];
    logic signed [23:0] point4 [3:0];
    logic signed [23:0] point5 [3:0];
    logic signed [23:0] point6 [3:0];
    logic signed [23:0] point7 [3:0];
    logic signed [23:0] point8 [3:0];
    
    logic signed [23:0] triangle1   [2:0][3:0];
    logic signed [23:0] triangle2   [2:0][3:0];
    logic signed [23:0] triangle3   [2:0][3:0];
    logic signed [23:0] triangle4   [2:0][3:0];
    logic signed [23:0] triangle5   [2:0][3:0];
    logic signed [23:0] triangle6   [2:0][3:0];
    logic signed [23:0] triangle7   [2:0][3:0];
    logic signed [23:0] triangle8   [2:0][3:0];
    logic signed [23:0] triangle9   [2:0][3:0];
    logic signed [23:0] triangle10 [2:0][3:0];
    logic signed [23:0] triangle11 [2:0][3:0];
    logic signed [23:0] triangle12 [2:0][3:0];
    
    logic signed [23:0] modified_triangle1[2:0][3:0];
    logic signed [23:0] modified_triangle2[2:0][3:0];
    logic signed [23:0] modified_triangle3[2:0][3:0];
    logic signed [23:0] modified_triangle4[2:0][3:0];
    logic signed [23:0] modified_triangle5[2:0][3:0];
    logic signed [23:0] modified_triangle6[2:0][3:0];
    logic signed [23:0] modified_triangle7[2:0][3:0];
    logic signed [23:0] modified_triangle8[2:0][3:0];
    logic signed [23:0] modified_triangle9[2:0][3:0];
    logic signed [23:0] modified_triangle10[2:0][3:0];
    logic signed [23:0] modified_triangle11[2:0][3:0];
    logic signed [23:0] modified_triangle12[2:0][3:0];
    //        cols bits                        rows
    logic [9:0][2:0] block_colors [19:0]; //top left is (0,0)
    logic [23:0] build_list [199:0];
    

    parameter HEIGHT = 768,
                        WIDTH   = 1024,
                        MAX_PIXELS = 115200,
                        X_OFFSET = 10,
                        Y_OFFSET = 10,
                        Z_OFFSET = 1,
                        INITIALIZE_VALUES = 5'b0,
                        SET_POINTS = 5'b00001,
                        CREATE_TRIANGLE = 5'b00010,
                        MATRIX_MATH = 5'b00100,
                        DRAW = 5'b01000,
                        PIXEL_TO_RAM = 5'b10000,
                        SET_PIXEL_TO_CHECK = 5'b10001,
                        MAKE_LIST_TO_CHECK = 5'b10010,
                        FILL_POINTS = 5'b10100,
                        NUM_ROWS_TO_FILL = 3,
                        NUM_COLS_TO_FILL = 3;
    

    clk_wiz_0 clk_gen (.clk_out1(clk_65mhz), .clk_out2(clk_148mhz), .clk_out3(clk_400mhz), .reset(0), .clk_in1(clk_100mhz));
    //307200
//    blk_mem_gen_0 screen_buff_1(.addra(write_addr), .addrb(read_addr),
//                                                      .clka(clk_400mhz), .clkb(clk_400mhz),
//                                                      .dina(pixel), 
//                                                      .douta(from_memory_a), .doutb(from_memory_b), 
//                                                      .wea(write_en));
                                                      
                                                      
    assign vclock = clk_65mhz;
    assign sysclk = clk_400mhz;
    xvga                  xvga1 (.vclock_in(vclock), .hcount_out(hcount), .vcount_out(vcount), .vsync_out(vsync), .hsync_out(hsync), .blank_out(blank));
   
    debounce          reset_debounce(.clk_in(sysclk), . rst_in(0), .bouncey_in(btnc), .clean_out(reset));
    
    draw_line           play_area (.vclock_in(vclock), .hcount_in(hcount), . vcount_in(vcount), .rgb_out(box));
    
    draw_triangle    triangle_1  (.vclock_in(sysclk),  .clk_400mhz(clk_400mhz),  .triangle(modified_triangle1), .hcount_in(h_pixel),  .vcount_in(v_pixel),  .rgb_out(triangle[0]));
    draw_triangle    triangle_2  (.vclock_in(sysclk),  .clk_400mhz(clk_400mhz),  .triangle(modified_triangle2), .hcount_in(h_pixel),  .vcount_in(v_pixel),  .rgb_out(triangle[1]));
    draw_triangle    triangle_3  (.vclock_in(sysclk),  .clk_400mhz(clk_400mhz),  .triangle(modified_triangle3), .hcount_in(h_pixel),  .vcount_in(v_pixel),  .rgb_out(triangle[2]));
    draw_triangle    triangle_4  (.vclock_in(sysclk),  .clk_400mhz(clk_400mhz),  .triangle(modified_triangle4), .hcount_in(h_pixel),  .vcount_in(v_pixel),  .rgb_out(triangle[3]));
    draw_triangle    triangle_5  (.vclock_in(sysclk),  .clk_400mhz(clk_400mhz),  .triangle(modified_triangle5), .hcount_in(h_pixel),  .vcount_in(v_pixel),  .rgb_out(triangle[4]));
    draw_triangle    triangle_6  (.vclock_in(sysclk),  .clk_400mhz(clk_400mhz),  .triangle(modified_triangle6), .hcount_in(h_pixel),  .vcount_in(v_pixel),  .rgb_out(triangle[5]));
    draw_triangle    triangle_7  (.vclock_in(sysclk),  .clk_400mhz(clk_400mhz),  .triangle(modified_triangle7), .hcount_in(h_pixel),  .vcount_in(v_pixel),  .rgb_out(triangle[6]));
    draw_triangle    triangle_8  (.vclock_in(sysclk),  .clk_400mhz(clk_400mhz),  .triangle(modified_triangle8), .hcount_in(h_pixel),  .vcount_in(v_pixel),  .rgb_out(triangle[7]));
    draw_triangle    triangle_9  (.vclock_in(sysclk),  .clk_400mhz(clk_400mhz),  .triangle(modified_triangle9), .hcount_in(h_pixel),  .vcount_in(v_pixel),  .rgb_out(triangle[8]));
    draw_triangle    triangle_10(.vclock_in(sysclk),  .clk_400mhz(clk_400mhz),  .triangle(modified_triangle10), .hcount_in(h_pixel),  .vcount_in(v_pixel),  .rgb_out(triangle[9]));
    draw_triangle    triangle_11(.vclock_in(sysclk),  .clk_400mhz(clk_400mhz),  .triangle(modified_triangle11), .hcount_in(h_pixel),  .vcount_in(v_pixel),  .rgb_out(triangle[10]));
    draw_triangle    triangle_12(.vclock_in(sysclk),  .clk_400mhz(clk_400mhz),  .triangle(modified_triangle12), .hcount_in(h_pixel),  .vcount_in(v_pixel),  .rgb_out(triangle[11]));
    
    matrix                #(.HEIGHT(HEIGHT), .WIDTH(WIDTH))   my_mat_1     ( .sysclk(sysclk),  .tri_array(triangle1),  .reset(reset),  .field_of_view(fov),  .corrected_array(modified_triangle1));
    matrix                #(.HEIGHT(HEIGHT), .WIDTH(WIDTH))   my_mat_2     ( .sysclk(sysclk),  .tri_array(triangle2),  .reset(reset),  .field_of_view(fov),  .corrected_array(modified_triangle2));
    matrix                #(.HEIGHT(HEIGHT), .WIDTH(WIDTH))   my_mat_3     ( .sysclk(sysclk),  .tri_array(triangle3),  .reset(reset),  .field_of_view(fov),  .corrected_array(modified_triangle3));
    matrix                #(.HEIGHT(HEIGHT), .WIDTH(WIDTH))   my_mat_5     ( .sysclk(sysclk),  .tri_array(triangle4),  .reset(reset),  .field_of_view(fov),  .corrected_array(modified_triangle4));
    matrix                #(.HEIGHT(HEIGHT), .WIDTH(WIDTH))   my_mat_4     ( .sysclk(sysclk),  .tri_array(triangle5),  .reset(reset),  .field_of_view(fov),  .corrected_array(modified_triangle5));
    matrix                #(.HEIGHT(HEIGHT), .WIDTH(WIDTH))   my_mat_6     ( .sysclk(sysclk),  .tri_array(triangle6),  .reset(reset),  .field_of_view(fov),  .corrected_array(modified_triangle6));
    matrix                #(.HEIGHT(HEIGHT), .WIDTH(WIDTH))   my_mat_7     ( .sysclk(sysclk),  .tri_array(triangle7),  .reset(reset),  .field_of_view(fov),  .corrected_array(modified_triangle7));
    matrix                #(.HEIGHT(HEIGHT), .WIDTH(WIDTH))   my_mat_8     ( .sysclk(sysclk),  .tri_array(triangle8),  .reset(reset),  .field_of_view(fov),  .corrected_array(modified_triangle8));
    matrix                #(.HEIGHT(HEIGHT), .WIDTH(WIDTH))   my_mat_9     ( .sysclk(sysclk),  .tri_array(triangle9),  .reset(reset),  .field_of_view(fov),  .corrected_array(modified_triangle9));
    matrix                #(.HEIGHT(HEIGHT), .WIDTH(WIDTH))   my_mat_10   ( .sysclk(sysclk),  .tri_array(triangle10),  .reset(reset),  .field_of_view(fov),  .corrected_array(modified_triangle10));
    matrix                #(.HEIGHT(HEIGHT), .WIDTH(WIDTH))   my_mat_11   ( .sysclk(sysclk),  .tri_array(triangle11),  .reset(reset),  .field_of_view(fov),  .corrected_array(modified_triangle11));
    matrix                #(.HEIGHT(HEIGHT), .WIDTH(WIDTH))   my_mat_12   ( .sysclk(sysclk),  .tri_array(triangle12),  .reset(reset),  .field_of_view(fov),  .corrected_array(modified_triangle12));
    

    always_ff @(posedge sysclk) begin
            if(reset) begin
                x_loc <= 0;
                y_loc <= 0;
                north <= 1;
                south <= 1;
                east <= 0;
                west <= 0;
                top <= 0;
                bottom <= 0;
                state <= 5'b0;
                for (int j = 0; j < NUM_ROWS_TO_FILL; j++) begin
                    for ( int i = 0; i < NUM_COLS_TO_FILL; i++) begin
                        block_colors[i][j] = three_bit_counter;
                        three_bit_counter <= three_bit_counter +1;
                        end // i loop
                    end // j loop
                end
            else begin
                case(state)
                
                    SET_PIXEL_TO_CHECK: begin
                        v_pixel <= v_pixel > 580 ? 0 : h_pixel > 440 ? 100 : v_pixel;
                        h_pixel <= h_pixel > 440 ? 0 : h_pixel +1;
                        state <= MAKE_LIST_TO_CHECK;
                        end // set pixel state
                        
                    MAKE_LIST_TO_CHECK: begin
                        for (int i = 0; i < 20; i++) begin
                            for ( int j = 0; j < 10; j++) begin
                                if ( block_colors[i][j] > 0 ) begin //if the location has a block to draw
                                    if ( i == 0 && j == 0) begin //top left
                                        build_list[build_list_counter] <= {1'b1, 1'b1, block_colors[i+1][j] > 0 ? 1 : 0,  block_colors[i][j+1] > 0 ? 1 : 0, 1'b1, i*24+200, j*24+100};
                                        end
                                    else if (i == 0 && j == 9) begin // top right
                                        build_list[build_list_counter] <= {1'b1, 1'b1,  block_colors[i+1][j] > 0 ? 1'b0 : 1'b1,1'b1,1'b1,block_colors[i][j-1] > 0 ? 1'b0 : 1'b1, i*24+200, j*24+100};
                                        end
                                    else if ( i == 19 && j == 0) begin // bottom left
                                        build_list[build_list_counter] <= { 1'b1, block_colors[i-1][j] > 0 ? 0 : 1, 1'b1, block_colors[i][j+1] > 0 ? 0 : 1, 1'b1, i*24+200, j*24+100};
                                        end
                                    else if ( i == 19 && j == 9) begin // bottom right
                                        build_list[build_list_counter] <= {1'b1, block_colors[i-1][j] > 0 ? 0 : 1,  1'b1, 1'b1, block_colors[i][j-1] > 0 ? 0 : 1, i*24+200, j*24+100};
                                        end
                                    else begin // all other places on board
                                        build_list[build_list_counter] <= {1'b1, block_colors[i-1][j] > 0 ? 0 : 1, block_colors[i+1][j] > 0 ? 0 : 1, block_colors[i][j+1] > 0 ? 0 : 1, block_colors[i][j-1] > 0 ? 0 : 1, i*24+200, j*24+100};
                                        end
                                    end // ( if block_colors)
                                    build_list_counter = build_list_counter + 1'b1;
                                end // i loop
                            end // j loop
                            state <= SET_POINTS;
                            build_list_length = build_list_counter;
                            build_list_counter <= 0;
                        end // make_list state
                    SET_POINTS: begin
                        if(build_list[build_list_counter][23] == 1) begin
                            x_loc <= build_list[build_list_counter][18:10];
                            y_loc <= build_list[build_list_counter][9:0];
                            build_list_counter <= build_list_counter +1;
                            end
                        else begin
                            x_loc = 0;
                            y_loc = 0;
                            state <= 0;//fix this with something useful <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                            end
                        state <= FILL_POINTS;
                        end
                    FILL_POINTS: begin
                            point1[3] <= x_loc;  point1[2] <= y_loc;  point1[1] <= z_loc;  point1[0] <= z_loc;
                            point2[3] <= x_loc;  point2[2] <= y_loc + Y_OFFSET*(y_loc > 0? y_loc: 1);  point2[1] <= z_loc;  point2[0] <= z_loc;
                            point3[3] <= x_loc + X_OFFSET*(x_loc > 0? x_loc: 1);  point3[2] <= y_loc + Y_OFFSET*(y_loc > 0? y_loc: 1);  point3[1] <= z_loc;  point3[0] <= z_loc;
                            point4[3] <= x_loc + X_OFFSET*(x_loc > 0? x_loc: 1);  point4[2] <= y_loc;  point4[1] <= z_loc;  point4[0] <= z_loc;
                            point5[3] <= x_loc + X_OFFSET*(x_loc > 0? x_loc: 1);  point5[2] <= y_loc;  point5[1] <= z_loc + Z_OFFSET*(z_loc > 0? z_loc: 1);  point5[0] <= z_loc + Z_OFFSET*(z_loc > 0? z_loc: 1);
                            point6[3] <= x_loc + X_OFFSET*(x_loc > 0? x_loc: 1);  point6[2] <= y_loc + Y_OFFSET*(y_loc > 0? y_loc: 1);  point6[1] <= z_loc + Z_OFFSET*(z_loc > 0? z_loc: 1);  point6[0] <= z_loc + Z_OFFSET*(z_loc > 0? z_loc: 1);
                            point7[3] <= x_loc;  point7[2] <= y_loc + Y_OFFSET*(y_loc > 0? y_loc: 1);  point7[1] <= z_loc + Z_OFFSET*(z_loc > 0? z_loc: 1);  point7[0] <= z_loc + Z_OFFSET*(z_loc > 0? z_loc: 1);
                            point8[3] <= x_loc;  point8[2] <= y_loc;  point8[1] <= z_loc + Z_OFFSET*(z_loc > 0? z_loc: 1);  point8[0] <= z_loc + Z_OFFSET*(z_loc > 0? z_loc: 1);
                            
                            state <= CREATE_TRIANGLE;
                            end
                            
                    CREATE_TRIANGLE: begin
                        triangle1[0][3] <= point1[3];  triangle1[0][2] <= point1[2];  triangle1[0][1] <= point1[1];  triangle1[0][0] <= point1[0];
                        triangle1[1][3] <= point2[3];  triangle1[1][2] <= point2[2];  triangle1[1][1] <= point2[1];  triangle1[1][0] <= point2[0];
                        triangle1[2][3] <= point3[3];  triangle1[2][2] <= point3[2];  triangle1[2][1] <= point3[1];  triangle1[2][0] <= point3[0];
                        
                        triangle2[0][3] <= point4[3];  triangle2[0][2] <= point4[2];  triangle2[0][1] <= point4[1];  triangle2[0][0] <= point4[0];
                        triangle2[1][3] <= point1[3];  triangle2[1][2] <= point1[2];  triangle2[1][1] <= point1[1];  triangle2[1][0] <= point1[0];
                        triangle2[2][3] <= point3[3];  triangle2[2][2] <= point3[2];  triangle2[2][1] <= point3[1];  triangle2[2][0] <= point3[0];
                        
                        triangle3[0][3] <= point3[3];  triangle3[0][2] <= point3[2];  triangle3[0][1] <= point3[1];  triangle3[0][0] <= point3[0];
                        triangle3[1][3] <= point6[3];  triangle3[1][2] <= point6[2];  triangle3[1][1] <= point6[1];  triangle3[1][0] <= point6[0];
                        triangle3[2][3] <= point4[3];  triangle3[2][2] <= point4[2];  triangle3[2][1] <= point4[1];  triangle3[2][0] <= point4[0];
                        
                        triangle4[0][3] <= point4[3];  triangle4[0][2] <= point4[2];  triangle4[0][1] <= point4[1];  triangle4[0][0] <= point4[0];
                        triangle4[1][3] <= point6[3];  triangle4[1][2] <= point6[2];  triangle4[1][1] <= point6[1];  triangle4[1][0] <= point6[0];
                        triangle4[2][3] <= point5[3];  triangle4[2][2] <= point5[2];  triangle4[2][1] <= point5[1];  triangle4[2][0] <= point5[0];
                      
                        triangle5[0][3] <= point5[3];  triangle5[0][2] <= point5[2];  triangle5[0][1] <= point5[1];  triangle5[0][0] <= point5[0];
                        triangle5[1][3] <= point6[3];  triangle5[1][2] <= point6[2];  triangle5[1][1] <= point6[1];  triangle5[1][0] <= point6[0];
                        triangle5[2][3] <= point7[3];  triangle5[2][2] <= point7[2];  triangle5[2][1] <= point7[1];  triangle5[2][0] <= point7[0];
                        
                        triangle6[0][3] <= point5[3];  triangle6[0][2] <= point5[2];  triangle6[0][1] <= point5[1];  triangle6[0][0] <= point5[0];
                        triangle6[1][3] <= point7[3];  triangle6[1][2] <= point7[2];  triangle6[1][1] <= point7[1];  triangle6[1][0] <= point7[0];
                        triangle6[2][3] <= point8[3];  triangle6[2][2] <= point8[2];  triangle6[2][1] <= point8[1];  triangle6[2][0] <= point8[0];
                       
                        triangle7[0][3] <= point8[3];  triangle7[0][2] <= point8[2];  triangle7[0][1] <= point8[1];  triangle7[0][0] <= point8[0];
                        triangle7[1][3] <= point7[3];  triangle7[1][2] <= point7[2];  triangle7[1][1] <= point7[1];  triangle7[1][0] <= point7[0];
                        triangle7[2][3] <= point2[3];  triangle7[2][2] <= point2[2];  triangle7[2][1] <= point2[1];  triangle7[2][0] <= point2[0];
                        
                        triangle8[0][3] <= point8[3];  triangle8[0][2] <= point8[2];  triangle8[0][1] <= point8[1];  triangle8[0][0] <= point8[0];
                        triangle8[1][3] <= point2[3];  triangle8[1][2] <= point2[2];  triangle8[1][1] <= point2[1];  triangle8[1][0] <= point2[0];
                        triangle8[2][3] <= point1[3];  triangle8[2][2] <= point1[2];  triangle8[2][1] <= point1[1];  triangle8[2][0] <= point1[0];
                        
                        triangle9[0][3] <= point2[3];  triangle9[0][2] <= point2[2];  triangle9[0][1] <= point2[1];  triangle9[0][0] <= point2[0];
                        triangle9[1][3] <= point7[3];  triangle9[1][2] <= point7[2];  triangle9[1][1] <= point7[1];  triangle9[1][0] <= point7[0];
                        triangle9[2][3] <= point6[3];  triangle9[2][2] <= point6[2];  triangle9[2][1] <= point6[1];  triangle9[2][0] <= point6[0];
                       
                        triangle10[0][3] <= point2[3];  triangle10[0][2] <= point2[2];  triangle10[0][1] <= point2[1];  triangle10[0][0] <= point2[0];
                        triangle10[1][3] <= point6[3];  triangle10[1][2] <= point6[2];  triangle10[1][1] <= point6[1];  triangle10[1][0] <= point6[0];
                        triangle10[2][3] <= point3[3];  triangle10[2][2] <= point3[2];  triangle10[2][1] <= point3[1];  triangle10[2][0] <= point3[0];
                        
                        triangle11[0][3] <= point1[3];  triangle11[0][2] <= point1[2];  triangle11[0][1] <= point1[1];  triangle11[0][0] <= point1[0];
                        triangle11[1][3] <= point8[3];  triangle11[1][2] <= point8[2];  triangle11[1][1] <= point8[1];  triangle11[1][0] <= point8[0];
                        triangle11[2][3] <= point5[3];  triangle11[2][2] <= point5[2];  triangle11[2][1] <= point5[1];  triangle11[2][0] <= point5[0];
                        
                        triangle12[0][3] <= point1[3];  triangle12[0][2] <= point1[2];  triangle12[0][1] <= point1[1];  triangle12[0][0] <= point1[0];
                        triangle12[1][3] <= point5[3];  triangle12[1][2] <= point5[2];  triangle12[1][1] <= point5[1];  triangle12[1][0] <= point5[0];
                        triangle12[2][3] <= point4[3];  triangle12[2][2] <= point4[2];  triangle12[2][1] <= point4[1];  triangle12[2][0] <= point4[0];
                        
                        state <= MATRIX_MATH;
                        
                        end
                    MATRIX_MATH: begin
                            matrix_delay <= matrix_delay < 3 ? matrix_delay +1 : state <= DRAW;
                        end
                    DRAW: begin
                            matrix_delay <= 0;
                            for(int i = 0; i < 12; i++) begin
                                if( |triangle[i] == 0 && build_list_counter < build_list_length) begin
                                    state <= FILL_POINTS;
                                    end
                                else if (triangle[i] > 0 || build_list_counter == build_list_length) begin
                                    triangle_to_store <= triangle[i] > 0 ? triangle[i] : 12'b0;
                                    state <= PIXEL_TO_RAM;
                                    end
                                end
                        end
                    PIXEL_TO_RAM: begin
        //                if (hcount == WIDTH && vcount == HEIGHT) begin
        //                    hcount <= 0;
        //                    vcount <= 0;
        //                    end
        //                else if (hcount == WIDTH && vcount < HEIGHT) begin
        //                    hcount <= 0;
        //                    vcount <= vcount +1;
        //                    end
        //                else if (hcount < WIDTH) begin
        //                    hcount <= hcount + 1;
        //                    end
                        write_enable = ~write_enable;
                        tpd_delay = ~tpd_delay;
                        tpd_delay = ~tpd_delay;
                        write_enable <= ~write_enable;
                        write_addr <= write_addr < MAX_PIXELS ? write_addr +1 : 0;
                        state <= 0; // fill this in <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                        end
                    INITIALIZE_VALUES: begin
                        end
                    default: begin
                        end
                    endcase
                end
                
                //pick a color to draw a pixel
                
        end //always_ff sysclk
        
        always_ff @(posedge vclock) begin
                if ( |box ) begin
                    pixel <= box;
                    end
//                else if ( |triangle) begin
//                    pixel <= triangle;
//                    end
                else begin
                    pixel <= box;
                    end
            end
        
        
//        always_comb begin
//            if(make_build_list) begin
//                for (int j = 0; j < 20; j++) begin
//                    for ( int i = 0; i < 10; i++) begin
//                        if ( |block_colors[j][i]) begin
//                            build_list[build_list_counter] = block_colors[j][i];
//                            end
//                        end // i loop
//                    end // j loop
//                end // list making if logic
//            end //always_comb
            
        assign vga_r = pixel[11:8];
        assign vga_g = pixel[7:4];
        assign vga_b = pixel[3:0];
        assign vga_hs = ~hsync;
        assign vga_vs = ~vsync;

endmodule //top_level
