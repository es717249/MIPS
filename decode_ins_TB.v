module decode_ins_TB;

	reg [5:0]opcode_reg;
	reg [5:0] funct_reg;
	wire destination_indicator;
	wire [3:0]ALUControl;

decode_instruction duv
(
	.opcode_reg(opcode_reg),
	.funct_reg(funct_reg),
	.destination_indicator(destination_indicator),
	.ALUControl(ALUControl)
);

initial begin
	#5 opcode_reg=6'd8;
	funct_reg = 6'b001100; //andi

	#5 opcode_reg=6'd0; //or
	funct_reg = 6'h25;

	#5 opcode_reg=6'd0; //sll
	funct_reg = 6'h0;


end

endmodule