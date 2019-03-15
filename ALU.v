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
	output carry,
	output [WORD_LENGTH-1:0] dataC //result
	
);

reg [WORD_LENGTH:0]result_reg; 				//1 bit more to handle carry in the sum
reg carry_reg=0; 									//this stores the carry indicator
reg [WORD_LENGTH:0]mask= 1<< WORD_LENGTH; //mask to check the carry			
reg [WORD_LENGTH:0]compl_B;
				
wire [WORD_LENGTH-1:0] tmp_shift2;

assign tmp_shift2 = dataB <<2;

always@(*)begin 

			
	compl_B=(~dataB)+1; 	
	
	case(control)
				
		4'b0000: //multiplicacion, 
		//In this case the result should have 2*WORD_LENGTH
		begin
			result_reg=dataA * dataB;
			carry_reg=0;
		end

		4'b0001: //subtract 
		begin						
			//(A > B)
			if(dataA > dataB)
			begin				
				result_reg = dataA-dataB;				
				carry_reg=(result_reg & mask)?1'b1:1'b0; 
			end
			
			else //(dataA < dataB)
			begin								
			
			//The carry flag is turned on if it is negative result	
				carry_reg=((dataA+compl_B) & mask)?1'b1:1'b0;
					//complement the result to obtain the real magnitude
				result_reg  =(~(dataA+compl_B))+1'b1;
			end			
		end
		
		
		4'b0010:   /*Sum */
		begin
			result_reg= dataA+dataB; 	
			carry_reg=(result_reg & mask)?1'b1:1'b0;			 				
		end	

		4'b0011:  //negado
		begin
			result_reg=~dataA;
			carry_reg=1'b0;
		end
		
		4'b0100://complemento
		begin
			result_reg=(~dataA)+1'b1;
			carry_reg=1'b0;
		end 	
		4'b0101: //AND
		begin
			result_reg=(dataA & dataB);
			carry_reg=1'b0;
		end
		4'b0110: //OR
		begin
			result_reg=(dataA | dataB);
			carry_reg=1'b0;
		end
		4'b0111: //XOR
		begin
			result_reg=(dataA ^ dataB);
			carry_reg=1'b0;
		end		
		4'b1000: //corrimiento
		begin		
			result_reg= dataA << dataB;		
			carry_reg=0;
		end
		4'b1001: //corrimiento
		begin
			result_reg= dataA >> dataB;
			carry_reg=0;
		end	
		4'b1010:
		begin
			//corrimiento <<2 y suma
			result_reg= tmp_shift2 + dataB;
			carry_reg=(result_reg & mask)?1'b1:1'b0;
		end
		default:
		begin 
			result_reg=	1'd0;
			carry_reg=	1'd0;			
		end
		
	endcase
	
end

assign dataC = result_reg[31:0];
assign carry = carry_reg;
endmodule