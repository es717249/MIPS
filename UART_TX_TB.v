module UART_TX_TB;
	
	parameter Nbit =8;
	parameter baudrate= 5;	
	parameter clk_freq =50;

	reg SerialDataIn; //it's the input data port 
	reg clk=0; //clk signal
	reg reset; //async signal to reset 
	reg Transmit; //signal to indicate the start of transmission . (Ready)
	reg [Nbit-1:0] DataTx; //Port where Tx data is placed  (tx_data)
	reg clr_tx_flag;
	//outputs
	
	wire SerialDataOut;  //Output for serial data  (TxD )
	wire endTx_flag;

UART_TX
#(
	.Nbit(Nbit),
	.baudrate(baudrate),
	.clk_freq(clk_freq)
)
DUV_UART_TX
(	
	.clk(clk), //clk signal
	.reset(reset), //async signal to reset 
	.Transmit(Transmit), //signal to indicate the start of transmission . (Ready)
	.DataTx(DataTx), //Port where Tx data is placed  (tx_data)
	.clr_tx_flag(clr_tx_flag),
	//outputs	
	.SerialDataOut(SerialDataOut),  //Output for serial data  (TxD ),  //Output for serial data  (TxD )
	.endTx_flag(endTx_flag)
	
	
);

initial begin
    forever #(clk_freq/2) clk=!clk;
end

initial begin
	#0 reset =0;
	Transmit =0;
	#50 reset =1;
	DataTx = 8'b01010101;
	#50 Transmit=1;
	#510 Transmit=0;
end
endmodule