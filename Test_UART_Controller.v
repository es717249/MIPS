module Test_UART_Controller;

localparam DATA_WIDTH = 32;
localparam ADDR_WIDTH = 8;
localparam MAXIMUM_VALUE = 4'd6;
localparam Nbit =8;

localparam clk_freq =50;
localparam baudrate= 5;

reg clk=0; 				        /* clk signal */
reg reset=0; 			        /* async signal to reset */
reg enable=0;                   /* enable signal for start of operation */

reg SerialDataIn; //it's the input data port 
reg clr_rx_flag; //to clear the Rx signal
reg [DATA_WIDTH-1:0]uart_tx;
reg Start_Tx;

wire [Nbit-1:0] DataRx; //Port where Rx information is available
wire Rx_flag; //indicates a data was received
wire SerialDataOut;


UART_controller #(
    .DATA_WIDTH(32),
    .UART_Nbit(8),    
    .baudrate(5),	
	.clk_freq(50)
)
uartctrl
(
    .SerialDataIn(SerialDataIn), //it's the input data port 
    .clk(clk), 					/* clk signal */
    .reset(reset), 				/* async signal to reset */	
    .clr_rx_flag(clr_rx_flag),
    .uart_tx(uart_tx),
    .Start_Tx(Start_Tx),
    /* outputs */
    .UART_data(DataRx),
    .SerialDataOut(SerialDataOut),    
    .Rx_flag_out(Rx_flag)
);


initial begin
 	//forever #10 clk=!clk;
    forever #(clk_freq/2) clk=!clk;
end

initial begin 
    /* Beginning of simulation */
    #0  reset=1'b0;
    #0  enable =1'b0;
    SerialDataIn=1;
	#(clk_freq/2) clr_rx_flag = 1;
    #50 reset =1'b1;
    #0  enable =1'b1;

    /* Send start bit */
	#(500) SerialDataIn = 1'b0;
	/* Send 8 data bits */
	/* Send less significant bit first */
	#(500) SerialDataIn = 1'b1;
	#(500) SerialDataIn = 1'b0;
   	#(500) SerialDataIn = 1'b0;
	#(500) SerialDataIn = 1'b1;
	#(500) SerialDataIn = 1'b1;
	#(500) SerialDataIn = 1'b1;
	#(500) SerialDataIn = 1'b0;
	#(500) SerialDataIn = 1'b0;
    /* Send stop bit */ 
    #(500) SerialDataIn = 1'b1;    
    #100 clr_rx_flag=0
    #100
end 

    

endmodule