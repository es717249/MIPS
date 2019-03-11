module RX
#(
	parameter Nbit =8,
	parameter baudrate= 9600,	
	parameter clk_freq =50000000,
	parameter bit4count= CeilLog2(Nbit),		
	parameter bit_time = clk_freq/baudrate,
	parameter baud_cnt_bits = CeilLog2(bit_time),
	parameter half_bit_time = (clk_freq/baudrate)/2,
	//states
	parameter IDLE = 0,
	parameter START= 1,
	parameter DELAY= 2,
	parameter SHIFT= 3,
	parameter STOP = 4
)
(
	//inputs
	input SerialDataIn, //it's the input data port 
	input clk, //clk signal
	input reset, //async signal to reset 
	input clr_rx_flag, //to clear the Rx signal
	
	//outputs
	output [Nbit-1:0] DataRx, //Port where Rx information is available
	output reg Rx_flag , //indicates a data was received 
	output reg Parity_error //when received logic data contains parity errors. Just for pair parity
);


reg [bit4count:0]bit_number; //this will help to count N bits to transmit, in this implementation 8 times (8 bits)
reg [2:0] state;
reg [Nbit-1:0]buff_tx;  //auxiliary buffer to keep data to transmit
reg [Nbit-1:0]buff_rx;	//auxiliary buffer to keep data to receive
reg [baud_cnt_bits-1:0] baud_count;

assign DataRx = buff_rx;


//Process for RX
always @(posedge clk or negedge reset or posedge clr_rx_flag) begin
	
	if (reset==1'b0) begin// reset		
		state <= IDLE;
		buff_rx <=0; //clear buffer
		baud_count <=0; //restarts the count
		bit_number <=0; //restarts the count
		Rx_flag <=0; //restarts the receiver flag
		Parity_error <=0; //restarts the parity error flag
	end
	else begin 
		if(clr_rx_flag==1)
			Rx_flag=0;  //Clear the flag due clr signal.
		else
			case(state)
				IDLE:		//wait for start bit
					begin
						bit_number <=0;
						baud_count <=0;
						if(SerialDataIn==1)
							state <= IDLE;
						else begin
							Parity_error <=0;
							state <= START;		//Start the reception
							end
					end
				START:												//check for start bit
					if(baud_count >= half_bit_time)begin
						baud_count<=0;
						state <= DELAY;
						end
					else begin	
						baud_count <= baud_count + 1'b1;
						state <= START;
						end
				DELAY:
					if(baud_count >= bit_time)begin
						baud_count <=0;
						if(bit_number< Nbit)
							state <= SHIFT;		//go for a new bit
						else
							state <= STOP;	//a bit had been received
							end 
					else begin
						baud_count <= baud_count + 1'b1;
						state <=DELAY;	//keep in delay state
						end
				SHIFT:
					begin
						buff_rx[Nbit-1] <= SerialDataIn;
						buff_rx[Nbit-2:0] <= buff_rx[Nbit-1:1]; //shift data
						bit_number <= bit_number + 1'b1;
						state <=DELAY;
					end											
				STOP:
					begin
						Rx_flag <=1; //Data received is completed
						if(SerialDataIn==0)
							Parity_error <=1; 
						else
							Parity_error <=0; 
						state <= IDLE;
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