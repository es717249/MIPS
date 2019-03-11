module addres_preparation
(
	input [31:0] Mmemory_output,	//rom instruction content
	
	output [5:0] opcode, 
	output [5: 0]funct, 		//select the function
	output [4 : 0]rs,		 	//source 1
	output [4 : 0]rt,		 	//source 2
	output [4 : 0]rt_im,		//Destination: 20:16 bit (immediate)
	output [4 : 0]rd,		  	//Destination: 15:11 bit (R type)
	output [4:0] shamt,			//Shamt field for R type instruction
	output [15:0] immediate_data, //immediate field for I instruction
	output [25:0] address_j		//address field for J instruction
);

/**************************************************
   31    26|25  21|20  16|15  11|10      6|5     0|
   ------------------------------------------------
R:	|opcode|  rs  |  rt  |  rd  |  shamt  | funct |
I:	|opcode|  rs  |  rt  |     immediate 		  |
J:	|opcode|			address					  |
 **************************************************/
assign opcode 	= Mmemory_output[31:26];	
assign rs 		= Mmemory_output[25:21];
assign rt 		= Mmemory_output[20:16];
assign rd 		= Mmemory_output[15:11];
assign shamt 	= Mmemory_output[10:6 ];
assign funct 	= Mmemory_output[ 5:0 ];
assign rt_im 	= Mmemory_output[20:16];
assign address_j= Mmemory_output[25:0 ];
assign immediate_data = Mmemory_output[15:0];




endmodule