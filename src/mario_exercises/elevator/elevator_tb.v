`timescale 1ns / 1ps
 
module elevator_tb;
 
    // Parameters
    parameter max_floors = 10;
    parameter max_time_in_floor = 3;
    parameter floor_width = $clog2(max_floors);
 
    // Inputs
    reg clk;
    reg rst;
    reg [floor_width:0] origin_floor;
    reg [floor_width:0] destination_floor;
 
    // Output
    wire [floor_width:0] current_floor;
 
    // Instantiate the elevator module
    elevator #(
        .max_floors(max_floors),
        .max_time_in_floor(max_time_in_floor)
    ) uut (
        .clk(clk),
        .rst(rst),
        .origin_floor(origin_floor),
        .destination_floor(destination_floor),
        .current_floor(current_floor)
    );
 
    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;  // 10 ns clock period
 
    // Task to issue a floor request
    task request_floor(input integer origin, input integer dest);
    begin
        @(posedge clk);
        origin_floor = origin;
        destination_floor = dest;
        @(posedge clk);
        origin_floor = 'bz;  // High-impedance when no request
        destination_floor = 'bz;
    end
    endtask
 
    initial begin
        $dumpfile("elevator_tb.vcd");
        $dumpvars(0, elevator_tb);
        // Initialize
        $display("Starting simulation...");
        rst = 1;
        origin_floor = 'bz;
        destination_floor = 'bz;
        #20;
 
        // Release reset
        rst = 0;
 
        // Request: floor 2 to 5
        request_floor(2, 5);
 
        // Wait and request another one: floor 4 to 1
        #100;
        request_floor(4, 1);
 
        // Another: floor 7 to 10
        #100;
        request_floor(7, 10);
 
        // Let simulation run for some time
        #1000;
 
        $display("Simulation finished.");
        $finish;
    end
 
    // Monitor
    always @(posedge clk) begin
        $display("Time: %0t | Current floor: %0d", $time, current_floor);
    end
 
endmodule