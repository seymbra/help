module debounce(    input           clk_in, //clock in
                    input           rst_in, //reset in
                    input           bouncey_in,//raw input to the system
                    output logic    clean_out //debounced output
                );
                
   logic [19:0] count; // is 20 bits enough?
   logic old = 1'b0;
   logic [1:0] sel;
   assign sel = {rst_in, bouncey_in};
   
   always_ff @(posedge clk_in) begin
 
        if(count == 20'hf4240) begin // Decimal 999,999 in binary
            clean_out = bouncey_in;
            count <= 1'b0;
        end 
        
        else begin 
            if(rst_in) begin
                count <= 1'b0;
                clean_out <= 1'b0;
                
            end else if ( old != bouncey_in) begin
                count <= 1'b0;
                clean_out <= 1'b0;
            
            end else begin
                if(old == bouncey_in) begin
//                    clean_out <= 1'b0;
                    count += 1'b1;
                end
            end
        end 
        
        old <= bouncey_in;
   
   
   end            
endmodule