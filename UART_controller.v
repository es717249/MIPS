module UART_controller #(
    parameter DATA_WIDTH=32,
    parameter UART_Nbit=8,
    /* parameter baudrate=9600,
    parameter clk_freq=50000000 */
    parameter baudrate= 5,	
	parameter clk_freq =50,

    /* States UART TX */
    parameter IDLE      =   0,
    parameter READ_AND_SEND=1,
    parameter SHIFT     =   2

)
(
    input SerialDataIn, //it's the input data port 
    input clk, 					/* clk signal */
    input reset, 				/* async signal to reset */	
    input clr_rx_flag,
    input [DATA_WIDTH-1:0]uart_tx,
    input Start_Tx,
    /* outputs */
    output [DATA_WIDTH-1:0] UART_data,
    output SerialDataOut,
    /* output Selector_control, */
    output [DATA_WIDTH-1:0] Rx_flag_out
);

reg [2:0] state_tx/*sythesis keep*/;
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
    .Data_in_Rx(DataRx_tmp),
    .Data_out_Rx(DataRx),
    .Data_in_Tx(Data_to_Tx_tmp_wire),
    .Data_out_Tx(Data_to_Tx)
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
	.clk(clk),              //clk signal
	.reset(reset),          //async signal to reset 
	.Transmit( Send_byte_indicator),            //signal to indicate the start of transmission . (Ready)
	.DataTx(Data_to_Tx),              //Port where Tx data is placed  (tx_data)
    .clr_tx_flag(clr_tx_flag),
	/* Outputs	 */
	.SerialDataOut( SerialDataOut),  //Output for serial data  (TxD ),  //Output for serial data  (TxD )	
    .endTx_flag(endTx_flag)
);

wire endTx_flag;
wire Send_byte_indicator;
wire clr_tx_flag;
wire [UART_Nbit-1:0] Data_to_Tx_tmp_wire;
wire [UART_Nbit-1:0] Data_to_Tx;

reg [1:0] byte_number;
reg [DATA_WIDTH-1:0]uart_tx_copy;
reg [UART_Nbit-1:0] Data_to_Tx_tmp_reg;
reg Send_byte_indicator_reg;
reg cleanTx_flag_reg;

assign Data_to_Tx_tmp_wire =  Data_to_Tx_tmp_reg;
assign Send_byte_indicator = Send_byte_indicator_reg;
assign clr_tx_flag = cleanTx_flag_reg;


always @(posedge clk or negedge reset)begin
    if(reset==1'b0)begin
        state <= IDLE;
        byte_number <=2'b0;
        Send_byte_indicator_reg<=0;
    end else begin
        case(state)
            IDLE:
            begin
                if(Start_Tx ==1'b1)begin
                    uart_tx_copy <=uart_tx;
                    state <= READ_AND_SEND;
                    Send_byte_indicator_reg<=0;
                end else begin
                    Send_byte_indicator_reg<=0;
                    state <= IDLE;
                end
            end
            READ_AND_SEND:
            begin
                if(byte_number <4)begin
                    byte_number <=byte_number+2'b1;
                    /* Send the data to the UART Tx unit */
                    Data_to_Tx_tmp_reg <= uart_tx_copy[7:0] ;
                    Send_byte_indicator_reg<=1;

                    if(cleanTx_flag_reg==1'b1)begin
                        state <=SHIFT;    
                    end else begin
                        state <=READ_AND_SEND; 
                    end
                end else begin
                    byte_number <= 2'b0;
                    Send_byte_indicator_reg<=0;
                    state <= IDLE;
                end
            end
            SHIFT:
            begin
                uart_tx_copy[23:0] <= uart_tx_copy[31:8];
                cleanTx_flag_reg <=1'b0;      /* Clean the flag */
                start <=READ_AND_SEND;
            end
            default:
                state <= IDLE;
        endcase
    end 
end


endmodule 