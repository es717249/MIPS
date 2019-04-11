module UART_RX_TB;
	
	parameter Nbit =8;
	parameter baudrate= 5;
	parameter clk_freq =50;
	/* 50/5 = 10 clk per bit */

	//inputs
	reg SerialDataIn; //it's the input data port 
	reg clk=0; //clk signal
	reg reset; //async signal to reset 
	reg clr_rx_flag; //to clear the Rx signal
	
	//outputs
	wire [Nbit-1:0] DataRx; //Port where Rx information is available
	wire Rx_flag; //indicates a data was received 
	//wire Parity_error; //when received logic data contains parity errors. Just for pair parity

UART_RX#(
	.Nbit(Nbit),
	.baudrate(baudrate),
	.clk_freq(clk_freq)
)
DUV_RX
(
	.SerialDataIn(SerialDataIn), //it's the input data port 
	.clk(clk), //clk signal
	.reset(reset), //async signal to reset 
	.clr_rx_flag(clr_rx_flag), //to clear the Rx signal

	//outputs	
	.DataRx(DataRx), //Port where Rx information is available
	.Rx_flag(Rx_flag) //indicates a data was received
	//.Parity_error(Parity_error)
);

initial begin
   #10 clk =!clk;
end
initial begin
	forever #(clk_freq/2) clk =!clk;
end

initial begin
	#0 reset =0;
	SerialDataIn=1;
	#(clk_freq/2) clr_rx_flag = 1;
	#10 reset = 1;
	/* Send start bit */
	#(500) SerialDataIn = 1'b0;
	/* Send 8 data bits */
	/* Send less significant bit first */
	#(500) SerialDataIn = 1'b1;
	#(500) SerialDataIn = 1'b0;
   	#(500) SerialDataIn = 1'b1;
	#(500) SerialDataIn = 1'b0;
	#(500) SerialDataIn = 1'b1;
	#(500) SerialDataIn = 1'b0;
	#(500) SerialDataIn = 1'b1;
	#(500) SerialDataIn = 1'b0;
	/* Send stop bit */
	#(500) SerialDataIn = 1'b1;

	#(500)
	//#(clk_freq/2) clr_rx_flag = 0;
	//#100
	/* Send second burst of information */
	/* Send start bit */
	#(500) SerialDataIn = 1'b0;
	/* Send 8 data bits */
	/* Send less significant bit first */
	#(500) SerialDataIn = 1'b0;
	#(500) SerialDataIn = 1'b0;
	clr_rx_flag =0;
	#15 clr_rx_flag =1;
   	#(500) SerialDataIn = 1'b0;
	#(500) SerialDataIn = 1'b1;
	#(500) SerialDataIn = 1'b0;
	#(500) SerialDataIn = 1'b0;
	#(500) SerialDataIn = 1'b0;
	#(500) SerialDataIn = 1'b0;
	/* Send stop bit */
	#(500) SerialDataIn = 1'b1;
end
endmodule