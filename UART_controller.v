module UART_controller #(
    parameter DATA_WIDTH=32,
    parameter UART_Nbit=8,
    /* parameter baudrate=9600,
    parameter clk_freq=50000000 */
    parameter baudrate= 5,	
	parameter clk_freq =50
)
(
    input SerialDataIn, //it's the input data port 
    input clk, 					/* clk signal */
    input reset, 				/* async signal to reset */	
    input clr_rx_flag,
    input [DATA_WIDTH-1:0]uart_tx,
    /* outputs */
    output [DATA_WIDTH-1:0] UART_data,
    /* output Selector_control, */
    output [DATA_WIDTH-1:0] Rx_flag_out
);

wire Rx_flag;
wire [UART_Nbit-1:0] DataRx_tmp/*synthesis keep*/;
wire [UART_Nbit-1:0] DataRx;

assign Rx_flag_out = { {31{1'b0}} , Rx_flag};
assign UART_data = { {24{1'b0}} ,DataRx};


//####################     UART RX                #######################
UART_RX #(
	.Nbit(UART_Nbit),
	.baudrate(baudrate)	
)
DUV_RX
(
	.SerialDataIn(SerialDataIn), //it's the input data port 
	.clk(clk), //clk signal
	.reset(reset), //async signal to reset 
	.clr_rx_flag(clr_rx_flag), //to clear the Rx signal. 0=clear the Rx flag, 1=awaiting for clear operation
	//outputs	
	.DataRx(DataRx_tmp), //Port where Rx information is available
	.Rx_flag(Rx_flag) //indicates a data was received
);


//####################     ASCII translator unit   #######################
ASCI_translator #(
    .Nbits(UART_Nbit)
)ASCII_Trans
(
    .Data_in(DataRx_tmp),
    .Data_out(DataRx)
);



endmodule 