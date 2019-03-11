 /******************************************************************* 
* Name:
*	UART.v
* Description:
* 	This module implements an UART TX module
* Parameters:

*	 Nbit :	Number of bits to transmit
*	 baudrate: baudrate to use 
*	 clk_freq : system clock frequency

* Inputs:
*
*	SerialDataIn: it's the input data port 
*	clk :  clk signal
*	reset :  async signal to reset 	
*	clr_rx_flag: signal to clear the Rx signal
*	Transmit :  signal to indicate the start of transmission 
*	[Nbit-1:0] DataTx: Port where Tx data is placed  
* 
* Outputs:
*	[Nbit-1:0] DataRx: Port where Rx information is available
*	Rx_flag: indicates a data was received 
*	Parity_error: when received logic data contains parity errors. Just for pair parity
*	SerialDataOut: Output for serial data 

* Versión:  
*	1.0
* Author: 
*	Nestor Damian Garcia Hernandez
*  	Diego González Ávalos
* Fecha: 
*	23/11/2017
*********************************************************************/


module UART
#(
	parameter Nbit =8,		//Number of bits to transmit
	parameter baudrate= 9600,	//baudrate to use 
	parameter clk_freq =50000000		//system clock frequency	
)
(	
	//inputs
	input SerialDataIn, //it's the input data port 
	input clk, //clk signal
	input reset, //async signal to reset 	
	input clr_rx_flag, //to clear the Rx signal
	input Transmit, //signal to indicate the start of transmission . (Ready)
	input [Nbit-1:0] DataTx, //Port where Tx data is placed  (tx_data)
	//outputs
	
	//RX
	output [Nbit-1:0] DataRx, //Port where Rx information is available
	output Rx_flag , //indicates a data was received 
	output Parity_error, //when received logic data contains parity errors. Just for pair parity
	//TX
	output SerialDataOut  //Output for serial data  (TxD )	
);

// TX instance 
UART_TX
#(
	.Nbit(Nbit),
	.baudrate(baudrate),
	.clk_freq(clk_freq)
)
UART_TXmodule
(
	.clk(clk),
	.reset(reset),
	.Transmit(Transmit),
	.DataTx(DataTx),
	.SerialDataOut(SerialDataOut)
);

UART_RX
#(
	.Nbit(Nbit),
	.baudrate(baudrate),
	.clk_freq(clk_freq)
)
UART_RXmodule
(
	.SerialDataIn(SerialDataIn), //it's the input data port 
	.clk(clk), //clk signal
	.reset(reset), //async signal to reset 
	.clr_rx_flag(clr_rx_flag), //to clear the Rx signal
	.DataRx(DataRx),
	.Rx_flag(Rx_flag),
	.Parity_error(Parity_error)
);

/*Log Function*/
function integer CeilLog2;
	 input integer data;
	 integer i,result;
	 begin
		 for(i=0; 2**i < data; i=i+1)  
			 result = i + 1;
		 CeilLog2 = result; //se debe usar el nombre de la funcion, que será la salida
	 end
endfunction

endmodule