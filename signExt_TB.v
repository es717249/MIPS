module signExt_TB;


reg [15:0]immediate;
wire [31:0]extended_sign_out;


SignExtend_module duv
(
	.immediate(immediate),
	.extended_sign_out(extended_sign_out)
);


initial begin
	#5 immediate =16'd1;

	#5 immediate=16'h8000;
end

endmodule