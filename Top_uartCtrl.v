module Top_uartCtrl#(
    parameter DATA_WIDTH=32,
    parameter UART_Nbit=8,
    parameter baudrate=9600,
    parameter clk_freq=50000000
)(
    input SerialDataIn, //it's the input data port 
    input clk, 					/* clk signal : R20 50Mhz*/
    input reset, 				/* async signal to reset : Sw9*/	
    input clr_rx_flag,				/* SW8 */
    input clr_tx_flag,          /* Clear the 32bit Tx sent indicator : SW7*/    
    input Start_Tx,					//Sw0 
    input [3:0] data_inTx,			//From SW1 to SW4
    /* outputs */
    output [UART_Nbit-1:0] DataRx,	//green led
    output SerialDataOut,				//Tx pin
    /* output Selector_control, */
    output Rx_flag_out,					//
    output Tx_flag_out					//
);

wire [31:0]completeTx_data;
assign completeTx_data = {  { 28{1'b0}} ,data_inTx}; 
 


UART_controller #(
    .DATA_WIDTH(DATA_WIDTH),
    .UART_Nbit(UART_Nbit),
    .baudrate(baudrate),
    .clk_freq(clk_freq)
)uart_ctrlUnit
(
    .SerialDataIn(SerialDataIn), //it's the input data port 
    .clk(clk), 					/* clk signal */
    .reset(reset), 				/* async signal to reset */	
    .clr_rx_flag(clr_rx_flag),
    .clr_tx_flag(clr_tx_flag),
    .uart_tx(completeTx_data),        /* Data to transmit */
    .Start_Tx( Start_Tx  ),            /* Input */
    .enable_StoreTxbuff(  1   ),
    /* outputs */
    .UART_data(DataRx),
    .SerialDataOut(SerialDataOut),
    .Rx_flag_out(Rx_flag_out),
    .Tx_flag_out(Tx_flag_out)
);


endmodule