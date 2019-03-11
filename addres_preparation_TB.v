module addres_preparation_TB;


	wire [5:0] opcode;
	wire [5: 0]funct; //select the function
	reg [31:0] Mmemory_output;	//rom instruction content
	wire [4 : 0]rs;		 //source 1
	wire [4 : 0]rt;		 //source 2
	wire [4 : 0]rt_im;		 //Destination: 20:16 bit (immediate)
	wire [4 : 0]rd;		  //Destination: 15:11 bit (R type)
	wire [15:0] immediate_data;


addres_preparation add_prep
(	
	.Mmemory_output(Mmemory_output),	//rom instruction content
	.opcode(opcode),
	.funct(funct),
	.rs(rs),		 //source 1
	.rt(rt),		 //source 2
	.rt_im(rt_im),		 //Destination: 20:16 bit (immediate)
	.rd(rd),		  //Destination: 15:11 bit (R type)
	.immediate_data(immediate_data)
);


initial begin
	#5 Mmemory_output =32'h21290004;
end

endmodule