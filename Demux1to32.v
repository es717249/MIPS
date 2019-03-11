/*******************************************************************
* Name:
*	Demux1to32.v
* Description:
* 	This module generates a 1 to 32 demultiplexer 

* Parameters:
	
	parameter WORD_LENGTH: The number of bits of the registers
	parameter NBITS: the number of needed bits for the address registers

* Inputs:
	
	input [NBITS-1 : 0] Selector:  demux selector, allows to select the desired signal to pass to the output
	input Demux_Input: the signals to route/demultiplex		

* Outputs:
	output reg Data_n: output signals

* Versión:  
*	1.0
* Author: 
*	Nestor Damian Garcia Hernandez
*	Diego Gonźalez Avalos
* Fecha: 
*	18/10/2017
*********************************************************************/

module Demux1to32
#(
	parameter WORD_LENGTH = 1,
	parameter NBITS = CeilLog2(WORD_LENGTH)
)
(

	// Input Ports
	input Demux_Input,
	input [NBITS-1 : 0] Selector,	
	
	// output Ports
	output reg Data_0,
	output reg Data_1,
	output reg Data_2,
	output reg Data_3,
	output reg Data_4,
	output reg Data_5,
	output reg Data_6,
	output reg Data_7,
	output reg Data_8,
	output reg Data_9,
	output reg Data_10,
	output reg Data_11,
	output reg Data_12,
	output reg Data_13,
	output reg Data_14,
	output reg Data_15,
	output reg Data_16,
	output reg Data_17,
	output reg Data_18,
	output reg Data_19,
	output reg Data_20,
	output reg Data_21,
	output reg Data_22,
	output reg Data_23,
	output reg Data_24,
	output reg Data_25,
	output reg Data_26,
	output reg Data_27,
	output reg Data_28,
	output reg Data_29,
	output reg Data_30,
	output reg Data_31
);

 always@(Selector or Demux_Input) begin
 
	case(Selector)
		5'd0 :  
		begin
				Data_0 = Demux_Input;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd1 :  
				begin
				Data_0 = 1'b0;
		 		Data_1 = Demux_Input;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd2 :  
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = Demux_Input;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd3 :  
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = Demux_Input;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd4 :  
				begin
				Data_0 =1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 =  Demux_Input;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd5 :  
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = Demux_Input;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd6 :  
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = Demux_Input;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd7 :  
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = Demux_Input;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd8 :  
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = Demux_Input;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd9 :  
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = Demux_Input;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd10 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = Demux_Input;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd11 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = Demux_Input;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd12 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = Demux_Input;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd13 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = Demux_Input;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd14 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = Demux_Input;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd15 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = Demux_Input;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd16 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = Demux_Input;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd17 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;	
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = Demux_Input;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd18 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = Demux_Input;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd19 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = Demux_Input;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd20 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = Demux_Input;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd21 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = Demux_Input;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd22 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = Demux_Input;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd23 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = Demux_Input;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd24 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = Demux_Input;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd25 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = Demux_Input;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd26 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = Demux_Input;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd27 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = Demux_Input;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd28 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = Demux_Input;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd29 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = Demux_Input;
				Data_30 = 1'b0;
				Data_31 = 1'b0;
		end
		5'd30 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = Demux_Input;
				Data_31 = 1'b0;
		end
		5'd31 : 
				begin
				Data_0 = 1'b0;
		 		Data_1 = 1'b0;
		 		Data_2 = 1'b0;
		 		Data_3 = 1'b0;
		 		Data_4 = 1'b0;
		 		Data_5 = 1'b0;
		 		Data_6 = 1'b0;
		 		Data_7 = 1'b0;
		 		Data_8 = 1'b0;
		 		Data_9 = 1'b0;
				Data_10 = 1'b0;
				Data_11 = 1'b0;
				Data_12 = 1'b0;
				Data_13 = 1'b0;
				Data_14 = 1'b0;
				Data_15 = 1'b0;
				Data_16 = 1'b0;
				Data_17 = 1'b0;
				Data_18 = 1'b0;
				Data_19 = 1'b0;
				Data_20 = 1'b0;
				Data_21 = 1'b0;
				Data_22 = 1'b0;
				Data_23 = 1'b0;
				Data_24 = 1'b0;
				Data_25 = 1'b0;
				Data_26 = 1'b0;
				Data_27 = 1'b0;
				Data_28 = 1'b0;
				Data_29 = 1'b0;
				Data_30 = 1'b0;
				Data_31 = Demux_Input;
		end
	 default: Data_0 = Demux_Input;
	endcase
 end
 
 
  /*Log Function*/
     function integer CeilLog2;
       input integer data;
       integer i,result;
       begin
          for(i=0; 2**i < data; i=i+1)
             result = i + 1;
          CeilLog2 = result;
       end
    endfunction
	 
endmodule
