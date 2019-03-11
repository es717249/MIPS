module decode_instruction
(
	input [5:0]opcode_reg,
	input [5:0] funct_reg,
	output destination_indicator,
	output [3:0]ALUControl,
	output flag_sw,
	output flag_lw,
	output [1:0]mux4selector,
	output controlSrcA

);

reg [1:0]mux4selector_reg;
reg destination_reg_indicator; //1: R type, 0: I type
reg [3:0]ALUControl_reg;
reg flag_sw_reg;
reg flag_lw_reg;
reg controlSrcA_reg;



always @(opcode_reg,funct_reg) begin	

//Starts decoding 
	if(opcode_reg==6'd0)begin //is an R type instruction, destination_reg_indicator=1
		
		case(funct_reg)
			6'h0:  //sll
			begin
				destination_reg_indicator=1;//destination will be rd
				ALUControl_reg=4'd8;//operation Shift to left
				flag_lw_reg=1'b0;
				flag_sw_reg=1'b1;
				mux4selector_reg=2'd0;
				controlSrcA_reg =1;
			end
			6'h25: ///or
			begin
				destination_reg_indicator=1;//destination will be rd
				ALUControl_reg=4'd6;//operation OR
				flag_lw_reg=1'b0;
				flag_sw_reg=1'b1;
				mux4selector_reg=2'd2;
				controlSrcA_reg =1;
			end
			6'h20: //add
			begin
				destination_reg_indicator=1;//destination will be rd
				ALUControl_reg=4'd2;//operation OR
				flag_lw_reg=1'b0;
				flag_sw_reg=1'b1;
				mux4selector_reg=2'd0;
				controlSrcA_reg =1;
			end
			default:
			begin
				destination_reg_indicator=1;//destination will be rd
				ALUControl_reg=4'd2;//operation add 
				flag_lw_reg=1'b0;
				flag_sw_reg=1'b0;
				mux4selector_reg=2'd0;
				controlSrcA_reg =1;
			end
		endcase

	end else begin  //is an I type instruction, destination_reg_indicator=0
		
		case(opcode_reg)

			6'b001000: //addi
			//Tengo que guardar estos datos en el register file
			begin
				destination_reg_indicator=0;//destination will be rt
				ALUControl_reg=4'd2;//operation add 
				flag_lw_reg=1'b0;
				flag_sw_reg=1'b1;
				mux4selector_reg=2'd2;
				controlSrcA_reg =0;
			end
			6'b001100: //andi
			begin
				destination_reg_indicator=0;//destination will be rt
				ALUControl_reg=4'd5;//operation and 
				flag_lw_reg=1'b0;
				flag_sw_reg=1'b1;	
				mux4selector_reg=2'd2;	
				controlSrcA_reg =0;		
			end
			6'b101011: //sw
			begin
				destination_reg_indicator=0;//destination will be rt
				ALUControl_reg=4'b1010;//do nothing on alu
				//create a flag so we can pass to write back 
				flag_lw_reg=1'b0;
				flag_sw_reg=1'b1;	
				mux4selector_reg=2'd0;	
				controlSrcA_reg =0;		
			end
			6'b100011: //lw
			begin
				destination_reg_indicator=0;//destination will be rt
				ALUControl_reg=4'b1010;//do nothing on ALU
				flag_lw_reg=1'b1;
				flag_sw_reg=1'b0;		
				mux4selector_reg=2'd0;	
				controlSrcA_reg =0;	
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
endmodule