`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/10 16:43:31
// Design Name: 
// Module Name: com_div
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


module com_div(
    input clk,
    input [23:0] efp8Binary1,
    input [23:0] efp8Binary1_i,
    input [23:0] efp8Binary2,
    input [23:0] efp8Binary2_i,
    input [4:0] m_bit1, // m_bit1 
    input [4:0] m_bit2, // m_bit2
    input wire [31:0][4:0]M1B2,//查找表输入
    input wire [79:0][5:0]M2B2, 
    input wire [191:0][6:0]M3B2,
    input wire [447:0][7:0] M4B2,
    input wire [1023:0][8:0] M5B2,
    input wire [2304:0][9:0] M6B2,
    output reg [4:0] result_m_bit,
    output reg [23:0] result_efp1,
    output reg [23:0] result_efp2
    );
// **********************程序说明***********************//
//24比特，按照1符号位，6指数位，17尾数位来划分
//存储范围从2^(-31)到2^(31)，测试时注意范围
//目前例化的查找表只有1-8位尾数位的
//总共7个时钟周期
//第1个时钟周期为同步，给复数乘置高控制信号
//2、3、4、5、6时钟为复数乘法
//7为结果输出
//**********************程序变量***********************//
parameter e_bias = 31;
wire [23:0] result_multi3;
wire [23:0] result_multi4;
reg [23:0] result_div1;
reg [23:0] result_div2;
reg [4:0] m_bit;
reg [23:0] efp1;
reg [23:0] efp2;
reg [7:0] cnt;
reg [7:0] cnt1;
reg flag;
reg flag1;

assign result_multi3 = efp8Binary2;
assign result_multi4[23] = ~efp8Binary2_i[23];
assign result_multi4[22:0] = efp8Binary2_i[22:0];

com_multi div_step1 (
    .clk(clk),
    .flag(flag),
    .efp8Binary1(efp8Binary1),
    .efp8Binary1_i(efp8Binary1_i),
    .efp8Binary2(result_multi3),
    .efp8Binary2_i(result_multi4),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .M1B2(M1B2),
    .M2B2(M2B2),
    .M3B2(M3B2),
    .M4B2(M4B2),
    .M5B2(M5B2),
    .M6B2(M6B2),
    .result_efp1(efp1),
    .result_efp2(efp2)
);

com_multi div_step2 (
    .clk(clk),
    .flag(flag1),
    .efp8Binary1(efp8Binary2),
    .efp8Binary1_i(efp8Binary2_i),
    .efp8Binary2(result_multi3),
    .efp8Binary2_i(result_multi4),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .M1B2(M1B2),
    .M2B2(M2B2),
    .M3B2(M3B2),
    .M4B2(M4B2),
    .M5B2(M5B2),
    .M6B2(M6B2),
    .result_efp1(result_div1),
    .result_efp2(result_div2)
);
always @(posedge clk ) begin
    result_m_bit <= (m_bit1 > m_bit2) ? m_bit1 : m_bit2;
    if(efp8Binary1 == 0 && efp8Binary1_i == 0) begin
        result_efp1 <= 0;
        result_efp2 <= 0;
        flag <= 0;
        flag1 <= 0;
    end  else if(efp8Binary1 == efp8Binary2 &&  efp8Binary1_i == efp8Binary2_i) begin
        result_efp1[23] <= 0;
        result_efp1[22:17] <= 7;
        result_efp1[16:0] <= 0;
        result_efp2[23] <= 0;
        result_efp2[22:17] <= 0;
        result_efp2[16:0] <= 0;
        flag <= 0;
        flag1 <= 0;
    end else if(cnt1<6)begin
        if(cnt1 == 0) begin//cnt=0,开始拉高，启动复数乘
            flag<=1;
            flag1<=1;
        end
        cnt1 <= cnt1+1;//cnt=1、2、3、4的时候完成复数乘
        if(cnt1 == 5) begin//在cnt为5时把电平拉低，进入下一阶段
            flag<=0;
            flag1<=0;
        end
    end else begin//1
        flag <= 0;
        flag1 <= 0;
        if(efp1[16:0]>=result_div1[16:0]) begin
            result_efp1[23] <= efp1[23] ^ result_div1[23];
            result_efp1[22:17] <= efp1[22:17]-result_div1[22:17]+e_bias;
            result_efp1[16:0] <= efp1[16:0]-result_div1[16:0];
        end else begin//借位1
            result_efp1[23] <= efp1[23] ^ result_div1[23];
            result_efp1[22:17] <= efp1[22:17]-result_div1[22:17]+e_bias-1;
            result_efp1[16:0] <= efp1[16:0]-result_div1[16:0]+(1<<m_bit1);
        end

        if(efp2[16:0]>=result_div1[16:0]) begin
            result_efp2[23] <= efp2[23] ^ result_div1[23];
            result_efp2[22:17] <= efp2[22:17]-result_div1[22:17]+e_bias;
            result_efp2[16:0] <= efp2[16:0]-result_div1[16:0];
        end else begin
            result_efp2[23] <= efp2[23] ^ result_div1[23];
            result_efp2[22:17] <= efp2[22:17]-result_div1[22:17]+e_bias-1;
            result_efp2[16:0] <= efp2[16:0]-result_div1[16:0]+(1<<m_bit1);
        end
        cnt <= 0;
        cnt1 <= 0;
    end
end  










endmodule
