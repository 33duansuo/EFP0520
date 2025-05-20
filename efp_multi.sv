`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/width-2 11:45:45
// Design Name: 
// Module Name: efp_multi
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


module efp_multi
#(
    parameter width = 16
)
(
    input clk,
    input [width-1:0] efp8Binary1,
    input [width-1:0] efp8Binary2,
    input [4:0] m_bit1,  
    input [4:0] m_bit2, 
    output reg [width-1:0] res_efp
    );

localparam Bias = 31; 
// **********************程序说明***********************//
//一个时钟周期内完成
wire [width-8:0]mantissa1;
wire [width-8:0]mantissa2;
wire [4:0]max_m_bit;
assign mantissa1 = (m_bit1>m_bit2) ? (efp8Binary1[width-8:0]):(efp8Binary1[width-8:0]<<(m_bit2-m_bit1));
assign mantissa2 = (m_bit2>m_bit1) ? (efp8Binary2[width-8:0]):(efp8Binary2[width-8:0]<<(m_bit1-m_bit2));
assign max_m_bit = (m_bit1>m_bit2) ? m_bit1:m_bit2;

always @(posedge clk) begin
    if(efp8Binary1 == 0 || efp8Binary2 == 0) begin
        res_efp <= 0;
    end else begin
        if(mantissa1 + mantissa2<(1<<max_m_bit)) begin
            res_efp[width-1]  <= efp8Binary1[width-1] ^ efp8Binary2[width-1];
            res_efp[width-2:width-7] <= efp8Binary1[width-2:width-7] + efp8Binary2[width-2:width-7] - Bias;
            res_efp[width-8:0] <= mantissa1 + mantissa2;
        end else begin
            res_efp[width-1]  <= efp8Binary1[width-1] ^ efp8Binary2[width-1];
            res_efp[width-2:width-7] <= efp8Binary1[width-2:width-7] + efp8Binary2[width-2:width-7] - Bias+1;
            res_efp[width-8:0] <= mantissa1 + mantissa2-(1<<max_m_bit);
        end
    end
end



endmodule
