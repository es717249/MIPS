/*******************************************************************
* Name:
*	Mux32to1.v
* Description:
* 	This module generates a 32 to 1 multiplexer 

* Parameters:
	
	parameter WORD_LENGTH: The number of bits of the registers
	parameter NBITS: the number of needed bits for the address registers

* Inputs:
	
	input [NBITS-1 : 0] Selector:  mux selector, allows to select the desired signal to pass to the output
	input [WORD_LENGTH-1 : 0] Data_n: the signals to multiplex		

* Outputs:
	output reg [WORD_LENGTH-1 : 0] Mux_Output: output signal

* Versión:  
*	1.0
* Author: 
*	Nestor Damian Garcia Hernandez
*	Diego Gonźalez Avalos
* Fecha: 
*	18/10/2017
*********************************************************************/

module Mux32to1
#(
	parameter WORD_LENGTH = 32,
	parameter NBITS = CeilLog2(WORD_LENGTH)
)
(
	// Input Ports
	input [NBITS-1 : 0]Selector,
	input [WORD_LENGTH-1 : 0] Data_0,
	input [WORD_LENGTH-1 : 0] Data_1,
	input [WORD_LENGTH-1 : 0] Data_2,
	input [WORD_LENGTH-1 : 0] Data_3,
	input [WORD_LENGTH-1 : 0] Data_4,
	input [WORD_LENGTH-1 : 0] Data_5,
	input [WORD_LENGTH-1 : 0] Data_6,
	input [WORD_LENGTH-1 : 0] Data_7,
	input [WORD_LENGTH-1 : 0] Data_8,
	input [WORD_LENGTH-1 : 0] Data_9,
	input [WORD_LENGTH-1 : 0] Data_10,
	input [WORD_LENGTH-1 : 0] Data_11,
	input [WORD_LENGTH-1 : 0] Data_12,
	input [WORD_LENGTH-1 : 0] Data_13,
	input [WORD_LENGTH-1 : 0] Data_14,
	input [WORD_LENGTH-1 : 0] Data_15,
	input [WORD_LENGTH-1 : 0] Data_16,
	input [WORD_LENGTH-1 : 0] Data_17,
	input [WORD_LENGTH-1 : 0] Data_18,
	input [WORD_LENGTH-1 : 0] Data_19,
	input [WORD_LENGTH-1 : 0] Data_20,
	input [WORD_LENGTH-1 : 0] Data_21,
	input [WORD_LENGTH-1 : 0] Data_22,
	input [WORD_LENGTH-1 : 0] Data_23,
	input [WORD_LENGTH-1 : 0] Data_24,
	input [WORD_LENGTH-1 : 0] Data_25,
	input [WORD_LENGTH-1 : 0] Data_26,
	input [WORD_LENGTH-1 : 0] Data_27,
	input [WORD_LENGTH-1 : 0] Data_28,
	input [WORD_LENGTH-1 : 0] Data_29,
	input [WORD_LENGTH-1 : 0] Data_30,
	input [WORD_LENGTH-1 : 0] Data_31,
	
	// Output Ports
	output reg [WORD_LENGTH-1 : 0] Mux_Output

);

 always@(Selector, 
	 Data_0, 
	 Data_1, 
	 Data_2, 
	 Data_3, 
	 Data_4, 
	 Data_5,  
	 Data_6,
	 Data_7, 
	 Data_8,
	 Data_9, 
	 Data_10, 
	 Data_11, 
	 Data_12, 
	 Data_13, 
	 Data_14, 
	 Data_15,  
	 Data_16,
	 Data_17,
	 Data_18,
	 Data_19, 
	 Data_20, 
	 Data_21, 
	 Data_22, 
	 Data_23, 
	 Data_24, 
	 Data_25,  
	 Data_26,
	 Data_27,
	 Data_28,
	 Data_29, 
	 Data_30, 
	 Data_31 
 ) begin
	case(Selector)
		5'd0 : Mux_Output= Data_0;
		5'd1 : Mux_Output= Data_1;
		5'd2 : Mux_Output= Data_2;
		5'd3 : Mux_Output= Data_3;
		5'd4 : Mux_Output= Data_4;
		5'd5 : Mux_Output= Data_5;
		5'd6 : Mux_Output= Data_6;
		5'd7 : Mux_Output= Data_7;
		5'd8 : Mux_Output= Data_8;
		5'd9 : Mux_Output= Data_9;
		5'd10 : Mux_Output= Data_10;
		5'd11 : Mux_Output= Data_11;
		5'd12 : Mux_Output= Data_12;
		5'd13 : Mux_Output= Data_13;
		5'd14 : Mux_Output= Data_14;
		5'd15 : Mux_Output= Data_15;
		5'd16 : Mux_Output= Data_16;
		5'd17 : Mux_Output= Data_17;
		5'd18 : Mux_Output= Data_18;
		5'd19 : Mux_Output = Data_19;
		5'd20 : Mux_Output= Data_20;
		5'd21 : Mux_Output= Data_21;
		5'd22 : Mux_Output= Data_22;
		5'd23 : Mux_Output= Data_23;
		5'd24 : Mux_Output= Data_24;
		5'd25 : Mux_Output= Data_25;
		5'd26 : Mux_Output= Data_26;
		5'd27 : Mux_Output= Data_27;
		5'd28 : Mux_Output= Data_28;
		5'd29 : Mux_Output= Data_29;
		5'd30 : Mux_Output= Data_30;
		5'd31 : Mux_Output= Data_31;
	 default: Mux_Output= Data_0;
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
