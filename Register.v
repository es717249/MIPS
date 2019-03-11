/*******************************************************************
* Name:
*	Register.v
* Description:
* 	This module generates a Flip flop of N bits 

* Parameters:
	
	parameter WORD_LENGTH: The number of bits of the registers	

* Inputs:
	
	input clk: clock signal 
	input reset: reset signal
	input enable: enable signal
	input [WORD_LENGTH-1 : 0] Data_Input: the input data to store

* Outputs:
	output [WORD_LENGTH-1 : 0] Data_Output : output signal with the stored value

* Versión:  
*	1.0
* Author: 
*	Nestor Damian Garcia Hernandez
*	Diego Gonźalez Avalos
* Fecha: 
*	18/10/2017
*********************************************************************/

 module Register
#(
	parameter WORD_LENGTH = 32
)

(
	// Input Ports
	input clk,
	input reset,
	input enable,
	input [WORD_LENGTH-1 : 0] Data_Input,

	// Output Ports
	output [WORD_LENGTH-1 : 0] Data_Output
);

reg  [WORD_LENGTH-1 : 0] Data_reg;

always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) 
		Data_reg <= 32'd0;
	else begin
		if(enable ==1'b1)
			Data_reg <= Data_Input;
	end
		
end

assign Data_Output = Data_reg;


endmodule
