module decode_instruction
(
	/* input */
	input [5:0] opcode_reg,
	input [5:0] funct_reg,
	/* output */
	output destination_indicator,	//1: R type, 0: I type
	output [3:0]ALUControl,
	output flag_sw,
	output flag_lw,
	output flag_R_type,				//R type =1
	output flag_I_type,				//I type =1
	output flag_J_type,				//J type =1
	output [1:0]mux4selector,		//allows to select the operand for getting srcB number
	output controlSrcA)				//to control the source data for srcA
;

reg [1:0]mux4selector_reg;
reg destination_reg_indicator; 		//1: R type (rd), 0: I type (rt)
reg [3:0]ALUControl_reg;
reg flag_sw_reg;
reg flag_lw_reg;
reg flag_R_type_reg;
reg flag_I_type_reg;
reg flag_J_type_reg;
reg controlSrcA_reg;



always @(opcode_reg,funct_reg) begin	

//Starts decoding 
	if(opcode_reg==6'd0)begin //is an R type instruction, destination_reg_indicator=1
		
		flag_R_type_reg = 1;	//Indicate that a R type instruction was detected
		flag_I_type_reg = 0;	//Not an I type instruction
		flag_J_type_reg = 0;	//Not a J type instruction
		flag_lw_reg		=1'b0;
		flag_sw_reg		=1'b0;

		case(funct_reg)
			6'h0:  //sll
			begin
				destination_reg_indicator=1;	//destination will be rd
				ALUControl_reg=4'd8;			//operation Shift to left				
				mux4selector_reg=2'd0;
				controlSrcA_reg =1;
				//flag_lw_reg=1'b0;
				//flag_sw_reg=1'b0;
			end
			6'h25: ///or
			begin
				destination_reg_indicator=1;	//destination will be rd
				ALUControl_reg=4'd6;			//operation OR				
				/* mux4selector_reg=2'd2; */
				mux4selector_reg=2'd0;
				controlSrcA_reg =1;
				//flag_lw_reg=1'b0;
				//flag_sw_reg=1'b0;
			end
			6'h20: //add
			begin
				destination_reg_indicator=1;	//destination will be rd
				ALUControl_reg=4'd2;			//operation OR				
				mux4selector_reg=2'd0;
				controlSrcA_reg =1;
				//flag_lw_reg=1'b0;
				//flag_sw_reg=1'b0;
			end
			default:
			begin
				destination_reg_indicator=1;	//destination will be rd
				ALUControl_reg=4'd2;			//operation add 				
				mux4selector_reg=2'd0;
				controlSrcA_reg =1;
				//flag_lw_reg=1'b0;
				//flag_sw_reg=1'b0;
			end
		endcase

	end else begin  //is an I type instruction, destination_reg_indicator=0
		
		flag_R_type_reg = 0;	//Not a R type instruction 
		flag_I_type_reg = 1;	//Indicate it is I type instruction
		flag_J_type_reg = 0;	//Not a J type instruction

		case(opcode_reg)

			6'b001000: //addi - 0x08
			//Tengo que guardar estos datos en el register file
			begin
				destination_reg_indicator=0;	//destination will be rt
				ALUControl_reg=4'd2;			//operation add 				
				mux4selector_reg=2'd2;
				controlSrcA_reg =0;
				flag_lw_reg=1'b0;
				flag_sw_reg=1'b0;
			end
			6'b001100: //andi - 0x0C
			begin
				destination_reg_indicator=0;	//destination will be rt
				ALUControl_reg=4'd5;			//operation and 	
				mux4selector_reg=2'd2;	
				controlSrcA_reg =0;		
				flag_lw_reg=1'b0;
				flag_sw_reg=1'b0;
			end
			6'b101011: //sw - 0x2B
			begin
				destination_reg_indicator=0;	//destination will be rt
				ALUControl_reg=4'd2;			//operation add 				
				//create a flag so we can pass to write back 
				flag_lw_reg=1'b0;
				flag_sw_reg=1'b1;	
				mux4selector_reg=2'd0;	
				controlSrcA_reg =0;
			end
			6'b100011: //lw	- 0x23
			begin
				destination_reg_indicator=0;	//destination will be rt
				ALUControl_reg=4'b1010;			//do nothing on ALU
				flag_lw_reg=1'b1;
				flag_sw_reg=1'b0;		
				mux4selector_reg=2'd0;	
				controlSrcA_reg =0;	
			end
			6'b000100: //beq - 0x04
			begin
			
			end 
			6'b000101: //bne
			begin 

			end 

			default:
			begin
				ALUControl_reg=4'd2;//operation add  /**** CHECK **/
				destination_reg_indicator=0;//destination will be rt
				flag_lw_reg=1'b0;
				flag_sw_reg=1'b0;	
				mux4selector_reg=2'd0;	
				controlSrcA_reg =0;		
			end
		endcase 
	end 
end

assign destination_indicator= destination_reg_indicator ;
assign ALUControl= ALUControl_reg ;
assign flag_lw = flag_lw_reg;
assign flag_sw = flag_sw_reg ;
assign mux4selector= mux4selector_reg;
assign controlSrcA =controlSrcA_reg ;
assign flag_R_type = flag_R_type_reg;
assign flag_I_type = flag_I_type_reg;
assign flag_J_type = flag_J_type_reg;

endmodule