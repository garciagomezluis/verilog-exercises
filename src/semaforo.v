`define RED_CYCLES 0
`define YELLOW_CYCLES_FORWARD 0
`define YELLOW_CYCLES_BACKWARDS 0
`define GREEN_CYCLES 0 

module semaforo
  #(parameter RED_CYCLES=`RED_CYCLES,
    parameter YELLOW_CYCLES_FORWARD=`YELLOW_CYCLES_FORWARD,
    parameter YELLOW_CYCLES_BACKWARDS=`YELLOW_CYCLES_BACKWARDS,
    parameter GREEN_CYCLES=`GREEN_CYCLES) (
    input RST,
    input CLK,
    output reg [1:0] LIGHT
  );

    localparam RED_LIGHT = 1;
    localparam YELLOW_LIGHT = 2;
    localparam GREEN_LIGHT = 3;

    reg [4:0] cycles;
    reg [1:0] state;
    reg [4:0] counter;
    reg forward;

    always @(posedge CLK) begin

      if(RST) begin
        cycles <= RED_CYCLES;
        state <= RED_LIGHT;
        counter <= 5'd1;
        forward <= 1;
      end else begin

        counter <= counter + 5'd1;
        if(counter >= cycles) begin
            counter <= 5'd1;

            if(state == RED_LIGHT) begin
              state <= YELLOW_LIGHT;
              cycles <= YELLOW_CYCLES_FORWARD;
            end else if (state == YELLOW_LIGHT && forward == 1) begin
              state <= GREEN_LIGHT;
              cycles <= GREEN_CYCLES;
            end else if (state == GREEN_LIGHT) begin
              state <= YELLOW_LIGHT;
              cycles <= YELLOW_CYCLES_BACKWARDS;
              forward <= 0;
            end else if (state == YELLOW_LIGHT && forward == 0) begin
              state <= RED_LIGHT;
              cycles <= RED_CYCLES;
              forward <= 1;
            end

        end
        LIGHT <= state;

      end

    end
endmodule
