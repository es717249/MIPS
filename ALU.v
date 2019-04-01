 /******************************************************************* 
* Name:
*	ALU.v
* Description:
* 	This module is a behavioral ALU with a parameter.
* Inputs:
*	input [WORD_LENGTH-1:0] dataA,//first data value
*	input [WORD_LENGTH-1:0] dataB,//second data value
*	input [4:0] control,

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

module ALU
#(
	parameter WORD_LENGTH =8
)
(
	input [WORD_LENGTH-1:0] dataA,
	input [WORD_LENGTH-1:0] dataB,
	input [3:0] control,
	input [4:0] shmt,
	output carry,
	output zero,
	output negative,
	output [WORD_LENGTH-1:0] dataC //result
	
);

reg [WORD_LENGTH:0]result_reg; 				//1 bit more to handle carry in the sum
//reg carry_reg=0; 
//reg zero_reg = 0;									//this stores the carry indicator
reg [WORD_LENGTH:0]mask= 1<< WORD_LENGTH; //mask to check the carry			
reg [WORD_LENGTH:0]compl_B;
reg negative_reg=0;

wire zero_w ;

assign dataC = result_reg[31:0];

assign zero = (result_reg==0) ? 1'd1:1'd0;

assign carry =(result_reg & mask)?1'b1:1'b0; 

always@(*)begin 

			
	compl_B=(~dataB)+1; 	
	
	case(control)
				
		4'b0000: //multiplicacion, 
		//In this case the result should have 2*WORD_LENGTH
		begin
			result_reg	<=dataA * dataB;
			
			negative_reg <=0;
		end

		4'b0001: //subtract 
		//The negative flag is turned on if it is negative result	
		begin						
			//(A > B)
			if(dataA > dataB)
			begin				
				result_reg 	<= dataA-dataB;								
				negative_reg <=0;
			end
			
			else if(dataA < dataB)
			begin								
				//complement the result to obtain the real magnitude
				result_reg  <=(~(dataA+compl_B))+1'b1;
				negative_reg <=1;

			end	else if(dataA == dataB)begin
				result_reg 	<=0;								
				negative_reg <=0;				

			end else begin
			/* Not expected */
				result_reg 	<=0;								
				negative_reg <=0;				
			end 

		end
		
		
		4'b0010:   /*Sum */
		begin
			result_reg 	<= dataA+dataB; 	
			
			negative_reg <=0;
		end	

		4'b0011:  //negado
		begin
			result_reg	<=~dataA;
			negative_reg <=0;
		end
		
		4'b0100://complemento
		begin
			result_reg	<=(~dataA)+1'b1;
			negative_reg <=0;
		end 	
		4'b0101: //AND
		begin
			result_reg	<=(dataA & dataB);
			negative_reg <=0;
		end
		4'b0110: //OR
		begin
			result_reg	<=(dataA | dataB);
			negative_reg <=0;
		end
		4'b0111: //XOR
		begin
			result_reg	<=(dataA ^ dataB);
			negative_reg <=0;
		end		
		4'b1000: //corrimiento con shift amount a la izquierda
		begin		
			result_reg	<=  dataB<< shmt;		
			negative_reg <=0;
		end
		4'b1001: //corrimiento con shift amount a la derecha
		begin
			result_reg	<= dataB >> shmt;
			
			negative_reg <=0;
		end	
		4'b1010:	//shift 
		begin
			result_reg	<=  dataB<< dataA;		
			 			
			negative_reg <=0;
		end 
		4'b1011:	//corrimiento a la izq << 16 
		begin 
			result_reg	<=  dataB<< 16;		
			negative_reg <=0;
		end 
		4'b1100:	//slti
		begin
			if(dataA < dataB)
			begin
				result_reg	 <=	1'd1;
				negative_reg <=1'd1;
			end else begin
				result_reg	 <=	1'd0;
				negative_reg <=1'b0;
			end
		end
//		4'b1101:
//		begin
//			result_reg	 <=	1'd0;
//			negative_reg <=0;	
//		end
//		4'b1110:
//		begin
//			result_reg	 <=	1'd0;
//			negative_reg <=0;	
//		end
//		4'b1111:
//		begin
//			result_reg	 <=	1'd0;
//			negative_reg <=0;	
//		end
		default:
		begin 
			result_reg	 <=	1'd0;
			negative_reg <=0;		
		end
		
	endcase
	
end

assign negative = negative_reg;

endmodule