module SignExtend_module
(
	input [15:0]immediate,
	output [31:0]extended_sign_out
);
	localparam nbit=5'd16;


	assign extended_sign_out = (immediate[15]==1'b0)?{{nbit{1'b0}},immediate}:{{nbit{1'b1}},immediate} ;

endmodule