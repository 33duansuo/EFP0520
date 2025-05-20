////////////
//                                                                              //
//                                                                              //
//  Author: lhj                                                               //
//                                                                             //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.cn/                                                //
//     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//2018/1/3                    1.0          Original
//*******************************************************************************/

module uart_test(
input                           sys_clk_p,      // Differentia system clock 200Mhz input on board
input                           sys_clk_n,
input                           rst_n    ,//复位，按下变成低电平复位
input                           uart_rx  ,//串口接收
output                          fan      ,
output                          uart_tx   //串口发�??
);

parameter                      CLK_FRE = 200;//Mhz
localparam                       IDLE =  0;
localparam                       SEND =  1;   //send HELLO ALINX\r\n
localparam                       WAIT =  2;   //wait 1 second and send uart received data
reg[7:0]                         tx_data;//发�?�数�????
reg[7:0]                         tx_str;//字符
reg                              tx_data_valid;//数据发�?�有�????
wire                             tx_data_ready;//数据准备发�??
reg[7:0]                         tx_cnt;//发�?�bit计数
wire[7:0]                        rx_data;//接收数据
wire                             rx_data_valid;//接收数据有效
wire                             rx_data_ready;//准备接收数据
//reg[31:0]                        wait_cnt;//等待时间计数�????
reg[3:0]                         state;//状�??


reg [31:0] A[7:0][7:0];
reg [31:0] B[7:0][7:0];
reg [4:0] m_bit1;
reg [4:0] m_bit2;
reg flag;
reg mat_add;
reg mat_mul;
reg [31:0] C[7:0][7:0];
reg [31:0] C1[7:0][7:0];
reg [7:0] data_cnt;//my
//===========================================================================
//Differentia system clock to single end clock
//===========================================================================
wire        sys_clk;
assign   	fan = 1'd1;    // fan off
 IBUFGDS u_ibufg_sys_clk
   (
    .I  (sys_clk_p),            
    .IB (sys_clk_n),          //系统时钟
    .O  (sys_clk  )        
    );  
assign rx_data_ready = 1'b1;//always can receive data,
							//if HELLO ALINX\r\n is being sent, the received data is discarded
 
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		//wait_cnt <= 16'd0;
		tx_data <= 8'd0;
		state <= IDLE;
		tx_cnt <= 8'd0;
		tx_data_valid <= 1'b0;
		flag <= 0;
		flag <= 0;
	end
	else
	case(state)
		IDLE:
		begin
			state <= WAIT;
		end	
		SEND:
		begin
			//wait_cnt <= 16'd0;
			tx_data <= tx_str;//串行数据"HELLO ALINX\r\n"
			if(tx_data_valid == 1'b1 && tx_data_ready == 1'b1 && tx_cnt < 8'd31)//Send 512 bytes data
			begin
				tx_cnt <= tx_cnt + 8'd1; //Send data counter
			end
			else if(tx_data_valid && tx_data_ready)//last byte sent is complete
			begin
				tx_cnt <= 8'd0;
				tx_data_valid <= 1'b0;
				state <= WAIT;
				flag <= 0;
			end
			else if(~tx_data_valid)
			begin
				tx_data_valid <= 1'b1;
			end
		end
		WAIT:
		begin
			//wait_cnt <= wait_cnt + 16'd1;
			if(rx_data_valid == 1'b1)
			begin
				 case(data_cnt)
					0: begin A[0][0][31:24] <= rx_data; data_cnt <= data_cnt + 1; end
					1: begin A[0][0][23:16] <= rx_data; data_cnt <= data_cnt + 1; end
					2: begin A[0][0][15:8] <= rx_data; data_cnt <= data_cnt + 1; end
					3: begin A[0][0][7:0] <= rx_data; data_cnt <= data_cnt + 1; end
					4: begin A[0][1][31:24] <= rx_data; data_cnt <= data_cnt + 1; end
					5: begin A[0][1][23:16] <= rx_data; data_cnt <= data_cnt + 1; end
					6: begin A[0][1][15:8] <= rx_data; data_cnt <= data_cnt + 1; end
					7: begin A[0][1][7:0] <= rx_data; data_cnt <= data_cnt + 1; end
					8: begin A[1][0][31:24] <= rx_data; data_cnt <= data_cnt + 1; end
					9: begin A[1][0][23:16] <= rx_data; data_cnt <= data_cnt + 1; end
					10: begin A[1][0][15:8] <= rx_data; data_cnt <= data_cnt + 1; end
					11: begin A[1][0][7:0] <= rx_data; data_cnt <= data_cnt + 1; end
					12: begin A[1][1][31:24] <= rx_data; data_cnt <= data_cnt + 1; end
					13: begin A[1][1][23:16] <= rx_data; data_cnt <= data_cnt + 1; end
					14: begin A[1][1][15:8] <= rx_data; data_cnt <= data_cnt + 1; end
					15: begin A[1][1][7:0] <= rx_data; data_cnt <= data_cnt + 1; end
					16: begin B[0][0][31:24] <= rx_data; data_cnt <= data_cnt + 1; end
					17: begin B[0][0][23:16] <= rx_data; data_cnt <= data_cnt + 1; end
					18: begin B[0][0][15:8] <= rx_data; data_cnt <= data_cnt + 1; end
					19: begin B[0][0][7:0] <= rx_data; data_cnt <= data_cnt + 1; end
					20: begin B[0][1][31:24] <= rx_data; data_cnt <= data_cnt + 1; end
					21: begin B[0][1][23:16] <= rx_data; data_cnt <= data_cnt + 1; end
					22: begin B[0][1][15:8] <= rx_data; data_cnt <= data_cnt + 1; end
					23: begin B[0][1][7:0] <= rx_data; data_cnt <= data_cnt + 1; end
					24: begin B[1][0][31:24] <= rx_data; data_cnt <= data_cnt + 1; end
					25: begin B[1][0][23:16] <= rx_data; data_cnt <= data_cnt + 1; end
					26: begin B[1][0][15:8] <= rx_data; data_cnt <= data_cnt + 1; end
					27: begin B[1][0][7:0] <= rx_data; data_cnt <= data_cnt + 1; end
					28: begin B[1][1][31:24] <= rx_data; data_cnt <= data_cnt + 1; end	
					29: begin B[1][1][23:16] <= rx_data; data_cnt <= data_cnt + 1; end
					30: begin B[1][1][15:8] <= rx_data; data_cnt <= data_cnt + 1; end
					31: begin
						B[1][1][7:0] <= rx_data;
						state <= SEND;
						flag <= 1;
						m_bit1 <= 6;
						m_bit2 <= 6;
						data_cnt <= 0;
            		end
					default: begin
					end
					endcase
			end else if(tx_data_valid && tx_data_ready)
			begin
				tx_data_valid <= 1'b0;
			end
			// if(flag == 1 && datatx_cnt > 6) 
			// begin
			// 	state <= SEND;
			// 	datatx_cnt <= 0;
			// end else if(flag == 1)
			// begin
			// 	datatx_cnt <= datatx_cnt + 1;
			// end
			//else if(wait_cnt >= CLK_FRE * 1000000) // wait for 1 second
				//state <= SEND;
		end
		default:
			state <= IDLE;
	endcase
end

//combinational logic
//Send "HELLO ALINX\r\n"
always@(*)
begin
		case(tx_cnt)
		8'd0 :  tx_str <= C[0][0][31:24];
		8'd1 :  tx_str <= C[0][0][23:16];
		8'd2 :  tx_str <= C[0][0][15:8];
		8'd3 :  tx_str <= C[0][0][7:0];
		8'd4 :  tx_str <= C[0][1][31:24];
		8'd5 :  tx_str <= C[0][1][23:16];
		8'd6 :  tx_str <= C[0][1][15:8];
		8'd7 :  tx_str <= C[0][1][7:0];
		8'd8 :  tx_str <= C[1][0][31:24];
		8'd9 :  tx_str <= C[1][0][23:16];
		8'd10 :  tx_str <= C[1][0][15:8];
		8'd11 :  tx_str <= C[1][0][7:0];
		8'd12 :  tx_str <= C[1][1][31:24];
		8'd13 :  tx_str <= C[1][1][23:16];
		8'd14 :  tx_str <= C[1][1][15:8];
		8'd15 :  tx_str <= C[1][1][7:0];
		8'd16 :  tx_str <= C1[0][0][31:24];
		8'd17 :  tx_str <= C1[0][0][23:16];
		8'd18 :  tx_str <= C1[0][0][15:8];
		8'd19 :  tx_str <= C1[0][0][7:0];
		8'd20 :  tx_str <= C1[0][1][31:24];
		8'd21 :  tx_str <= C1[0][1][23:16];
		8'd22 :  tx_str <= C1[0][1][15:8];
		8'd23 :  tx_str <= C1[0][1][7:0];
		8'd24 :  tx_str <= C1[1][0][31:24];
		8'd25 :  tx_str <= C1[1][0][23:16];
		8'd26 :  tx_str <= C1[1][0][15:8];
		8'd27 :  tx_str <= C1[1][0][7:0];
		8'd28 :  tx_str <= C1[1][1][31:24];
		8'd29 :  tx_str <= C1[1][1][23:16];
		8'd30 :  tx_str <= C1[1][1][15:8];
		8'd31 :  tx_str <= C1[1][1][7:0];
		default:tx_str <= 8'd0;
	endcase
end
//例化接收和发送模�????
uart_rx#
(
	.CLK_FRE(CLK_FRE),
	.BAUD_RATE(115200)
) uart_rx_inst
(
	.clk                        (sys_clk                  ),
	.rst_n                      (rst_n                    ),
	.rx_data_ready              (rx_data_ready            ),
	.rx_pin                     (uart_rx                  ),
	.rx_data                    (rx_data                  ),
	.rx_data_valid              (rx_data_valid            )
);

uart_tx#
(
	.CLK_FRE(CLK_FRE),
	.BAUD_RATE(115200)
) uart_tx_inst
(
	.clk                        (sys_clk                  ),
	.rst_n                      (rst_n                    ),
	.tx_data                    (tx_data                  ),
	.tx_data_valid              (tx_data_valid            ),
	.tx_data_ready              (tx_data_ready            ),
	.tx_pin                     (uart_tx                  )
);

		
matrix_add8 #(
	.width(16)
) matrix_add_top
(
    .clk(sys_clk ),
    .A(A),
    .B(B),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .flag(flag),
    .C(C)
);  

matrix_multi8#(
	.width(16)
) matrix_multi_top
(
    .clk(sys_clk ),
    .A(A),
    .B(B),
    .m_bit1(m_bit1),
    .m_bit2(m_bit2),
    .flag(flag),
    .C(C1)
);
endmodule