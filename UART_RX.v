/******************************************************************* 
* Name:
*	UART_RX.v
* Description:
* 	This module implements an UART RX module
* Parameters:
*	 Nbit :	Number of bits to transmit
*	 baudrate: baudrate to use 
*	 clk_freq : system clock frequency
*	 bit4count : Needed bits for the counter of Nbits to transmit
*	 bit_time : number of clk cycles to count
*	 baud_cnt_bits : number of bits for the baudrate counter 
*	 half_bit_time : the half of number of clk cycles to count
*	//states for the control machine
*	 IDLE = 0,
*	 START= 1,
*	 DELAY= 2,	Data adquisition
*	 STOP = 3
*	DEFAULT=4
* Inputs:
*
*	clk :  clk signal
*	reset :  async signal to reset 	
*	SerialDataIn :  it's the input data port 
*	clr_rx_flag: to clear the Rx signal
* 
* Outputs:
*	DataRx : Output for parallel data
*	Rx_flag : indicates a data was received 
*	Parity_error : when received logic data contains parity errors. Just for pair parity
* Versión:  
*	1.0
* Author: 
*	Nestor Damian Garcia Hernandez
* Fecha: 
*	01/04/2019
*********************************************************************/

/* Address: 0x10010028 */

module UART_RX
#(
	parameter Nbit =8,
	parameter baudrate= 9600,	
	parameter clk_freq =50000000,
	/*parameter baudrate= 5,	
	parameter clk_freq =50,*/
	parameter bit4count= CeilLog2(Nbit),		
	parameter bit_time = (clk_freq/baudrate)-1,/* Clocks per bit */
	//parameter bit_time = (clk_freq/baudrate),/* Clocks per bit */
	parameter baud_cnt_bits = CeilLog2(bit_time),	
	parameter half_bit_time = (bit_time)/2,
	
	//states
	parameter IDLE = 0,
	parameter START= 1,
	parameter DELAY= 2,	
	parameter STOP = 3,
	parameter DEFAULT=4

)
(
	//inputs
	input SerialDataIn, //it's the input data port 
	input clk, //clk signal
	input reset, //async signal to reset 
	input clr_rx_flag, //to clear the Rx signal. 0=clear the Rx flag, 1=awaiting for clear operation
	
	//outputs
	output [Nbit-1:0] DataRx, //Port where Rx information is available
	output reg Rx_flag  //indicates the data was completely received 
	//output Parity_error //when 	 logic data contains parity errors. Just for pair parity
);

//reg half_bit_time_reg = half_bit_time;
reg [bit4count:0]bit_number/*sythesis keep*/; //this will help to count N bits to receive, in this implementation 8 times (8 bits)
reg [2:0] state/*sythesis keep*/;
reg [Nbit-1:0]buff_rx/*sythesis keep*/;	//auxiliary buffer to keep data to receive
reg [baud_cnt_bits-1:0] clock_count/*sythesis keep*/;
reg Rx_flag_reg;
assign DataRx = buff_rx;

/* reg tmp_Rxdata2;
reg tmp_Rxdata;
always@(posedge clk)begin
	tmp_Rxdata2 <= SerialDataIn;
	tmp_Rxdata <= tmp_Rxdata;
end
 */

//reg rx_parity;

//Process for RX
always @(posedge clk or negedge reset) begin
	
	if (reset==1'b0) begin// reset		
		state <= IDLE;
		buff_rx <=0; //clear buffer
		clock_count <=0; //restarts the count
		bit_number <=0; //restarts the count		
		Rx_flag_reg <=0;
		//rx_parity <=0; //restarts the parity error flag
	end
	else begin 
		if(clr_rx_flag==1'b0)begin
			Rx_flag_reg<=1'b0;
		end else begin
			case(state)
				IDLE:		//wait for start bit
					begin
						bit_number <=0;
						clock_count <=0;
						if(SerialDataIn==1)
							state <= IDLE;
						else begin
							/* Change state when start bit is 0 and Rx_flag=1 */
							clock_count <=0;
							state <= START;		//Start the reception
						end
						
					end
				START:												//check for start bit
				begin
					if(clock_count == half_bit_time)begin
					/* the sampling now will be centered */
						clock_count<=0;
						state <= DELAY;					
					end else begin	
					/* it hasn't reached the middle of start bit,
						so increase the clock count*/
						clock_count <= clock_count + 1'b1;
						state <= START;
					end
				end
				DELAY:
				begin
					if(clock_count >= bit_time)begin
						/* Sample the bit now.It's in the middle of the signal */
						clock_count <=0;
						buff_rx[bit_number] <= SerialDataIn;

						if(bit_number< Nbit)begin							
							//go for a new bit
							bit_number <= bit_number + 1'b1;
							state <= DELAY;		
						end else begin
							/* Point to 0 space */
							bit_number <= 0;
							state <= STOP;	//a bit had been received
						end 
					end else begin
						clock_count <= clock_count + 1'b1;
						state <=DELAY;	//keep in delay state
					end
				end			
				STOP:
					begin
						if(clock_count >= bit_time)begin
							clock_count <= 	0;
							Rx_flag_reg <=	1;
							state <= IDLE;
						end else begin
							clock_count <= clock_count+1'b1;	
							state 		<= STOP;
						end
					end	
				DEFAULT:
				begin
					Rx_flag_reg <=0;
					state <= IDLE;
				end
			endcase
		end	
	end
end

always@(Rx_flag_reg)begin

	if(Rx_flag_reg==1'b0)
		Rx_flag <=1'b0;		
	else		
		Rx_flag <=1'b1;
end


/* always@(Rx_flag_reg,clr_rx_flag)begin
	if(clr_rx_flag==1'b0)begin
		Rx_flag <=1'b0;
		Rx_flag_reg<=1'b0;
	end else begin
		if(Rx_flag_reg==1'b1)
			Rx_flag <=1'b1;		
	end
end */

/* wire enable_paritycheck;
assign enable_paritycheck = Rx_flag ;
parityCheck
#( .RxNbit(Nbit))
parityErr
(
	.Rxbuff(buff_rx),
	.enable(enable_paritycheck),
	.rx_parity(rx_parity),
	.Parity_error(Parity_error)
);
 */


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