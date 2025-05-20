module matrix_multi8 #(
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


    wire [10:0] result_bin_mul[7:0][3:0][1:0][23:0];
    wire [10:0] addra_mul[7:0][3:0][1:0][23:0];
    wire [10:0] result_bin_add[7:0][3:0][7:0];
    wire [10:0] addra_add[7:0][3:0][7:0];
    // 子块信号
    wire [2*width-1:0] Aik[3:0][3:0][3:0];
    wire [2*width-1:0] Bjk[3:0][3:0][3:0];
    wire [2*width-1:0] M[3:0][1:0][3:0][3:0]; // 每个输出块2个乘法结果
    wire [2*width-1:0] S[3:0][3:0][3:0]; // 第一级加法
    // 块 0-0和块 0-1，1-0，1-1
    assign Aik[0][0][0] = A[0][0];
    assign Aik[0][0][1] = A[0][1];
    assign Aik[0][0][2] = A[0][2];
    assign Aik[0][0][3] = A[0][3];
    assign Aik[0][1][0] = A[1][0];
    assign Aik[0][1][1] = A[1][1];
    assign Aik[0][1][2] = A[1][2];
    assign Aik[0][1][3] = A[1][3];
    assign Aik[0][2][0] = A[2][0];
    assign Aik[0][2][1] = A[2][1];
    assign Aik[0][2][2] = A[2][2];
    assign Aik[0][2][3] = A[2][3];
    assign Aik[0][3][0] = A[3][0];
    assign Aik[0][3][1] = A[3][1];
    assign Aik[0][3][2] = A[3][2];
    assign Aik[0][3][3] = A[3][3];

    assign Aik[1][0][0] = A[0][4];
    assign Aik[1][0][1] = A[0][5];
    assign Aik[1][0][2] = A[0][6];
    assign Aik[1][0][3] = A[0][7];
    assign Aik[1][1][0] = A[1][4];
    assign Aik[1][1][1] = A[1][5];
    assign Aik[1][1][2] = A[1][6];
    assign Aik[1][1][3] = A[1][7];
    assign Aik[1][2][0] = A[2][4];
    assign Aik[1][2][1] = A[2][5];
    assign Aik[1][2][2] = A[2][6];
    assign Aik[1][2][3] = A[2][7];
    assign Aik[1][3][0] = A[3][4];
    assign Aik[1][3][1] = A[3][5];
    assign Aik[1][3][2] = A[3][6];
    assign Aik[1][3][3] = A[3][7];

    assign Aik[2][0][0] = A[4][0];
    assign Aik[2][0][1] = A[4][1];
    assign Aik[2][0][2] = A[4][2];
    assign Aik[2][0][3] = A[4][3];
    assign Aik[2][1][0] = A[5][0];
    assign Aik[2][1][1] = A[5][1];
    assign Aik[2][1][2] = A[5][2];
    assign Aik[2][1][3] = A[5][3];
    assign Aik[2][2][0] = A[6][0];
    assign Aik[2][2][1] = A[6][1];
    assign Aik[2][2][2] = A[6][2];
    assign Aik[2][2][3] = A[6][3];
    assign Aik[2][3][0] = A[7][0];
    assign Aik[2][3][1] = A[7][1];
    assign Aik[2][3][2] = A[7][2];
    assign Aik[2][3][3] = A[7][3];
    
    assign Aik[3][0][0] = A[4][4];
    assign Aik[3][0][1] = A[4][5];
    assign Aik[3][0][2] = A[4][6];
    assign Aik[3][0][3] = A[4][7];
    assign Aik[3][1][0] = A[5][4];
    assign Aik[3][1][1] = A[5][5];
    assign Aik[3][1][2] = A[5][6];
    assign Aik[3][1][3] = A[5][7];
    assign Aik[3][2][0] = A[6][4];
    assign Aik[3][2][1] = A[6][5];
    assign Aik[3][2][2] = A[6][6];
    assign Aik[3][2][3] = A[6][7];
    assign Aik[3][3][0] = A[7][4];
    assign Aik[3][3][1] = A[7][5];
    assign Aik[3][3][2] = A[7][6];
    assign Aik[3][3][3] = A[7][7];

    assign Bjk[0][0][0] = B[0][0];
    assign Bjk[0][0][1] = B[0][1];
    assign Bjk[0][0][2] = B[0][2];
    assign Bjk[0][0][3] = B[0][3];
    assign Bjk[0][1][0] = B[1][0];
    assign Bjk[0][1][1] = B[1][1];
    assign Bjk[0][1][2] = B[1][2];
    assign Bjk[0][1][3] = B[1][3];
    assign Bjk[0][2][0] = B[2][0];
    assign Bjk[0][2][1] = B[2][1];
    assign Bjk[0][2][2] = B[2][2];
    assign Bjk[0][2][3] = B[2][3];
    assign Bjk[0][3][0] = B[3][0];
    assign Bjk[0][3][1] = B[3][1];
    assign Bjk[0][3][2] = B[3][2];
    assign Bjk[0][3][3] = B[3][3];

    assign Bjk[1][0][0] = B[0][4];
    assign Bjk[1][0][1] = B[0][5];
    assign Bjk[1][0][2] = B[0][6];
    assign Bjk[1][0][3] = B[0][7];
    assign Bjk[1][1][0] = B[1][4];
    assign Bjk[1][1][1] = B[1][5];
    assign Bjk[1][1][2] = B[1][6];
    assign Bjk[1][1][3] = B[1][7];
    assign Bjk[1][2][0] = B[2][4];
    assign Bjk[1][2][1] = B[2][5];
    assign Bjk[1][2][2] = B[2][6];
    assign Bjk[1][2][3] = B[2][7];
    assign Bjk[1][3][0] = B[3][4];
    assign Bjk[1][3][1] = B[3][5];
    assign Bjk[1][3][2] = B[3][6];
    assign Bjk[1][3][3] = B[3][7];

    assign Bjk[2][0][0] = B[4][0];
    assign Bjk[2][0][1] = B[4][1];
    assign Bjk[2][0][2] = B[4][2];
    assign Bjk[2][0][3] = B[4][3];
    assign Bjk[2][1][0] = B[5][0];
    assign Bjk[2][1][1] = B[5][1];
    assign Bjk[2][1][2] = B[5][2];
    assign Bjk[2][1][3] = B[5][3];
    assign Bjk[2][2][0] = B[6][0];
    assign Bjk[2][2][1] = B[6][1];
    assign Bjk[2][2][2] = B[6][2];
    assign Bjk[2][2][3] = B[6][3];
    assign Bjk[2][3][0] = B[7][0];
    assign Bjk[2][3][1] = B[7][1];
    assign Bjk[2][3][2] = B[7][2];
    assign Bjk[2][3][3] = B[7][3];

    assign Bjk[3][0][0] = B[4][4];
    assign Bjk[3][0][1] = B[4][5];
    assign Bjk[3][0][2] = B[4][6];
    assign Bjk[3][0][3] = B[4][7];
    assign Bjk[3][1][0] = B[5][4];
    assign Bjk[3][1][1] = B[5][5];
    assign Bjk[3][1][2] = B[5][6];
    assign Bjk[3][1][3] = B[5][7];
    assign Bjk[3][2][0] = B[6][4];
    assign Bjk[3][2][1] = B[6][5];
    assign Bjk[3][2][2] = B[6][6];
    assign Bjk[3][2][3] = B[6][7];
    assign Bjk[3][3][0] = B[7][4];
    assign Bjk[3][3][1] = B[7][5];
    assign Bjk[3][3][2] = B[7][6];
    assign Bjk[3][3][3] = B[7][7];


    matrix_multiN u_mul4x4_00 (
        .clk(clk),
        .A(Aik[0]),
        .B(Bjk[0]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin_add(result_bin_add[0]),
        .result_bin_mul(result_bin_mul[0]),
        .flag(flag),
        .addra_add(addra_add[0]),
        .addra_mul(addra_mul[0]),
        .C(M[0][0])
    );

    matrix_multiN u_mul4x4_01 (
        .clk(clk),
        .A(Aik[1]),
        .B(Bjk[2]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin_add(result_bin_add[1]),
        .result_bin_mul(result_bin_mul[1]),
        .flag(flag),
        .addra_add(addra_add[1]),
        .addra_mul(addra_mul[1]),
        .C(M[0][1])
    );

    matrix_addN u_add4x4_00 (
        .clk(clk),
        .A(M[0][0]),
        .B(M[0][1]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .flag(flag),
        .C(S[0])
    );

    assign C[0][0] = S[0][0][0];
    assign C[0][1] = S[0][0][1];
    assign C[0][2] = S[0][0][2];
    assign C[0][3] = S[0][0][3];
    assign C[1][0] = S[0][1][0];
    assign C[1][1] = S[0][1][1];
    assign C[1][2] = S[0][1][2];
    assign C[1][3] = S[0][1][3];
    assign C[2][0] = S[0][2][0];
    assign C[2][1] = S[0][2][1];
    assign C[2][2] = S[0][2][2];
    assign C[2][3] = S[0][2][3];
    assign C[3][0] = S[0][3][0];
    assign C[3][1] = S[0][3][1];
    assign C[3][2] = S[0][3][2];
    assign C[3][3] = S[0][3][3];

    matrix_multiN u_mul4x4_10 (
        .clk(clk),
        .A(Aik[0]),
        .B(Bjk[1]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin_add(result_bin_add[2]),
        .result_bin_mul(result_bin_mul[2]),
        .flag(flag),
        .addra_add(addra_add[2]),
        .addra_mul(addra_mul[2]),
        .C(M[1][0])
    );

    matrix_multiN u_mul4x4_11 (
        .clk(clk),
        .A(Aik[1]),
        .B(Bjk[3]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin_add(result_bin_add[3]),
        .result_bin_mul(result_bin_mul[3]),
        .flag(flag),
        .addra_add(addra_add[3]),
        .addra_mul(addra_mul[3]),
        .C(M[1][1])
    );

    matrix_addN u_add4x4_01 (
        .clk(clk),
        .A(M[1][0]),
        .B(M[1][1]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .flag(flag),
        .C(S[1])
    );

    assign C[0][4] = S[1][0][0];
    assign C[0][5] = S[1][0][1];
    assign C[0][6] = S[1][0][2];
    assign C[0][7] = S[1][0][3];
    assign C[1][4] = S[1][1][0];
    assign C[1][5] = S[1][1][1];
    assign C[1][6] = S[1][1][2];
    assign C[1][7] = S[1][1][3];
    assign C[2][4] = S[1][2][0];
    assign C[2][5] = S[1][2][1];
    assign C[2][6] = S[1][2][2];
    assign C[2][7] = S[1][2][3];
    assign C[3][4] = S[1][3][0];
    assign C[3][5] = S[1][3][1];
    assign C[3][6] = S[1][3][2];
    assign C[3][7] = S[1][3][3];

    matrix_multiN u_mul4x4_20 (
        .clk(clk),
        .A(Aik[2]),
        .B(Bjk[0]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin_add(result_bin_add[4]),
        .result_bin_mul(result_bin_mul[4]),
        .flag(flag),
        .addra_add(addra_add[4]),
        .addra_mul(addra_mul[4]),
        .C(M[2][0])
    );

    matrix_multiN u_mul4x4_21 (
        .clk(clk),
        .A(Aik[3]),
        .B(Bjk[2]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin_add(result_bin_add[5]),
        .result_bin_mul(result_bin_mul[5]),
        .flag(flag),
        .addra_add(addra_add[5]),
        .addra_mul(addra_mul[5]),
        .C(M[2][1])
    );

    matrix_addN u_add4x4_02 (
        .clk(clk),
        .A(M[2][0]),
        .B(M[2][1]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .flag(flag),
        .C(S[2])
    );
    assign C[4][0] = S[2][0][0];
    assign C[4][1] = S[2][0][1];
    assign C[4][2] = S[2][0][2];
    assign C[4][3] = S[2][0][3];
    assign C[5][0] = S[2][1][0];
    assign C[5][1] = S[2][1][1];
    assign C[5][2] = S[2][1][2];
    assign C[5][3] = S[2][1][3];
    assign C[6][0] = S[2][2][0];
    assign C[6][1] = S[2][2][1];
    assign C[6][2] = S[2][2][2];
    assign C[6][3] = S[2][2][3];
    assign C[7][0] = S[2][3][0];
    assign C[7][1] = S[2][3][1];
    assign C[7][2] = S[2][3][2];
    assign C[7][3] = S[2][3][3];

    matrix_multiN u_mul4x4_30 (
        .clk(clk),
        .A(Aik[2]),
        .B(Bjk[1]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin_add(result_bin_add[6]),
        .result_bin_mul(result_bin_mul[6]),
        .flag(flag),
        .addra_add(addra_add[6]),
        .addra_mul(addra_mul[6]),
        .C(M[3][0])
    );

    matrix_multiN u_mul4x4_31 (
        .clk(clk),
        .A(Aik[3]),
        .B(Bjk[3]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin_add(result_bin_add[7]),
        .result_bin_mul(result_bin_mul[7]),
        .flag(flag),
        .addra_add(addra_add[7]),
        .addra_mul(addra_mul[7]),
        .C(M[3][1])
    );

    matrix_addN u_add4x4_03 (
        .clk(clk),
        .A(M[3][0]),
        .B(M[3][1]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .flag(flag),
        .C(S[3])
    );
    assign C[4][4] = S[3][0][0];
    assign C[4][5] = S[3][0][1];
    assign C[4][6] = S[3][0][2];
    assign C[4][7] = S[3][0][3];
    assign C[5][4] = S[3][1][0];
    assign C[5][5] = S[3][1][1];
    assign C[5][6] = S[3][1][2];
    assign C[5][7] = S[3][1][3];
    assign C[6][4] = S[3][2][0];
    assign C[6][5] = S[3][2][1];
    assign C[6][6] = S[3][2][2];
    assign C[6][7] = S[3][2][3];
    assign C[7][4] = S[3][3][0];
    assign C[7][5] = S[3][3][1];
    assign C[7][6] = S[3][3][2];
    assign C[7][7] = S[3][3][3];

    lut_mul mulN_lut_mul (
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .addra_add(addra_add),
        .addra_mul(addra_mul),
        .result_bin_add(result_bin_add),
        .result_bin_mul(result_bin_mul)
    );

endmodule