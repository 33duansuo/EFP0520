module matrix_addN #(
    parameter width = 16
)(
    input clk,
    input [2*width-1:0] A[4-1:0][4-1:0],
    input [2*width-1:0] B[4-1:0][4-1:0],
    input [4:0] m_bit1,
    input [4:0] m_bit2,
    input flag,
    output [2*width-1:0] C[4-1:0][4-1:0]
);

    // 4×4矩阵加法分块实现
    wire [2*width-1:0] subA[3:0][1:0][1:0];
    wire [2*width-1:0] subB[3:0][1:0][1:0];
    wire [2*width-1:0] subC[3:0][1:0][1:0];
    wire [10:0] result_bin[3:0][7:0];
    wire [10:0] addra[3:0][7:0];

    // 手动展开的逻辑
    // 块 0
    assign subA[0][0][0] = A[0][0];
    assign subA[0][0][1] = A[0][1];
    assign subA[0][1][0] = A[1][0];
    assign subA[0][1][1] = A[1][1];

    assign subB[0][0][0] = B[0][0];
    assign subB[0][0][1] = B[0][1];
    assign subB[0][1][0] = B[1][0];
    assign subB[0][1][1] = B[1][1];

    matrix_add1 u_add2x2_0 (
        .clk(clk),
        .A(subA[0]),
        .B(subB[0]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin[0]),
        .flag(flag),
        .addra(addra[0]),
        .C(subC[0])
    );

    assign C[0][0] = subC[0][0][0];
    assign C[0][1] = subC[0][0][1];
    assign C[1][0] = subC[0][1][0];
    assign C[1][1] = subC[0][1][1];

    // 块 1
    assign subA[1][0][0] = A[0][2];
    assign subA[1][0][1] = A[0][3];
    assign subA[1][1][0] = A[1][2];
    assign subA[1][1][1] = A[1][3];

    assign subB[1][0][0] = B[0][2];
    assign subB[1][0][1] = B[0][3];
    assign subB[1][1][0] = B[1][2];
    assign subB[1][1][1] = B[1][3];

    matrix_add1 u_add2x2_1 (
        .clk(clk),
        .A(subA[1]),
        .B(subB[1]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin[1]),
        .flag(flag),
        .addra(addra[1]),
        .C(subC[1])
    );

    assign C[0][2] = subC[1][0][0];
    assign C[0][3] = subC[1][0][1];
    assign C[1][2] = subC[1][1][0];
    assign C[1][3] = subC[1][1][1];

    // 块 2
    assign subA[2][0][0] = A[2][0];
    assign subA[2][0][1] = A[2][1];
    assign subA[2][1][0] = A[3][0];
    assign subA[2][1][1] = A[3][1];

    assign subB[2][0][0] = B[2][0];
    assign subB[2][0][1] = B[2][1];
    assign subB[2][1][0] = B[3][0];
    assign subB[2][1][1] = B[3][1];

    matrix_add1 u_add2x2_2 (
        .clk(clk),
        .A(subA[2]),
        .B(subB[2]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin[2]),
        .flag(flag),
        .addra(addra[2]),
        .C(subC[2])
    );

    assign C[2][0] = subC[2][0][0];
    assign C[2][1] = subC[2][0][1];
    assign C[3][0] = subC[2][1][0];
    assign C[3][1] = subC[2][1][1];

    // 块 3
    assign subA[3][0][0] = A[2][2];
    assign subA[3][0][1] = A[2][3];
    assign subA[3][1][0] = A[3][2];
    assign subA[3][1][1] = A[3][3];

    assign subB[3][0][0] = B[2][2];
    assign subB[3][0][1] = B[2][3];
    assign subB[3][1][0] = B[3][2];
    assign subB[3][1][1] = B[3][3];

    matrix_add1 u_add2x2_3 (
        .clk(clk),
        .A(subA[3]),
        .B(subB[3]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin[3]),
        .flag(flag),
        .addra(addra[3]),
        .C(subC[3])
    );

    assign C[2][2] = subC[3][0][0];
    assign C[2][3] = subC[3][0][1];
    assign C[3][2] = subC[3][1][0];
    assign C[3][3] = subC[3][1][1];

    // 查找表模块实例化
    lut_add addN_lut_add (
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .addra(addra),
        .result_bin(result_bin)
    );

endmodule