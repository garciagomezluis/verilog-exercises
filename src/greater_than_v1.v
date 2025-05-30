module greater_than_v1(input [1:0] A, input [1:0] B, output F);
    assign F = A[1] & ~B[1] | A[0] & ~B[1] & ~B[0] | A[1] & A[0] & ~B[0];
endmodule
