function integer clog2;
  input integer value;
  integer i;
  begin
    clog2 = 0;
    for (i = value - 1; i > 0; i = i >> 1)
      clog2 = clog2 + 1;
  end
endfunction


module elevator #(
    parameter max_floors = 10,
    parameter max_time_in_floor = 3
) (
    input clk,
    input rst,
    input [clog2(max_floors)-1:0] origin_floor,
    input [clog2(max_floors)-1:0] destination_floor,
    output reg [clog2(max_floors)-1:0] current_floor
);

    reg direction_upwards;
    reg [(max_floors-1):0] origin_floors;
    reg [(max_floors-1):0] destination_floors;
    reg [clog2(max_time_in_floor)-1:0] counter_time_in_floor;
    reg requested_floor_upwards;
    reg requested_floor_downwards;

    localparam width_floors = clog2(max_floors)-1;

    task check_if_no_requested_floor_in_segment (
        input [width_floors:0] floor_start,
        input [width_floors:0] floor_end,
        output reg requested
    );
        reg floor_requested;
        integer i;
        begin
            floor_requested = 0;
            for(i = floor_start; i <= floor_end && floor_requested === 0; i = i + 1) begin
                floor_requested = origin_floors[i-1] === 1 || destination_floors[i-1] === 1;
            end
            requested = floor_requested;
        end
    endtask

    always@(posedge clk) begin

        if(rst) begin
            current_floor <= 1;
            direction_upwards <= 1;
            origin_floors <= 0;
            destination_floors <= 0;
            counter_time_in_floor <= 1;
        end else begin

            if(
                origin_floor !== {width_floors{1'bz}} &&
                destination_floor !== {width_floors{1'bz}} &&
                origin_floor !== destination_floor &&
                1 <= origin_floor && origin_floor <= max_floors &&
                1 <= destination_floor && destination_floor <= max_floors
            ) begin
                origin_floors[origin_floor-1] <= 1;
                destination_floors[destination_floor-1] <= 1;
            end

            if(origin_floors[current_floor-1] === 1 || destination_floors[current_floor-1] === 1) begin
                if(counter_time_in_floor === (max_time_in_floor-1)) begin
                    counter_time_in_floor <= 1;
                    if(origin_floors[current_floor-1] === 1) origin_floors[current_floor-1] <= 0;
                    if(destination_floors[current_floor-1] === 1) destination_floors[current_floor-1] <= 0;
                end else counter_time_in_floor <= counter_time_in_floor + 1;
            end else begin
                if(current_floor === 1) direction_upwards = 1;
                if(current_floor === max_floors) direction_upwards = 0;

                check_if_no_requested_floor_in_segment(current_floor+1, max_floors, requested_floor_upwards);

                check_if_no_requested_floor_in_segment(1, current_floor-1, requested_floor_downwards);

                if(requested_floor_upwards || requested_floor_downwards) begin

                    if(direction_upwards == 0 && !requested_floor_downwards && requested_floor_upwards) begin
                        direction_upwards <= 1;
                        current_floor <= current_floor + 1;
                    end else if(direction_upwards == 1 && !requested_floor_upwards && requested_floor_downwards) begin
                        direction_upwards <= 0;
                        current_floor <= current_floor - 1;
                    end else
                        current_floor <= current_floor + (direction_upwards ? 1 : -1);

                end

            end
        end

    end

endmodule
