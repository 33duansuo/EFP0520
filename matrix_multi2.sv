`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/15 20:width-1:00
// Design Name: 
// Module Name: matrix_multi
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


module matrix_multi2
#(
    parameter width = 16
)
(
    input clk,
    input [2*width-1:0] A[1:0][1:0],
    input [2*width-1:0] B[1:0][1:0],
    input [4:0] m_bit1,
    input [4:0] m_bit2,
    input wire [10:0] result_bin[23:0],
    input flag,
    output reg [10:0] addra[23:0],
    output reg matrix_over,
    output reg [2*width-1:0] C[1:0][1:0]
    );
// **********************程序说明***********************//
//这里注意一个48比特中
//低位存储实数部分
//高位存储虚数部分
//固定2×2矩阵乘法计算，带虚部
//一次计算时钟周期：1+7+7+1=16周期
// **********************程序变量***********************// 
reg mul_flag;
reg add_flag;
reg [7:0] cnt0,cnt1,cnt2;
wire over0,over1,over2,over3,over4,over5,over6,over7;
wire add_over0,add_over1,add_over2,add_over3;
wire  [2*width-1:0] c[7:0];
wire  [2*width-1:0] d[3:0];
// **********************模块实例化***********************//
 com_multi mat_mul_00(
    .clk(clk),
    .efp8Binary1(A[0][0][width-1:0]),
    .efp8Binary1_i(A[0][0][2*width-1:width]),
    .efp8Binary2(B[0][0][width-1:0]),
    .efp8Binary2_i(B[0][0][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[0]),
    .result_bin_i(result_bin[1]),
    .flag(mul_flag),
    .addra(addra[0]),
    .addra_i(addra[1]),
    .result_efp1(c[0][width-1:0]),
    .result_efp2(c[0][2*width-1:width]),
    .over(over0)
    );

 com_multi mat_mul_01(
    .clk(clk),
    .efp8Binary1(A[0][1][width-1:0]),
    .efp8Binary1_i(A[0][1][2*width-1:width]),
    .efp8Binary2(B[1][0][width-1:0]),
    .efp8Binary2_i(B[1][0][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[2]),
    .result_bin_i(result_bin[3]),
    .flag(mul_flag),
    .addra(addra[2]),
    .addra_i(addra[3]),
    .result_efp1(c[1][width-1:0]),
    .result_efp2(c[1][2*width-1:width]),
    .over(over1)
    );

com_multi mat_mul_02(
    .clk(clk),
    .efp8Binary1(A[0][0][width-1:0]),
    .efp8Binary1_i(A[0][0][2*width-1:width]),
    .efp8Binary2(B[0][1][width-1:0]),
    .efp8Binary2_i(B[0][1][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[4]),
    .result_bin_i(result_bin[5]),
    .flag(mul_flag),
    .addra(addra[4]),
    .addra_i(addra[5]),
    .result_efp1(c[2][width-1:0]),
    .result_efp2(c[2][2*width-1:width]),
    .over(over2)
    );
com_multi mat_mul_03(
    .clk(clk),
    .efp8Binary1(A[0][1][width-1:0]),
    .efp8Binary1_i(A[0][1][2*width-1:width]),
    .efp8Binary2(B[1][1][width-1:0]),
    .efp8Binary2_i(B[1][1][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[6]),
    .result_bin_i(result_bin[7]),
    .flag(mul_flag),
    .addra(addra[6]),
    .addra_i(addra[7]),
    .result_efp1(c[3][width-1:0]),
    .result_efp2(c[3][2*width-1:width]),
    .over(over3)
    );

com_multi mat_mul_04(
    .clk(clk),
    .efp8Binary1(A[1][0][width-1:0]),
    .efp8Binary1_i(A[1][0][2*width-1:width]),
    .efp8Binary2(B[0][0][width-1:0]),
    .efp8Binary2_i(B[0][0][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[8]),
    .result_bin_i(result_bin[9]),
    .flag(mul_flag),
    .addra(addra[8]),
    .addra_i(addra[9]),
    .result_efp1(c[4][width-1:0]),
    .result_efp2(c[4][2*width-1:width]),
    .over(over4)
    );
com_multi mat_mul_05(
    .clk(clk),
    .efp8Binary1(A[1][1][width-1:0]),
    .efp8Binary1_i(A[1][1][2*width-1:width]),
    .efp8Binary2(B[0][1][width-1:0]),
    .efp8Binary2_i(B[0][1][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[10]),
    .result_bin_i(result_bin[11]),
    .flag(mul_flag),
    .addra(addra[10]),
    .addra_i(addra[11]),
    .result_efp1(c[5][width-1:0]),
    .result_efp2(c[5][2*width-1:width]),
    .over(over5)
    );

com_multi mat_mul_06(
    .clk(clk),
    .efp8Binary1(A[1][0][width-1:0]),
    .efp8Binary1_i(A[1][0][2*width-1:width]),
    .efp8Binary2(B[1][0][width-1:0]),
    .efp8Binary2_i(B[1][0][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[12]),
    .result_bin_i(result_bin[13]),
    .flag(mul_flag),
    .addra(addra[12]),
    .addra_i(addra[13]),
    .result_efp1(c[6][width-1:0]),
    .result_efp2(c[6][2*width-1:width]),
    .over(over6)
    );
com_multi mat_mul_07(
    .clk(clk),
    .efp8Binary1(A[1][1][width-1:0]),
    .efp8Binary1_i(A[1][1][2*width-1:width]),
    .efp8Binary2(B[1][1][width-1:0]),
    .efp8Binary2_i(B[1][1][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[14]),
    .result_bin_i(result_bin[15]),
    .flag(mul_flag),
    .addra(addra[14]),
    .addra_i(addra[15]),
    .result_efp1(c[7][width-1:0]),
    .result_efp2(c[7][2*width-1:width]),
    .over(over7)
    );


com_add matadd_00(
    .clk(clk),
    .efp8Binary1(c[0][width-1:0]),
    .efp8Binary1_i(c[0][2*width-1:width]),
    .efp8Binary2(c[1][width-1:0]),
    .efp8Binary2_i(c[1][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[16]),
    .result_bin_i(result_bin[17]),
    .flag(add_flag),
    .addra(addra[16]),
    .addra_i(addra[17]),
    .result_efp1(d[0][width-1:0]),
    .result_efp2(d[0][2*width-1:width]),
    .over(add_over0)
    );
com_add matadd_01(
    .clk(clk),
    .efp8Binary1(c[2][width-1:0]),
    .efp8Binary1_i(c[2][2*width-1:width]),
    .efp8Binary2(c[3][width-1:0]),
    .efp8Binary2_i(c[3][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[18]),
    .result_bin_i(result_bin[19]),
    .flag(add_flag),
    .addra(addra[18]),
    .addra_i(addra[19]),
    .result_efp1(d[1][width-1:0]),
    .result_efp2(d[1][2*width-1:width]),
    .over(add_over1)
    );
com_add matadd_02(
    .clk(clk),
    .efp8Binary1(c[4][width-1:0]),
    .efp8Binary1_i(c[4][2*width-1:width]),
    .efp8Binary2(c[5][width-1:0]),
    .efp8Binary2_i(c[5][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[20]),
    .result_bin_i(result_bin[21]),
    .flag(add_flag),
    .addra(addra[20]),
    .addra_i(addra[21]),
    .result_efp1(d[2][width-1:0]),
    .result_efp2(d[2][2*width-1:width]),
    .over(add_over2)
    );
com_add matadd_03(
    .clk(clk),
    .efp8Binary1(c[6][width-1:0]),
    .efp8Binary1_i(c[6][2*width-1:width]),
    .efp8Binary2(c[7][width-1:0]),
    .efp8Binary2_i(c[7][2*width-1:width]),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin[22]),
    .result_bin_i(result_bin[23]),
    .flag(add_flag),
    .addra(addra[22]),
    .addra_i(addra[23]),
    .result_efp1(d[3][width-1:0]),
    .result_efp2(d[3][2*width-1:width]),
    .over(add_over3)
    );
// **********************周期设计***********************//
always @(posedge clk ) begin
    if(flag == 1) 
    begin
        if(cnt0 < 1) 
        begin//1个周期开始
            matrix_over <= 0;
            cnt0 <= cnt0 + 1;
            mul_flag <= 1;
        end else if (cnt1 < 5) 
        begin//5个周期乘法结束
            cnt1 <= cnt1 + 1;
            if(cnt1 == 4) 
            begin
                add_flag <= 1;
            end
        end else if (cnt2 < 5) 
        begin//5个周期加法结束
            cnt2 <= cnt2 +1;
        end else 
        begin
            C[0][0] <= d[0];
            C[0][1] <= d[1];
            C[1][0] <= d[2];
            C[1][1] <= d[3];
            cnt0 <= 0;
            cnt1 <= 0;
            cnt2 <= 0;
            matrix_over <= 1;
        end
    end else 
    begin
            cnt0 <= 0;
            cnt1 <= 0;
            cnt2 <= 0;
            matrix_over <= 0;
    end
end




endmodule

