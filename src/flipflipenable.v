module flipflopenable(input CLK, input EN, input D, output reg Q);

    always@(posedge CLK)
    begin
        // $display("%d %d %d", EN, Q, D);
        if(EN) Q = D;
    end

endmodule
