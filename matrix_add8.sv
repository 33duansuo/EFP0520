module matrix_add8 #(
    parameter width = 16
)(
    input clk,
    input [2*width-1:0] A[8-1:0][8-1:0],
    input [2*width-1:0] B[8-1:0][8-1:0],
    input [4:0] m_bit1,
    input [4:0] m_bit2,
    input flag,
    output [2*width-1:0] C[8-1:0][8-1:0]
);

    // 8×8矩阵加法分块实现
    wire [2*width-1:0] subA[3:0][3:0][3:0];
    wire [2*width-1:0] subB[3:0][3:0][3:0];
    wire [2*width-1:0] subC[3:0][3:0][3:0];
    // 手动展开的逻辑
    // 块 0 4x4
    assign subA[0][0][0] = A[0][0];
    assign subA[0][0][1] = A[0][1];
    assign subA[0][0][2] = A[0][2];
    assign subA[0][0][3] = A[0][3];
    assign subA[0][1][0] = A[1][0];
    assign subA[0][1][1] = A[1][1];
    assign subA[0][1][2] = A[1][2];
    assign subA[0][1][3] = A[1][3];
    assign subA[0][2][0] = A[2][0];
    assign subA[0][2][1] = A[2][1];
    assign subA[0][2][2] = A[2][2];
    assign subA[0][2][3] = A[2][3];
    assign subA[0][3][0] = A[3][0];
    assign subA[0][3][1] = A[3][1];
    assign subA[0][3][2] = A[3][2];
    assign subA[0][3][3] = A[3][3];
  // 块 1 4x4
    assign subA[1][0][0] = A[0][4];
    assign subA[1][0][1] = A[0][5];
    assign subA[1][0][2] = A[0][6];
    assign subA[1][0][3] = A[0][7];
    assign subA[1][1][0] = A[1][4];
    assign subA[1][1][1] = A[1][5];
    assign subA[1][1][2] = A[1][6];
    assign subA[1][1][3] = A[1][7];
    assign subA[1][2][0] = A[2][4];
    assign subA[1][2][1] = A[2][5];
    assign subA[1][2][2] = A[2][6];
    assign subA[1][2][3] = A[2][7];
    assign subA[1][3][0] = A[3][4];
    assign subA[1][3][1] = A[3][5];
    assign subA[1][3][2] = A[3][6];
    assign subA[1][3][3] = A[3][7];
  // 块 2 4x4
    assign subA[2][0][0] = A[4][0];
    assign subA[2][0][1] = A[4][1];
    assign subA[2][0][2] = A[4][2];
    assign subA[2][0][3] = A[4][3];
    assign subA[2][1][0] = A[5][0];
    assign subA[2][1][1] = A[5][1];
    assign subA[2][1][2] = A[5][2];
    assign subA[2][1][3] = A[5][3];
    assign subA[2][2][0] = A[6][0];
    assign subA[2][2][1] = A[6][1];
    assign subA[2][2][2] = A[6][2];
    assign subA[2][2][3] = A[6][3];
    assign subA[2][3][0] = A[7][0];
    assign subA[2][3][1] = A[7][1];
    assign subA[2][3][2] = A[7][2];
    assign subA[2][3][3] = A[7][3];
  // 块 3 4x4
    assign subA[3][0][0] = A[4][4];
    assign subA[3][0][1] = A[4][5];
    assign subA[3][0][2] = A[4][6];
    assign subA[3][0][3] = A[4][7];
    assign subA[3][1][0] = A[5][4];
    assign subA[3][1][1] = A[5][5];
    assign subA[3][1][2] = A[5][6];
    assign subA[3][1][3] = A[5][7];
    assign subA[3][2][0] = A[6][4];
    assign subA[3][2][1] = A[6][5];
    assign subA[3][2][2] = A[6][6];
    assign subA[3][2][3] = A[6][7];
    assign subA[3][3][0] = A[7][4];
    assign subA[3][3][1] = A[7][5];
    assign subA[3][3][2] = A[7][6];
    assign subA[3][3][3] = A[7][7];

    assign subB[0][0][0] = B[0][0];
    assign subB[0][0][1] = B[0][1];
    assign subB[0][0][2] = B[0][2];
    assign subB[0][0][3] = B[0][3];
    assign subB[0][1][0] = B[1][0];
    assign subB[0][1][1] = B[1][1];
    assign subB[0][1][2] = B[1][2];
    assign subB[0][1][3] = B[1][3];
    assign subB[0][2][0] = B[2][0];
    assign subB[0][2][1] = B[2][1];
    assign subB[0][2][2] = B[2][2];
    assign subB[0][2][3] = B[2][3];
    assign subB[0][3][0] = B[3][0];
    assign subB[0][3][1] = B[3][1];
    assign subB[0][3][2] = B[3][2];
    assign subB[0][3][3] = B[3][3];

    assign subB[1][0][0] = B[0][4];
    assign subB[1][0][1] = B[0][5];
    assign subB[1][0][2] = B[0][6];
    assign subB[1][0][3] = B[0][7];
    assign subB[1][1][0] = B[1][4];
    assign subB[1][1][1] = B[1][5];
    assign subB[1][1][2] = B[1][6];
    assign subB[1][1][3] = B[1][7];
    assign subB[1][2][0] = B[2][4];
    assign subB[1][2][1] = B[2][5];
    assign subB[1][2][2] = B[2][6];
    assign subB[1][2][3] = B[2][7];
    assign subB[1][3][0] = B[3][4];
    assign subB[1][3][1] = B[3][5];
    assign subB[1][3][2] = B[3][6];
    assign subB[1][3][3] = B[3][7];

    assign subB[2][0][0] = B[4][0];
    assign subB[2][0][1] = B[4][1];
    assign subB[2][0][2] = B[4][2];
    assign subB[2][0][3] = B[4][3];
    assign subB[2][1][0] = B[5][0];
    assign subB[2][1][1] = B[5][1];
    assign subB[2][1][2] = B[5][2];
    assign subB[2][1][3] = B[5][3];
    assign subB[2][2][0] = B[6][0];
    assign subB[2][2][1] = B[6][1];
    assign subB[2][2][2] = B[6][2];
    assign subB[2][2][3] = B[6][3];
    assign subB[2][3][0] = B[7][0];
    assign subB[2][3][1] = B[7][1];
    assign subB[2][3][2] = B[7][2];
    assign subB[2][3][3] = B[7][3];

    assign subB[3][0][0] = B[4][4];
    assign subB[3][0][1] = B[4][5];
    assign subB[3][0][2] = B[4][6];
    assign subB[3][0][3] = B[4][7];
    assign subB[3][1][0] = B[5][4];
    assign subB[3][1][1] = B[5][5];
    assign subB[3][1][2] = B[5][6];
    assign subB[3][1][3] = B[5][7];
    assign subB[3][2][0] = B[6][4];
    assign subB[3][2][1] = B[6][5];
    assign subB[3][2][2] = B[6][6];
    assign subB[3][2][3] = B[6][7];
    assign subB[3][3][0] = B[7][4];
    assign subB[3][3][1] = B[7][5];
    assign subB[3][3][2] = B[7][6];
    assign subB[3][3][3] = B[7][7];

    matrix_addN u_add4x4_0 (
        .clk(clk),
        .A(subA[0]),
        .B(subB[0]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .flag(flag),
        .C(subC[0])
    );

    assign C[0][0] = subC[0][0][0];
    assign C[0][1] = subC[0][0][1];
    assign C[0][2] = subC[0][0][2];
    assign C[0][3] = subC[0][0][3];
    assign C[1][0] = subC[0][1][0];
    assign C[1][1] = subC[0][1][1];
    assign C[1][2] = subC[0][1][2];
    assign C[1][3] = subC[0][1][3];
    assign C[2][0] = subC[0][2][0];
    assign C[2][1] = subC[0][2][1];
    assign C[2][2] = subC[0][2][2];
    assign C[2][3] = subC[0][2][3];
    assign C[3][0] = subC[0][3][0];
    assign C[3][1] = subC[0][3][1];
    assign C[3][2] = subC[0][3][2];
    assign C[3][3] = subC[0][3][3];

    matrix_addN u_add4x4_1 (
        .clk(clk),
        .A(subA[1]),
        .B(subB[2]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .flag(flag),
        .C(subC[1])
    );

    assign C[0][4] = subC[1][0][0];
    assign C[0][5] = subC[1][0][1];
    assign C[0][6] = subC[1][0][2];
    assign C[0][7] = subC[1][0][3];

    assign C[1][4] = subC[1][1][0];
    assign C[1][5] = subC[1][1][1];
    assign C[1][6] = subC[1][1][2];
    assign C[1][7] = subC[1][1][3];

    assign C[2][4] = subC[1][2][0];
    assign C[2][5] = subC[1][2][1];
    assign C[2][6] = subC[1][2][2];
    assign C[2][7] = subC[1][2][3];

    assign C[3][4] = subC[1][3][0];
    assign C[3][5] = subC[1][3][1];
    assign C[3][6] = subC[1][3][2];
    assign C[3][7] = subC[1][3][3];

    matrix_addN u_add4x4_2 (
        .clk(clk),
        .A(subA[2]),
        .B(subB[2]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .flag(flag),
        .C(subC[2])
    );

    assign C[4][0] = subC[2][0][0];
    assign C[4][1] = subC[2][0][1];
    assign C[4][2] = subC[2][0][2];
    assign C[4][3] = subC[2][0][3];

    assign C[5][0] = subC[2][1][0];
    assign C[5][1] = subC[2][1][1];
    assign C[5][2] = subC[2][1][2];
    assign C[5][3] = subC[2][1][3];

    assign C[6][0] = subC[2][2][0];
    assign C[6][1] = subC[2][2][1];
    assign C[6][2] = subC[2][2][2];
    assign C[6][3] = subC[2][2][3];

    assign C[7][0] = subC[2][3][0];
    assign C[7][1] = subC[2][3][1];
    assign C[7][2] = subC[2][3][2];
    assign C[7][3] = subC[2][3][3];
    matrix_addN u_add4x4_3 (
        .clk(clk),
        .A(subA[3]),
        .B(subB[3]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .flag(flag),
        .C(subC[3])
    );
    assign C[4][4] = subC[3][0][0];
    assign C[4][5] = subC[3][0][1];
    assign C[4][6] = subC[3][0][2];
    assign C[4][7] = subC[3][0][3];

    assign C[5][4] = subC[3][1][0];
    assign C[5][5] = subC[3][1][1];
    assign C[5][6] = subC[3][1][2];
    assign C[5][7] = subC[3][1][3];

    assign C[6][4] = subC[3][2][0];
    assign C[6][5] = subC[3][2][1];
    assign C[6][6] = subC[3][2][2];
    assign C[6][7] = subC[3][2][3];
    
    assign C[7][4] = subC[3][3][0];
    assign C[7][5] = subC[3][3][1];
    assign C[7][6] = subC[3][3][2];
    assign C[7][7] = subC[3][3][3];
endmodule