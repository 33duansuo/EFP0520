`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/14 17:59:25
// Design Name: 
// Module Name: Add1
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
module Add1#(
    parameter width = 16
)
( 
    input clk,
    input [width-1:0] efp8Binary1, // 
    input [width-1:0] efp8Binary2,
    input [4:0] m_bit1, //
    input [4:0] m_bit2, //
    input wire [10:0] result_bin,
    input flag,
    output reg [10:0]addra,
    output reg  sign_result, // 
    output reg  [5:0]result_exp, // 
    output reg  [8:0]result_man, // 
    output reg  cal_over // 
);
// **********************程序说明***********************//
//24比特，按照1符号位，6指数位，17尾数位来划分
//存储范围从2^(-31)到2^(31)，测试时注意范围
//目前例化的查找表只有1-8位尾数位的
//总共五个时钟周期
//第一个时钟周期确定计算的符号位、查找加法表还是减法表
//第二个时钟周期确定查找表
//第三个时钟周期输出结果
// **********************程序变量***********************//
//注意e_bias=15这个是跟查找表相关的参数，不可以更改
localparam e_bit1=6;
localparam bias1=31;
localparam e_bit2=6;
localparam bias2=31;
localparam e_bias=15;

reg stage1_done=0;
reg stage2_done=0;
reg sign=0;
wire signBit1, signBit2;
wire [5:0] exponentBits1, exponentBits2;
wire  [width-8:0]fractionBits1, fractionBits2;
wire [6:0] e_diff;
wire [4:0]max_m_bit;
wire [10:0]result_bin_reg;

assign signBit1 = (efp8Binary1[width-2:width-7] >= efp8Binary2[width-2:width-7])? efp8Binary1[width-1]:efp8Binary2[width-1];
assign signBit2 = (efp8Binary1[width-2:width-7] >= efp8Binary2[width-2:width-7])? efp8Binary2[width-1]:efp8Binary1[width-1];
assign exponentBits1 = (efp8Binary1[width-2:width-7] >= efp8Binary2[width-2:width-7])? efp8Binary1[width-2:width-7]:efp8Binary2[width-2:width-7];
assign exponentBits2 = (efp8Binary1[width-2:width-7] >= efp8Binary2[width-2:width-7])? efp8Binary2[width-2:width-7]:efp8Binary1[width-2:width-7];   
assign fractionBits1 = (efp8Binary1[width-2:width-7] >= efp8Binary2[width-2:width-7]) ? efp8Binary1[width-8:0]: efp8Binary2[width-8:0];  
assign fractionBits2 = (efp8Binary1[width-2:width-7] >= efp8Binary2[width-2:width-7]) ? efp8Binary2[width-8:0]: efp8Binary1[width-8:0];  
assign e_diff = (efp8Binary1[width-2:width-7] >= efp8Binary2[width-2:width-7])?(efp8Binary1[width-2:width-7]-efp8Binary2[width-2:width-7]):(efp8Binary2[width-2:width-7]-efp8Binary1[width-2:width-7]);
assign max_m_bit = (m_bit1>m_bit2)? m_bit1:m_bit2;
assign result_bin_reg = (fractionBits1 >= fractionBits2)? (result_bin + fractionBits2):(result_bin + fractionBits1);


always @(posedge clk ) begin
        if(efp8Binary1[width-2:0] == 0) begin//
                cal_over <= 1;
                result_exp <= efp8Binary2[width-2:width-7];
                result_man <= efp8Binary2[width-8:0];
                sign_result <= efp8Binary2[width-1];
                stage1_done <= 0;
                stage2_done <= 0;
        end else if (efp8Binary2[width-2:0] == 0) begin
                cal_over <= 1;
                result_exp <= efp8Binary1[width-2:width-7];
                result_man <= efp8Binary1[width-8:0];
                sign_result <= efp8Binary1[width-1];
                stage1_done <= 0;
                stage2_done <= 0;
        end else if(efp8Binary1[width-2:0] == efp8Binary2[width-2:0] && efp8Binary1[width-1] != efp8Binary2[width-1]) begin
                cal_over <= 1;
                result_exp <= 0;
                result_man <= 0;
                sign_result <= 0;
                stage1_done <= 0;
                stage2_done <= 0;
        end else begin 
                if (flag == 1) begin
                        if (stage1_done == 0&&stage2_done == 0) begin
                                stage1_done <= 1;
                                cal_over <= 0;
                                if (efp8Binary1[width-1] == efp8Binary2[width-1]) begin
                                sign_result <= efp8Binary1[width-1];
                                sign<=0;
                                end else begin
                                        sign<=1;
                                        if (exponentBits1 == exponentBits2) begin
                                                if (fractionBits1 == fractionBits2) begin
                                                        sign_result <= 0;
                                                end
                                                else if (fractionBits1 > fractionBits2) begin
                                                        sign_result <= signBit1;
                                                end
                                                else begin
                                                        sign_result <= signBit2;
                                                end
                                        end else  begin
                                        sign_result <= signBit1;
                                        end
                                end
                        end else if (stage1_done == 1&&stage2_done == 0) begin
                                cal_over <= 0;
                                if(2+max_m_bit > e_diff||2+max_m_bit == e_diff) begin 
                                         if (max_m_bit == 1) begin
                                                if (sign==0) begin //
                                                        if (fractionBits2>=fractionBits1) 
                                                        begin
                                                                addra <= (e_diff<<2)+fractionBits2-fractionBits1;  
                                                        end else begin
                                                                addra <= (e_diff<<2)+fractionBits1-fractionBits2+2;
                                                        end
                                                end else begin // 
                                                        if(fractionBits2>=fractionBits1) 
                                                        begin
                                                                addra <= width-8+(e_diff<<3)+fractionBits2-fractionBits1;
                                                        end else begin
                                                                addra <= width-8+(e_diff<<3)+fractionBits1-fractionBits2+2;
                                                        end
                                                end 
                                        end else if (max_m_bit == 2) begin
                                                if (sign==0) begin //
                                                        if (fractionBits2>=fractionBits1) 
                                                        begin
                                                                addra <= (e_diff<<3)+fractionBits2-fractionBits1;  
                                                        end else begin
                                                                addra <= (e_diff<<3)+fractionBits1-fractionBits2+4;
                                                        end
                                                end else begin // 
                                                        if(fractionBits2>=fractionBits1) 
                                                        begin
                                                                addra <= 40+(e_diff<<3)+fractionBits2-fractionBits1;
                                                        end else begin
                                                                addra <= 40+(e_diff<<3)+fractionBits1-fractionBits2+4;
                                                        end
                                                end 
                                        end else if (max_m_bit == 3) begin
                                                if (sign==0) begin // 
                                                        if(fractionBits2>=fractionBits1) begin
                                                                addra <= (e_diff<<4)+fractionBits2-fractionBits1;
                                                        end else begin
                                                                addra <= (e_diff<<4)+fractionBits1-fractionBits2+8;
                                                        end 
                                                end else begin // 
                                                        if(fractionBits2>=fractionBits1) begin
                                                                addra <= 96+(e_diff<<4)+fractionBits2-fractionBits1;
                                                        end else begin
                                                                addra <=96+(e_diff<<4)+fractionBits1-fractionBits2+8;
                                                        end
                                                end 
                                        end else if (max_m_bit == 4) begin
                                                if (sign==0) begin //
                                                        if(fractionBits2>=fractionBits1) begin
                                                                addra <= (e_diff<<5)+fractionBits2-fractionBits1;
                                                        end else begin
                                                                addra <= (e_diff<<5)+fractionBits1-fractionBits2+width-8;
                                                        end 
                                                end else begin //
                                                        if(fractionBits2>=fractionBits1) begin
                                                                addra <= 224+(e_diff<<5)+fractionBits2-fractionBits1;
                                                        end else begin
                                                                addra <= 224+(e_diff<<5)+fractionBits1-fractionBits2+width-8;
                                                        end
                                                end
                                        end else if (max_m_bit == 5) begin
                                                if (sign==0) begin // 
                                                        if(fractionBits2>=fractionBits1) begin
                                                                addra <= (e_diff<<6)+fractionBits2-fractionBits1;
                                                        end else begin
                                                                addra <= (e_diff<<6)+fractionBits1-fractionBits2+32;   
                                                        end 
                                                end else begin //
                                                        if(fractionBits2>=fractionBits1) begin
                                                                addra <= 512+(e_diff<<6)+fractionBits2-fractionBits1;
                                                        end else begin
                                                                addra <= 512+(e_diff<<6)+fractionBits1-fractionBits2+32;
                                                end
                                                end
                                        end else if (max_m_bit == 6) begin
                                                if (sign==0) begin //
                                                        if(fractionBits2>=fractionBits1) begin
                                                                addra <= (e_diff<<7)+fractionBits2-fractionBits1;
                                                        end else begin
                                                                addra <= (e_diff<<7)+fractionBits1-fractionBits2+64;
                                                        end 
                                                end else begin // 
                                                        if(fractionBits2>=fractionBits1) begin
                                                                addra <= 1152+(e_diff<<7)+fractionBits2-fractionBits1;
                                                        end  else begin
                                                                addra <= 1152+(e_diff<<7)+fractionBits1-fractionBits2+64;
                                                        end
                                                end
                                        end 
                                end
                                stage2_done <= 1;
                        end else if (stage1_done == 1&&stage2_done == 1) begin
                                if (2+max_m_bit > e_diff||2+max_m_bit == e_diff) begin
                                        if(sign==0) begin // 加法结果
                                        result_exp <= exponentBits1 + (result_bin_reg[max_m_bit+:6]);
                                        result_man <= result_bin_reg-(result_bin_reg[max_m_bit+:6]<<max_m_bit);
                                        end else begin // 减法结果
                                        result_exp <= exponentBits1+(result_bin_reg[max_m_bit+:6])-e_bias;
                                        result_man <= result_bin_reg-(result_bin_reg[max_m_bit+:6]<<max_m_bit);
                                        end
                                        stage1_done <= 0;
                                        stage2_done <= 0;
                                        cal_over <=1;
                                end else begin
                                        result_exp<=exponentBits1;
                                        result_man<=fractionBits1;
                                        stage1_done <= 0;
                                        stage2_done <= 0;
                                        cal_over <=1;
                                end  
                        end
                end else begin
                        cal_over <= 0;
                        stage1_done <= 0;
                        stage2_done <= 0;
                end
        end
end

endmodule


