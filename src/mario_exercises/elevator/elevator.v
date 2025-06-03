module elevator #(
    parameter max_floors = 10,
    parameter max_time_in_floor = 3
) (
    input clk,
    input rst,
    input [$clog2(max_floors):0] origin_floor,
    input [$clog2(max_floors):0] destination_floor,
    output reg [$clog2(max_floors):0] current_floor
);

    reg direction_upwards;
    reg [max_floors:0] origin_floors;
    reg [max_floors:0] destination_floors;
    reg [$clog2(max_time_in_floor):0] counter_time_in_floor;
    reg pending_requests_above_current_floor;
    reg pending_requests_below_current_floor;

    localparam width_floors = $clog2(max_floors);

    task check_for_pending_requests (
        input [width_floors:0] floor_start,
        input [width_floors:0] floor_end,
        output reg requested
    );
        integer i;
        begin
            requested = 0;
            for(i = floor_start; i <= floor_end && requested === 0; i = i + 1) begin
                requested = origin_floors[i] === 1 || destination_floors[i] === 1;
            end
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

            // register a floor new request, if valid.
            if(
                origin_floor !== {width_floors{1'bz}} &&
                destination_floor !== {width_floors{1'bz}} &&
                origin_floor !== destination_floor &&
                1 <= origin_floor && origin_floor <= max_floors &&
                1 <= destination_floor && destination_floor <= max_floors
            ) begin
                origin_floors[origin_floor] <= 1;
                destination_floors[destination_floor] <= 1;
            end

            if(origin_floors[current_floor] === 1 || destination_floors[current_floor] === 1) begin

                // TODO: this can be refactored using a counter/timer device
                if(counter_time_in_floor === (max_time_in_floor-1)) begin
                    counter_time_in_floor <= 1;
                    origin_floors[current_floor] <= 0;
                    destination_floors[current_floor] <= 0;
                end else counter_time_in_floor <= counter_time_in_floor + 1;

            end else begin
                // reverse direction at the building limits
                if(current_floor === 1 || current_floor === max_floors)
                    direction_upwards = ~direction_upwards;

                check_for_pending_requests(current_floor+1, max_floors, pending_requests_above_current_floor);

                check_for_pending_requests(1, current_floor-1, pending_requests_below_current_floor);

                // move only if there are pending requests elsewhere
                if(pending_requests_above_current_floor || pending_requests_below_current_floor) begin

                    // change direction to up if going down and no more requests below
                    if(direction_upwards == 0 && !pending_requests_below_current_floor) begin
                        direction_upwards <= 1;
                        current_floor <= current_floor + 1;

                    // change direction to down if going up and no more requests above
                    end else if(direction_upwards == 1 && !pending_requests_above_current_floor) begin
                        direction_upwards <= 0;
                        current_floor <= current_floor - 1;
                    
                    // otherwise, continue moving in the current direction
                    end else
                        current_floor <= current_floor + (direction_upwards ? 1 : -1);

                end

            end
        end

    end

endmodule
