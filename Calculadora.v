 /******************************************************************* 
* Name:
*	Calculadora.v
* Description:
* 	This module is a behavioral ALU with a parameter.
* Inputs:
*	input clk: Clock signal 
*	input reset:reset signal
*	input enable: enable signal
*	input reset_sync: reset asynchronous signal
*	
*	input [WORD_LENGTH-1:0] dataA: first input data 
*	input [WORD_LENGTH-1:0] dataB: second input data 
*	input [4:0] control: control signal

* Outputs:
*	output [WORD_LENGTH-1:0]carry,//carry output
*	output [WORD_LENGTH-1:0] dataC //result

* Versión:  
*	1.0
* Author: 
*	Nestor Damian Garcia Hernandez
* Fecha: 
*	04/09/2017
*********************************************************************/

module Calculadora
#(
	parameter WORD_LENGTH =6
)
(

	input clk,
	input reset,
	input enable,
	input reset_sync,
	
	input [WORD_LENGTH-1:0] dataA,
	input [WORD_LENGTH-1:0] dataB,
	input [4:0] control,
	output [WORD_LENGTH-1:0]carry,
	output [WORD_LENGTH-1:0] dataC //result	
);


wire [4:0] control_to_ALU_wire;
wire [WORD_LENGTH-1:0] dataA_to_ALU_wire;
wire [WORD_LENGTH-1:0] dataB_to_ALU_wire;
wire [2:0] regcontrol;

wire [WORD_LENGTH-1:0] result_to_ResultRegister; 
wire [WORD_LENGTH-1:0] register_to_outputResult;

wire [WORD_LENGTH-1:0] carry_to_CarryRegister;
wire [WORD_LENGTH-1:0] register_to_Carry;

//Receiving control signal 

Register 
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Rx_controlSig
(
	.clk(clk),
	.reset(reset),
	.enable(enable),
	.reset_sync(reset_sync),
	.Data_Input(control),
	.Data_Output(control_to_ALU_wire)
);

//receiving data A
Register 
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Rx_dataA
(
	.clk(clk),
	.reset(reset),
	.enable(enable),
	.reset_sync(reset_sync),
	.Data_Input(dataA),
	.Data_Output(dataA_to_ALU_wire)
);
//receiving data B
Register 
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Rx_dataB
(
	.clk(clk),
	.reset(reset),
	.enable(enable),
	.reset_sync(reset_sync),
	.Data_Input(dataB),
	.Data_Output(dataB_to_ALU_wire)
);

//Setting information to ALU 

ALU
#(
	.WORD_LENGTH(WORD_LENGTH)
)
ALU_calculadora
(
	.dataA(dataA_to_ALU_wire),
	.dataB(dataB_to_ALU_wire),
	.control(control_to_ALU_wire),
	.carry(carry_to_CarryRegister),
	.dataC(result_to_ResultRegister)
);

//Saving Carry output to register
Register 
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Store_carry_ALU
(
	.clk(clk),
	.reset(reset),
	.enable(enable),
	.reset_sync(reset_sync),
	.Data_Input(carry_to_CarryRegister),
	.Data_Output(register_to_Carry)
);

//Saving Result output to register 
Register 
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Store_result_ALU
(
	.clk(clk),
	.reset(reset),
	.enable(enable),
	.reset_sync(reset_sync),
	.Data_Input(result_to_ResultRegister),
	.Data_Output(register_to_outputResult)
);

assign dataC=register_to_outputResult;
assign carry=register_to_Carry;


endmodule