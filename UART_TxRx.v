module UART_tx_rx
#(
	parameter Nbit =8,
	parameter baudrate= 9600,	
	parameter clk_freq =50000000	
)
(
    
    /* Common signals */
    input clk, //clk signal
	input reset, //async signal to reset 
	/* RX input signals */
	input SerialDataIn, //it's the input data port 
	input clr_rx_flag, //to clear the Rx signal

    /* TX input signals */
	input Transmit, //signal to indicate the start of transmission . (Ready)
	input [Nbit-1:0] DataTx, //Port where Tx data is placed  (tx_data)
	
    /* RX outputs */	
	output [Nbit-1:0] DataRx, //Port where Rx information is available
	output reg Rx_flag, //indicates a data was received 
    output reg Parity_error, //when received logic data contains parity errors. Just for pair parity
    /* TX outputs */
	output reg SerialDataOut  //Output for serial data  (TxD )	
);

/* UART TX addr: 0x10010028 */
UART_TX#(
	.Nbit(Nbit),
	.baudrate(baudrate),
	.clk_freq(clk_freq)
)
DUV_UART_TX
(	
    /* Inputs */
	.clk(clk), //clk signal
	.reset(reset), //async signal to reset 
	.Transmit(Transmit), //signal to indicate the start of transmission . (Ready)
	.DataTx(DataTx), //Port where Tx data is placed  (tx_data)
	/* Outputs	 */
	.SerialDataOut(SerialDataOut)  //Output for serial data  (TxD ),  //Output for serial data  (TxD )	
);

/* UART RX addr: 0x1001002C */
UART_RX#(
	.Nbit(Nbit),
	.baudrate(baudrate),
	.clk_freq(clk_freq)
)
DUV_RX
(
    /* Inputs */
	.SerialDataIn(SerialDataIn), //it's the input data port 
	.clk(clk), //clk signal
	.reset(reset), //async signal to reset 
	.clr_rx_flag(clr_rx_flag), //to clear the Rx signal

	/* Outputs	 */
	.DataRx(DataRx), //Port where Rx information is available
	.Rx_flag(Rx_flag), //indicates a data was received
	.Parity_error(Parity_error)
);

endmodule