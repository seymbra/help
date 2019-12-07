`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description:  Approximate aspect ratios with fixed point decimals
//                      Accuracy is 8bit integer with 12bit decimal
//                      Hard coded aspect ratios to minimize calculations
// 
//////////////////////////////////////////////////////////////////////////////////


module aspect_ratio( input sysclk,
                                   input [11:0] height,
                                   input [10:0] width,
                                   output logic [19:0] aspectRatio

    );
    parameter QVGA  = 320,
                        VGA     = 640,
                        SVGA   = 800,
                        XGA     = 1024,
                        UXGA  = 1600,
                        HD1080 = 1920;
    
    always_ff @(posedge sysclk) begin
        case(height)
            240: begin 
                if(width == QVGA) begin
                    aspectRatio <= 20'b0001_0101_0101_0101; //close approximation of 4:3, 1.33325
                    end
                end
            480: begin 
                if(width == VGA) begin
                    aspectRatio <= 20'b0001_0101_0101_0101; //close approximation of 4:3, 1.33325
                    end
                end
            600: begin 
                if(width == SVGA) begin
                    aspectRatio <= 20'b0001_0101_0101_0101; //close approximation of 4:3, 1.33325
                    end
                end
            768: begin 
                if(width == XGA) begin
                    aspectRatio <= 20'b0001_0101_0101_0101; //close approximation of 4:3, 1.33325
                    end
                end
            1200: begin 
                if(width == UXGA) begin
                    aspectRatio <= 20'b0001_0101_0101_0101; //close approximation of 4:3, 1.33325
                    end
                end
            1080: begin
                if(width == HD1080) aspectRatio <= 20'b0001_1100_0111_0001; //close approximation of 16:9, 1.77759
                end
            default: begin
                aspectRatio <= 20'b0001_0101_0101_0101; //close approximation of 4:3, 1.33325
                end
            endcase
        end //always_ff
endmodule
