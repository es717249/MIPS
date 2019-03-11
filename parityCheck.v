 /******************************************************************* 
* Name:
*	parityCheck.v
* Description:
* 	This module checks the even parity of a data array
* Parameters:

*	 RxNbit :	Number of bits on the data array

* Inputs:
*
*	[RxNbit-1:0] Rxbuff: data array to analyze
* 	enable : enable signal to do the parity checking
*	rx_parity: received parity from the PC
* Outputs:
*	Parity_error : This indicates if the received parity is equal or not to the calculated parity

* Versión:  
*	1.0
* Author: 
*	Nestor Damian Garcia Hernandez
*  Diego González Ávalos
* Fecha: 
*	25/11/2017
*********************************************************************/
module parityCheck
#(
	parameter RxNbit=8
)
(
	input [RxNbit-1:0] Rxbuff,
	input enable,
	input rx_parity,
	output Parity_error
);
	wire calculated_parity;

	assign calculated_parity = (~^Rxbuff) && enable ;
	assign Parity_error = !(rx_parity== calculated_parity) && enable ;

endmodule