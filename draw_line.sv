`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2019 05:10:29 PM
// Design Name: 
// Module Name: draw_line
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


module draw_line( input vclock_in,
                               input [11:0] hcount_in, 
                               input [10:0] vcount_in,
                               output logic [11:0] rgb_out
                                );
    
    always_ff @ (posedge vclock_in) begin
            if(hcount_in == 200  || hcount_in == 440 || vcount_in == 100 || vcount_in == 580 ) begin
                rgb_out <= 12'hFFF;
                end
            else begin
                rgb_out <= 12'h000;
                end
        end // always_ff
endmodule
