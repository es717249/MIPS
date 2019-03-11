 /******************************************************************* 
* Name:
*	UART_TX.v
* Description:
* 	This module implements an UART TX module
* Parameters:

*	 Nbit :	Number of bits to transmit
*	 baudrate: baudrate to use 
*	 clk_freq : system clock frequency
*	 bit4count : Needed bits for the counter of Nbits to transmit
*	 bit_time : number of clk cycles to count
*	 baud_cnt_bits : number of bits for the baudrate counter 

*	//states for the control machine
*	 IDLE = 0,
*	 START= 1,
*	 DELAY= 2,
*	 SHIFT= 3,
*	 STOP = 4

* Inputs:
*
*	clk :  clk signal
*	reset :  async signal to reset 	
*	Transmit :  signal to indicate the start of transmission 
*	[Nbit-1:0] DataTx: Port where Tx data is placed  
* 
* Outputs:
*	SerialDataOut: Output for serial data 

* Versión:  
*	1.0
* Author: 
*	Nestor Damian Garcia Hernandez
*  Diego González Ávalos
* Fecha: 
*	23/11/2017
*********************************************************************/


module UART_TX
#(
	parameter Nbit =8,		//Number of bits to transmit
	parameter baudrate= 9600,	//baudrate to use 
	parameter clk_freq =50000000,		//system clock frequency
	parameter bit4count= CeilLog2(Nbit), 
	parameter bit_time = clk_freq/baudrate,
	parameter baud_cnt_bits = CeilLog2(bit_time),
	//states
	parameter IDLE = 0,
	parameter START= 1,
	parameter DELAY= 2,
	parameter SHIFT= 3,
	parameter STOP = 4
)
(
	
	input clk, //clk signal
	input reset, //async signal to reset 	
	input Transmit, //signal to indicate the start of transmission . (Ready)
	input [Nbit-1:0] DataTx, //Port where Tx data is placed  (tx_data)
	//outputs
		
	output reg SerialDataOut  //Output for serial data  (TxD )	
);

//Led to show current machine state
reg im_idle /*synthesis keep*/;
reg im_start /*synthesis keep*/;
reg im_delay/*synthesis keep*/;
reg im_shift/*synthesis keep*/;
reg im_stop/*synthesis keep*/;

reg [bit4count:0]bit_number/*synthesis keep*/; //this will help to count N bits to transmit, in this implementation 8 times (8 bits)
reg [2:0] state;
reg [Nbit-1:0]buff_tx/*synthesis keep*/;  //auxiliary buffer to keep data to transmit
reg [baud_cnt_bits-1:0] baud_count/*synthesis keep*/; //counter 

//Process for TX
always @(posedge clk or negedge reset) begin
	
	if (reset==1'b0) begin// reset		
	
		state <= IDLE; //change to IDLE state
		buff_tx <=0; //clear buffer
		baud_count <=0; //restarts the count
		bit_number <=0; //restarts the count
		SerialDataOut<=1; //no sending information
		
	end
	else begin 
		case(state)
			IDLE:
			begin

				im_idle=1'b1;
				im_start=1'b0;
				im_delay=1'b0;
				im_shift=1'b0;
				im_stop=1'b0;

				bit_number <=0;	//restarts the count

				if(Transmit==0)begin
					state<= IDLE;
					buff_tx <= DataTx;	//copy data to transmit
				end else begin
					baud_count<=0;
					state <= START; //start transmission
				end
			end
			START:
			begin
				im_idle=1'b0;
				im_start=1'b1;
				im_delay=1'b0;
				im_shift=1'b0;
				im_stop=1'b0;

				baud_count <=0;
				SerialDataOut<=0; //sending start indication to bus
				state <= DELAY;
			end
			DELAY:
			begin
				im_idle=1'b0;
				im_start=1'b0;
				im_delay=1'b1;
				im_shift=1'b0;
				im_stop=1'b0;

				if(baud_count >= bit_time)begin
					baud_count <=0;
					if(bit_number <= Nbit)begin
						state <= SHIFT;		//go for a new bit
					end else begin

						state <= STOP;	//a bit had been transmitted
					end
				end else begin
					baud_count <= baud_count +1'b1;
					state <=DELAY;	//keep in delay state
				end
			end
			SHIFT:
			begin
				im_idle=1'b0;
				im_start=1'b0;
				im_delay=1'b0;
				im_shift=1'b1;
				im_stop=1'b0;			

				SerialDataOut <= buff_tx[0];
				//buff_tx[Nbit-2:0] <= buff_tx[Nbit-1:1]; //shift data
				buff_tx[6:0] <= buff_tx[7:1]; //shift data
				bit_number <= bit_number +1'b1;
				state <=DELAY;
			end
			STOP:
			begin

				im_idle=1'b0;
				im_start=1'b0;
				im_delay=1'b0;
				im_shift=1'b0;
				im_stop =1'b1;

				SerialDataOut <= 1'b1; //send stop indication

				if(baud_count>= bit_time)begin
					baud_count <=0; //restart the counter
					state <= IDLE; //go to idle, nothing to send now
				end else begin
					baud_count <= baud_count +1'b1;
					state <= STOP;
				end
			end

		endcase		
	end
end



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