module sequential_demo(input A, input B, input CLK, output Z);

    reg D = 0;

    assign Z = D;

    always@(posedge CLK)
    begin
        // $display("%d %d %d", A, B, D);
        D = A ^ B ^ D;
    end

endmodule
