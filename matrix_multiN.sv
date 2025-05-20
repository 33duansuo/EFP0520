module matrix_multiN #(
    parameter width = 16
)(
    input clk,
    input [2*width-1:0] A[4-1:0][4-1:0],
    input [2*width-1:0] B[4-1:0][4-1:0],
    input [4:0] m_bit1,
    input [4:0] m_bit2,
    input flag,
    input wire [10:0] result_bin_add[3:0][7:0],
    input wire [10:0] result_bin_mul[3:0][1:0][23:0],
    output wire [10:0] addra_add[3:0][7:0],
    output wire [10:0] addra_mul[3:0][1:0][23:0],
    output [2*width-1:0] C[4-1:0][4-1:0]
);

    // 子块信号
    wire [2*width-1:0] Aik[3:0][1:0][1:0];
    wire [2*width-1:0] Bkj[3:0][1:0][1:0];
    wire [2*width-1:0] M[3:0][1:0][1:0][1:0]; // 每个输出块2个乘法结果
    wire [2*width-1:0] S[3:0][1:0][1:0]; // 第一级加法

    // wire [10:0] result_bin_mul[3:0][1:0][23:0];
    // wire [10:0] addra_mul[3:0][1:0][23:0];
    // wire [10:0] result_bin_add[3:0][7:0];
    // wire [10:0] addra_add[3:0][7:0];

    // 块 0-0和块 0-1，1-0，1-1
    assign Aik[0][0][0] = A[0][0];
    assign Aik[0][0][1] = A[0][1];
    assign Aik[0][1][0] = A[1][0];
    assign Aik[0][1][1] = A[1][1];
    assign Bkj[0][0][0] = B[0][0];
    assign Bkj[0][0][1] = B[0][1];
    assign Bkj[0][1][0] = B[1][0];
    assign Bkj[0][1][1] = B[1][1];

    assign Aik[1][0][0] = A[0][2];
    assign Aik[1][0][1] = A[0][3];
    assign Aik[1][1][0] = A[1][2];
    assign Aik[1][1][1] = A[1][3];
    assign Bkj[1][0][0] = B[0][2];
    assign Bkj[1][0][1] = B[0][3];
    assign Bkj[1][1][0] = B[1][2];
    assign Bkj[1][1][1] = B[1][3];

    assign Aik[2][0][0] = A[2][0];
    assign Aik[2][0][1] = A[2][1];
    assign Aik[2][1][0] = A[3][0];
    assign Aik[2][1][1] = A[3][1];
    assign Bkj[2][0][0] = B[2][0];
    assign Bkj[2][0][1] = B[2][1];
    assign Bkj[2][1][0] = B[3][0];
    assign Bkj[2][1][1] = B[3][1];

    assign Aik[3][0][0] = A[2][2];
    assign Aik[3][0][1] = A[2][3];
    assign Aik[3][1][0] = A[3][2];
    assign Aik[3][1][1] = A[3][3];
    assign Bkj[3][0][0] = B[2][2];
    assign Bkj[3][0][1] = B[2][3];
    assign Bkj[3][1][0] = B[3][2];
    assign Bkj[3][1][1] = B[3][3];


    matrix_multi2 u_mul_00 (
        .clk(clk),
        .A(Aik[0]),
        .B(Bkj[0]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin_mul[0][0]),
        .flag(flag),
        .addra(addra_mul[0][0]),
        .matrix_over(),
        .C(M[0][0])
    );

    matrix_multi2 u_mul_01 (
        .clk(clk),
        .A(Aik[1]),
        .B(Bkj[2]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin_mul[0][1]),
        .flag(flag),
        .addra(addra_mul[0][1]),
        .matrix_over(),
        .C(M[0][1])
    );

    matrix_add1 u_add_00 (
        .clk(clk),
        .A(M[0][0]),
        .B(M[0][1]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin_add[0]),
        .flag(flag),
        .addra(addra_add[0]),
        .C(S[0])
    );

    assign C[0][0] = S[0][0][0];
    assign C[0][1] = S[0][0][1];
    assign C[1][0] = S[0][1][0];
    assign C[1][1] = S[0][1][1];


    matrix_multi2 u_mul_10 (
        .clk(clk),
        .A(Aik[0]),
        .B(Bkj[1]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin_mul[1][0]),
        .flag(flag),
        .addra(addra_mul[1][0]),
        .matrix_over(),
        .C(M[1][0])
    );

    matrix_multi2 u_mul_11 (
        .clk(clk),
        .A(Aik[1]),
        .B(Bkj[3]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin_mul[1][1]),
        .flag(flag),
        .addra(addra_mul[1][1]),
        .matrix_over(),
        .C(M[1][1])
    );

    matrix_add1 u_add_01 (
        .clk(clk),
        .A(M[1][0]),
        .B(M[1][1]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin_add[1]),
        .flag(flag),
        .addra(addra_add[1]),
        .C(S[1])
    );

    assign C[0][2] = S[1][0][0];
    assign C[0][3] = S[1][0][1];
    assign C[1][2] = S[1][1][0];
    assign C[1][3] = S[1][1][1];


    matrix_multi2 u_mul_20 (
        .clk(clk),
        .A(Aik[2]),
        .B(Bkj[0]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin_mul[2][0]),
        .flag(flag),
        .addra(addra_mul[2][0]),
        .matrix_over(),
        .C(M[2][0])
    );

    matrix_multi2 u_mul_21 (
        .clk(clk),
        .A(Aik[3]),
        .B(Bkj[2]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin_mul[2][1]),
        .flag(flag),
        .addra(addra_mul[2][1]),
        .matrix_over(),
        .C(M[2][1])
    );

    matrix_add1 u_add_10 (
        .clk(clk),
        .A(M[2][0]),
        .B(M[2][1]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin_add[2]),
        .flag(flag),
        .addra(addra_add[2]),
        .C(S[2])
    );

    assign C[2][0] = S[2][0][0];
    assign C[2][1] = S[2][0][1];
    assign C[3][0] = S[2][1][0];
    assign C[3][1] = S[2][1][1];

    matrix_multi2 u_mul_30 (
        .clk(clk),
        .A(Aik[2]),
        .B(Bkj[1]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin_mul[3][0]),
        .flag(flag),
        .addra(addra_mul[3][0]),
        .matrix_over(),
        .C(M[3][0])
    );

    matrix_multi2 u_mul_31 (
        .clk(clk),
        .A(Aik[3]),
        .B(Bkj[3]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin_mul[3][1]),
        .flag(flag),
        .addra(addra_mul[3][1]),
        .matrix_over(),
        .C(M[3][1])
    );

    matrix_add1 u_add_11 (
        .clk(clk),
        .A(M[3][0]),
        .B(M[3][1]),
        .m_bit1(m_bit1),
        .m_bit2(m_bit2),
        .result_bin(result_bin_add[3]),
        .flag(flag),
        .addra(addra_add[3]),
        .C(S[3])
    );

    assign C[2][2] = S[3][0][0];
    assign C[2][3] = S[3][0][1];
    assign C[3][2] = S[3][1][0];
    assign C[3][3] = S[3][1][1];

endmodule