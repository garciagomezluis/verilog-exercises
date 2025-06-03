// Mercedes. Leonel.

`timescale 1ns / 1ps

module testbench;
 // Inputs
 reg clk;
 reg avl = 1;
    
 // Outputs
 wire red;
 wire green;
 wire blue;
 
 integer k = 0;
    
 initial begin

    // $dumpfile("traffic_light_tb.vcd");
    // $dumpvars(0, testbench);

    clk = 0;
    forever #5 clk = ~clk;
    
    //for (k=0; k < 50; k = k+1)
    //#10
 end
 
always @(posedge clk) begin
    k = k + 1;
    if (k == 50) begin
        $finish;
     end 
end

//initial begin
//    k = 0;
//end
 
 traffic_light uut (clk, avl, red, green, blue);

endmodule
