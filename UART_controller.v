module UART_controller #(
    parameter DATA_WIDTH=32,
    parameter UART_Nbit=8,
    /* parameter baudrate=9600,
    parameter clk_freq=50000000, */
    parameter baudrate= 5,	
	parameter clk_freq =50,

    /* States UART TX */
    parameter IDLE          =0,
    parameter START_AND_READ =1,    
    parameter SHIFT         =2,
    parameter UPDATE_DATA =3,
    parameter STOP =4

)
(
    input SerialDataIn, //it's the input data port 
    input clk, 					/* clk signal */
    input reset, 				/* async signal to reset */	
    input clr_rx_flag,
    input clr_tx_flag,          /* Clear the 32bit Tx sent indicator */
    input [DATA_WIDTH-1:0]uart_tx,
    input Start_Tx,
    input enable_StoreTxbuff,
    /* outputs */
    output [DATA_WIDTH-1:0] UART_data,
    output SerialDataOut,
    /* output Selector_control, */
    output [DATA_WIDTH-1:0] Rx_flag_out,
    output reg [DATA_WIDTH-1:0] Tx_flag_out

);

//####################     UART RX signals        #######################
reg [2:0] state_tx/*sythesis keep*/;
wire Rx_flag/*synthesis keep*/;
wire [UART_Nbit-1:0] DataRx_tmp/*synthesis keep*/;
wire [UART_Nbit-1:0] DataRx/*synthesis keep*/;

//####################     UART TX signals        #######################
wire endTx_flag/*synthesis keep*/;
wire Send_byte_indicator/*synthesis keep*/;
wire clr_tx_8bit_flag/*synthesis keep*/;
wire [UART_Nbit-1:0] Data_to_Tx_tmp_wire/*synthesis keep*/;
wire [UART_Nbit-1:0] Data_to_Tx/*synthesis keep*/;

reg [3:0] byte_number;
reg [DATA_WIDTH-1:0]uart_tx_copy;
reg [UART_Nbit-1:0] Data_to_Tx_tmp_reg;
reg Send_byte_indicator_reg;
reg cleanTx_flag_reg;

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

//####################     UART TX                #######################

/* UART TX addr: 0x10010028 */
UART_TX#(
	.Nbit(UART_Nbit),
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
    //.DataTx(Data_to_Tx_tmp_wire),              //Port where Tx data is placed  (tx_data)
    .clr_tx_flag(clr_tx_8bit_flag),
	/* Outputs	 */
	.SerialDataOut( SerialDataOut),  //Output for serial data  (TxD ),  //Output for serial data  (TxD )	
    .endTx_flag(endTx_flag)
);

//####################    Assigments  Rx #######################

assign Rx_flag_out = { {31{1'b0}} , Rx_flag};
assign UART_data = { {24{1'b0}} ,DataRx};

//####################    Assigments  Tx #######################
assign Data_to_Tx_tmp_wire =  Data_to_Tx_tmp_reg;
assign Send_byte_indicator = Send_byte_indicator_reg;
assign clr_tx_8bit_flag = cleanTx_flag_reg;


//####################    Machine state for UART Tx ############



always @(posedge clk or negedge reset)begin
    if(reset==1'b0)begin
        state_tx <= IDLE;
        byte_number <=0;
        Send_byte_indicator_reg<=0;
        cleanTx_flag_reg<=1;    /* Clean End byte flag */
        Tx_flag_out<=0;
    end else begin
        if(clr_tx_flag==1'b0)begin
            Tx_flag_out <=0;
        end else begin 
            case(state_tx)
                IDLE:
                begin

                    /* if(Start_Tx ==1'b1)begin */
                    if(Start_Tx ==1'b1 && Tx_flag_out ==0)begin
                    
                        /* uart_tx_copy <=uart_tx; */
                        Send_byte_indicator_reg<=1;
                        state_tx <= START_AND_READ;                    
                        
                        /* Data_to_Tx_tmp_reg <= { {4{1'b0}} ,uart_tx_copy[3:0] }; */
                        Data_to_Tx_tmp_reg <= { {4{1'b0}} ,uart_tx_copy[31:28] };
                        cleanTx_flag_reg<=1;    /* Clean End byte flag */
                        
                    end else begin
                        if(enable_StoreTxbuff==1)begin
                            uart_tx_copy <=uart_tx;
                        end 
                        state_tx <= IDLE;
                    end
                end
                START_AND_READ:
                begin
                    
                    /* if(byte_number <=3)begin */
                    if(byte_number <=7)begin
                        
                        /* Send the data to the UART Tx unit */
                        
                        if(endTx_flag==1'b1)begin
                            byte_number <=byte_number+3'b1;
                            cleanTx_flag_reg<=0;    /* Clean End byte flag */
                            /* shift data */                            
                            /* uart_tx_copy[27:0] <= uart_tx_copy[31:4]; */
                            uart_tx_copy[31:4] <= uart_tx_copy[27:0];

                            Send_byte_indicator_reg<=0;
                            state_tx <=SHIFT;    
                        end else begin
                            state_tx <=START_AND_READ; 
                        end

                    end else begin
                        byte_number <=byte_number+3'b1;
                        Send_byte_indicator_reg<=0;
                        
                        state_tx <= STOP;
                    end
                end

                SHIFT:
                begin
                    /* wait till data is shifted */
                    

                    if(byte_number <8)begin                        
                        /* Data_to_Tx_tmp_reg <=  { {4{1'b0}} ,uart_tx_copy[3:0] }; */
                        Data_to_Tx_tmp_reg <= { {4{1'b0}} ,uart_tx_copy[31:28] };
                        cleanTx_flag_reg <=1'b1;      
                        Send_byte_indicator_reg<=1;
                        state_tx<=UPDATE_DATA;
                    end else 
                        state_tx<=STOP;

                end
                
                UPDATE_DATA:
                begin
                    
                    /* wait till data is read */
                    state_tx<=START_AND_READ;

                end
                STOP:
                begin         
                        
                    byte_number<=0;
                    Tx_flag_out <=1;        /* Flag to indicate the 4 bytes were transmitted */
                    state_tx <=IDLE;
                end
                default:
                begin
                    Tx_flag_out<=0;         /* Flag to indicate the 4 bytes were transmitted */
                    
                    state_tx <= IDLE;
                end
            endcase
        end
    end 
end


endmodule 