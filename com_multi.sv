`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/31 13:47:53
// Design Name: 
// Module Name: com_multi
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


module com_multi
#(
    parameter width = 16
)
(
    input clk,
    input [width-1:0] efp8Binary1,
    input [width-1:0] efp8Binary1_i,
    input [width-1:0] efp8Binary2,
    input [width-1:0] efp8Binary2_i,
    input [4:0] m_bit1, // m_bit1 
    input [4:0] m_bit2, // m_bit2 
    input wire [10:0] result_bin,
    input wire [10:0] result_bin_i,
    input flag,
    output wire [10:0] addra,
    output wire [10:0] addra_i,
    output reg [width-1:0] result_efp1,
    output reg [width-1:0] result_efp2,
    output reg over
    );
// **********************程序说明***********************//
//24比特，按照1符号位，6指数位，17尾数位来划分
//存储范围从2^(-31)到2^(31)，测试时注意范围
//目前例化的查找表只有1-8位尾数位的
//总共5个时钟周期
//第1个时钟周期进行四次乘法（并行）
//第2、3、4时钟周期进行两次加法（并行）
//第5时钟周期输出结果

//**********************程序变量***********************//
reg [width-1:0] result_multi1;
reg [width-1:0] result_multi2;
reg [width-1:0] result_multi3;
reg [width-1:0] result_multi4;
reg cal_over;
reg cal_over_i;
reg [7:0] cnt;
reg [7:0] cnt1;
reg flag_addre;
reg flag_addim;

reg result_sign;
reg result_sign_i;
reg [5:0]e_binary;
reg [5:0]e_binary_i;
reg [width-8:0]m_binary;
reg [width-8:0]m_binary_i;

wire [width-1:0] result_multi1_1;
wire [width-1:0] result_multi2_1;
wire [width-1:0] result_multi3_1;
wire [width-1:0] result_multi4_1;

//两个虚部的相乘符号位要取反
assign result_multi1_1 = result_multi1;
assign result_multi2_1 = result_multi2;
assign result_multi3_1 = result_multi3;
assign result_multi4_1[width-1] = ~result_multi4[width-1];
assign result_multi4_1[width-2:0] = result_multi4[width-2:0];

efp_multi com_mul_step00(
    .clk(clk),
    .efp8Binary1(efp8Binary1),
    .efp8Binary2(efp8Binary2),
    .m_bit1(m_bit1), // m_bit1 
    .m_bit2(m_bit2), // m_bit2 
    .res_efp(result_multi1)
    );

efp_multi com_mul_step01(
    .clk(clk),
    .efp8Binary1(efp8Binary1),
    .efp8Binary2(efp8Binary2_i),
    .m_bit1(m_bit1), // m_bit1 
    .m_bit2(m_bit2), // m_bit2 
    .res_efp(result_multi2)
    );

efp_multi com_mul_step02(
    .clk(clk),
    .efp8Binary1(efp8Binary1_i),
    .efp8Binary2(efp8Binary2),
    .m_bit1(m_bit1), 
    .m_bit2(m_bit2), 
    .res_efp(result_multi3)
);

efp_multi com_mul_step03(
    .clk(clk),
    .efp8Binary1(efp8Binary1_i),
    .efp8Binary2(efp8Binary2_i),
    .m_bit1(m_bit1),  
    .m_bit2(m_bit2), 
    .res_efp(result_multi4)
);

Add1 com_mul_step10 (
    .clk(clk),
    .efp8Binary1(result_multi1_1),
    .efp8Binary2(result_multi4_1),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin),
    .flag(flag_addre),
    .addra(addra),
    .sign_result(result_sign),
    .result_exp(e_binary),
    .result_man(m_binary),
    .cal_over(cal_over)
);

Add1 com_mul_step11 (
    .clk(clk),
    .efp8Binary1(result_multi2_1),
    .efp8Binary2(result_multi3_1),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .result_bin(result_bin_i),
    .flag(flag_addim),
    .addra(addra_i),
    .sign_result(result_sign_i),
    .result_exp(e_binary_i),
    .result_man(m_binary_i),
    .cal_over(cal_over_i)
);

always @(posedge clk ) begin
    if(flag == 1) begin
        if(efp8Binary1 == 0 && efp8Binary1_i == 0) begin
            result_efp1 <= 0;
            result_efp2 <= 0;
            flag_addim <= 0;
            flag_addre <= 0;
            over <= 0;
        end else if(efp8Binary2 == 0 && efp8Binary2_i == 0) begin
            result_efp1 <= 0;
            result_efp2 <= 0;
            flag_addim <= 0;
            flag_addre <= 0;
            over <= 0;
        end else if(cnt<1 ) begin//1
            cnt <= cnt+1;
            flag_addre <= 1;
            flag_addim <= 1;
            over <= 0;
        end else if(cnt1 < 3) begin//3
            cnt1 <= cnt1+1;
            over <= 0;
        end else begin//1
            flag_addim <= 0;
            flag_addre <= 0;
            result_efp1[width-1] <= result_sign;
            result_efp1[width-2:width-7] <= e_binary;
            result_efp1[width-8:0] <= m_binary;
            result_efp2[width-1] <= result_sign_i;
            result_efp2[width-2:width-7] <= e_binary_i;
            result_efp2[width-8:0] <= m_binary_i;
            over <= 1;
            cnt <= 0;
            cnt1 <= 0;
        end
    end else begin
            flag_addim <= 0;
            over <= 0;
            flag_addre <= 0;
            cnt <= 0;
            cnt1 <= 0;
    end
end

endmodule
