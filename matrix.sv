`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2019 06:18:09 PM
// Design Name: 
// Module Name: matrix
// Project Name: 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module matrix #(parameter HEIGHT = 1024,
                                                WIDTH   = 768)
                          (  input sysclk,
                             input reset,
                             input signed [23:0] tri_array [2:0][3:0],
                             input signed [23:0] field_of_view,
                             output logic signed [23:0] corrected_array [2:0][3:0] 
                             );
                             
logic signed [23:0] correction_matrix [0:3][0:3];
logic signed [23:0] aspect_ratio;
logic signed [23:0] fov_multiplier;
logic signed [23:0] z_near, z_far, z_ratio;
logic signed [23:0] z_near_q;
logic signed [47:0] temp, temp1, temp2, temp3, temp4, temp5;
aspect_ratio modifier ( .sysclk(sysclk), 
                                      .height(HEIGHT),
                                      .width(WIDTH),
                                      .aspectRatio(aspect_ratio));
                                      
 field_of_view find_fov(.sysclk(sysclk),
                                     .FOV(field_of_view),
                                     .fov_multiplier(fov_multiplier)
                                     );



always_ff @(posedge sysclk) begin
    if(reset) begin
        temp = (aspect_ratio*fov_multiplier);
        correction_matrix[0][0] <= temp >>>12;
        correction_matrix[1][1] <= fov_multiplier;
        correction_matrix[2][2] <= 13'b1__0000_0010_1001;
        correction_matrix[3][2] <= -14'b10__0000_0010_1001;
        correction_matrix[2][3] <= 1;
        z_near_q <= 20'b01010_0001_1001_1010;  
        end // if reset
    else begin
        corrected_array[3][3] <= (tri_array[3][3]*correction_matrix[0][0])>>>20;
        corrected_array[3][2] <= (tri_array[3][2]*correction_matrix[1][1])>>>20;
        corrected_array[3][1] <= (tri_array[3][1]*correction_matrix[1][1])>>>20;
        temp <= (tri_array[3][0]*correction_matrix[2][2])>>>20;
        temp1 = z_near_q >>>4;
        corrected_array[3][0] = temp - temp1;
        
        corrected_array[3][3] <= (tri_array[3][3]*correction_matrix[0][0])>>>20;
        corrected_array[3][2] <= (tri_array[3][2]*correction_matrix[1][1])>>>20;
        corrected_array[3][1] <= (tri_array[3][1]*correction_matrix[1][1])>>>20;
        temp <= (tri_array[3][0]*correction_matrix[2][2])>>>20;
        temp2 = z_near_q >>>4;
        corrected_array[3][0] <= temp - temp2;
        
        corrected_array[3][3] <= (tri_array[3][3]*correction_matrix[0][0])>>>20;
        corrected_array[3][2] <= (tri_array[3][2]*correction_matrix[1][1])>>>20;
        corrected_array[3][1] <= (tri_array[3][1]*correction_matrix[1][1])>>>20;
        temp <= (tri_array[3][0]*correction_matrix[2][2])>>>20;
        temp3 <= z_near_q >>>4;
        corrected_array[3][0] <= temp - temp3;
        end
    end // always_FF
endmodule
