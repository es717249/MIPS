/*To simulate this in modelsim do the following:
	When opening modelsim add "-voptargs=+acc=npr"
	Optimization by default turns off visibility of everything but the ports of a design
*/

module testsinglerom;

	parameter DATA_WIDTH=32;
	parameter ADDR_WIDTH=8;

	reg [(ADDR_WIDTH-1):0]addr;
	reg clk=0;
	wire [(DATA_WIDTH-1):0]q;
	reg [(DATA_WIDTH-1):0]data;
	reg en;
	reg mem_sel;

MemoryUnit
#(
	.DATA_WIDTH(DATA_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH)
)duv_mem
(
	.addr(addr),//program counter
	.wdata(data),
	.we(en),
	.clk(clk),
	.mem_sel(mem_sel),
	.q(q)	
);

initial begin
	forever #1 clk=!clk;
end

initial begin
	mem_sel=1'b0;
	//############# ROM test ###############	
	#5 mem_sel=1'b0;		//select rom memory
	data = 32'd2;			//this will not take effect for ROM 
	#0 addr=32'd0; 			//fetch add 0
	#15 addr=32'd1;			//fetch add 1
	#15 addr=32'd2;			//fetch add 2
	en =0;

	#15 addr =0;
	//########## RAM test ##################	
	mem_sel=1'b1;		//select ram memory	
	
	en =1;
	data = 32'd1;

	#6 addr =5;
	data = 32'd5;
	#1 addr = 5;
	data = 32'd6;	//This will skip the data 5
	#3	
	data = 32'd7;	//see if the data written to RAM changes
	#3 en =0;
	data = 32'd8;	//see if the data written to RAM changes

	//Read from a new address
	#3 addr = 6;

end

endmodule