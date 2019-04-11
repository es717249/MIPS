/*******************************************************************
* Name:
*	Demux1to2.v
* Description:
* 	This module generates a 1 to 4 demultiplexer 

* Parameters:
	
	parameter DATA_LENGTH: The number of bits of the input

* Inputs:
	
	input [1: 0] Selector:  demux selector, allows to select the desired signal to pass to the output
	input [DATA_LENGTH-1:0]Demux_Input: the signals to route/demultiplex		

* Outputs:
	output reg [DATA_LENGTH-1:0] Data_n: output signals

* Versión:  
*	1.0
* Author: 
*	Nestor Damian Garcia Hernandez
* Fecha: 
*	27/03/2019
*********************************************************************/
module Demux1to4 #(
    parameter DATA_LENGTH = 32	
)(
	// Input Ports
    input [DATA_LENGTH-1:0] Demux_Input,
    input [1:0] Selector,
    //output Ports
    output reg [DATA_LENGTH-1:0] Dataout0,
    output reg [DATA_LENGTH-1:0] Dataout1,
    output reg [DATA_LENGTH-1:0] Dataout2,
    output reg [DATA_LENGTH-1:0] Dataout3
);

always@(Selector or Demux_Input)begin
    case (Selector)
      2'd0: 
      begin
        Dataout0 = Demux_Input;
        Dataout1 = 0;
        Dataout2 = 0;
        Dataout3 = 0;
      end
      2'd1:
      begin
        Dataout0 = 0;
        Dataout1 = Demux_Input;
        Dataout2 = 0;
        Dataout3 = 0;
      end
      2'd2: 
      begin
        Dataout0 = 0;
        Dataout1 = 0;
        Dataout2 = Demux_Input;
        Dataout3 = 0;
      end
      2'd3:
      begin
        Dataout0 = 0;
        Dataout1 = 0;
        Dataout2 = 0;
        Dataout3 = Demux_Input;
      end
      default: 
      begin
        Dataout0 = 0;
        Dataout1 = 0;
        Dataout2 = 0;
        Dataout3 = 0;
      end
    endcase
end


endmodule