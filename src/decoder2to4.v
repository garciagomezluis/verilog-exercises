module decoder1to2(input A, output [1:0] D);
    assign D[0] = ~A;
    assign D[1] = A;
endmodule

module decoder2to4(input [1:0] A, output [3:0] D);

    wire [3:0] W;

    decoder1to2 U0(A[0], W[3:2]);

    decoder1to2 U1(A[1], W[1:0]);

    assign D[0] = W[3] & W[1];
    assign D[1] = W[2] & W[1];
    assign D[2] = W[3] & W[0];
    assign D[3] = W[2] & W[0];

endmodule
