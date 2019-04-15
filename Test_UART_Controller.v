module Test_UART_Controller;

localparam DATA_WIDTH = 32;
localparam ADDR_WIDTH = 8;
localparam MAXIMUM_VALUE = 4'd6;
localparam Nbit =8;

localparam clk_freq =50;
localparam baudrate= 5;

reg clk=0; 				        /* clk signal */
reg reset=0; 			        /* async signal to reset */

reg SerialDataIn; //it's the input data port 
reg clr_rx_flag; //to clear the Rx signal
reg clr_tx_flag;
reg [DATA_WIDTH-1:0]uart_tx;
reg Start_Tx;
reg enable_StoreTxbuff;

wire [DATA_WIDTH-1:0] DataRx; //Port where Rx information is available
wire [DATA_WIDTH-1:0] Rx_flag; //indicates a data was received
wire [DATA_WIDTH-1:0] Tx_flag; //indicates a data was received
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
    .clr_tx_flag(clr_tx_flag),
    .uart_tx(uart_tx),
    .Start_Tx(Start_Tx),
    .enable_StoreTxbuff(enable_StoreTxbuff),
    /* outputs */
    .UART_data(DataRx),
    .SerialDataOut(SerialDataOut),    
    .Rx_flag_out(Rx_flag),
    .Tx_flag_out(Tx_flag)
);


initial begin
 	//forever #10 clk=!clk;
    forever #(clk_freq/2) clk=!clk;
end

initial begin 
    /* Beginning of simulation */
    #0  reset=1'b0;
    SerialDataIn=1;
    Start_Tx=0;
	#(clk_freq/2) clr_rx_flag = 1;
    clr_tx_flag=1;
    uart_tx=0;
    enable_StoreTxbuff=0;
    #50 reset =1'b1;

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
    //#500 clr_rx_flag=0;
    #700;

    /* Write the data in Tx buffer */
    uart_tx = 32'h12345678;
    enable_StoreTxbuff=1;
    #100 Start_Tx=1;
    #100 Start_Tx=0;

    #21466  clr_tx_flag=0;
    #100 clr_tx_flag=1;
    #300 Start_Tx=1;
    

    #100 Start_Tx=0;

end 

    

endmodule