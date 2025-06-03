// Mercedes. Leonel.

module traffic_light(
    input clk,
    input avl,
    output reg red,
    output reg green,
    output reg blue
    );
    reg[5:0] counter = 5'd0;
    
    // If the clock is high 
    always@(posedge clk) begin
        
        // The switch is available
        if(avl == 1) begin
            // Red light should last 10 clock cycles, followed by yellow of 2 cycles, 
            // followed by green of 8 cycles, followed by yellow of 5 cycles
            
            if( counter == 0) begin        // red
                red = 1;
            end
            
            if( counter == 10) begin       // yellow
                // red + green = yellow LED
                green = 1;
            end
                
            if(counter == 12) begin        // green
                red = 0;
                green = 1;
            end
            
            if(counter == 20) begin        // yellow
                red = 1;
            end
                 
            // Increment the counter
            counter <= counter + 5'd1;
            
            // Reset the counter when it completes all the instructions
            if(counter == 25) begin
                counter <= 5'd0;    
            end      
        end
        else begin
            counter <= 5'd0;
        end
    end

endmodule
