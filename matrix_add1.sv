`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/15 19:52:12
// Design Name: 
// Module Name: matrix_add
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module matrix_add1
#(
    parameter width = 16
)
(
    input clk,
    input [2*width-1:0] A[1:0][1:0],
    input [2*width-1:0] B[1:0][1:0],
    input [4:0] m_bit1,
    input [4:0] m_bit2,
    input wire [10:0] result_bin[7:0],
    input flag,
    output reg [10:0] addra[7:0],
    output wire [2*width-1:0] C[1:0][1:0]
    );
// **********************程序说明***********************//
//48比特
//低位存储实数部分
//高位存储虚数部分
//1周期启动，5周期计算

// **********************程序变量***********************//
wire over0,over1,over2,over3;

// **********************模块实例化，复数加法5个周期***********************//
 com_add add_0_0(
    .clk(clk),
    .efp8Binary1(A[0][0][width-1:0]),
    .efp8Binary1_i(A[0][0][2*width-1:width]),
    .efp8Binary2(B[0][0][width-1:0]),
    .efp8Binary2_i(B[0][0][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[0]),
    .result_bin_i(result_bin[1]),
    .flag(flag),
    .addra(addra[0]),
    .addra_i(addra[1]),
    .result_efp1(C[0][0][width-1:0]),
    .result_efp2(C[0][0][2*width-1:width]),
    .over(over0)
    );
com_add add_0_1(
    .clk(clk),
    .efp8Binary1(A[0][1][width-1:0]),
    .efp8Binary1_i(A[0][1][2*width-1:width]),
    .efp8Binary2(B[0][1][width-1:0]),
    .efp8Binary2_i(B[0][1][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[2]),
    .result_bin_i(result_bin[3]),
    .flag(flag),
    .addra(addra[2]),
    .addra_i(addra[3]),
    .result_efp1(C[0][1][width-1:0]),
    .result_efp2(C[0][1][2*width-1:width]),
    .over(over1)
    );
com_add add_0_2(
    .clk(clk),
    .efp8Binary1(A[1][0][width-1:0]),
    .efp8Binary1_i(A[1][0][2*width-1:width]),
    .efp8Binary2(B[1][0][width-1:0]),
    .efp8Binary2_i(B[1][0][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[4]),
    .result_bin_i(result_bin[5]),
    .flag(flag),
    .addra(addra[4]),
    .addra_i(addra[5]),
    .result_efp1(C[1][0][width-1:0]),
    .result_efp2(C[1][0][2*width-1:width]),
    .over(over2)
    );
com_add add_0_3(
    .clk(clk),
    .efp8Binary1(A[1][1][width-1:0]),
    .efp8Binary1_i(A[1][1][2*width-1:width]),
    .efp8Binary2(B[1][1][width-1:0]),
    .efp8Binary2_i(B[1][1][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[6]),
    .result_bin_i(result_bin[7]),
    .flag(flag),
    .addra(addra[6]),
    .addra_i(addra[7]),
    .result_efp1(C[1][1][width-1:0]),
    .result_efp2(C[1][1][2*width-1:width]),
    .over(over3)
    );

endmodule
