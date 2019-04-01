// Quartus II Verilog Template
// Single Port ROM

/* 
Description: It can read instantaneously the content of ROM for the given addr
	The content of RAM can be read as well 
 */

module MemoryUnit
#
(
	parameter DATA_WIDTH=32, 		//data length
	//parameter ADDR_WIDTH=8			//bits to address the elements
	parameter ADDR_WIDTH=6			//bits to address the elements
)
(
	//inputs
	//input [(DATA_WIDTH-1):0] addr,	//Address for rom instruction mem. Program counter
	input [(ADDR_WIDTH-1):0] addr,	//Address for rom instruction mem. Program counter
	input [(DATA_WIDTH-1):0] wdata,	//Write Data for RAM data memory
	input we,						//Write enable signal - sw9
	input clk, 						//sw8
	input mem_sel,					//Select either rom or ram  -sw7
	//output
	output [(DATA_WIDTH-1):0] q
);

	// Declare the ROM variable
	reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0]; 

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	//reg [DATA_WIDTH-1:0] ram[2**8-1:0];
	
	wire [DATA_WIDTH-1:0]	q_rom;		//wire to redirect ROM value to the output
	wire [DATA_WIDTH-1:0]	q_ram;		//wire to redirect RAM value to the output
	
	reg [(DATA_WIDTH-1):0] 	data_temp;


	// Initialize the ROM with $readmemb.  Put the memory contents
	// in the file single_port_rom_init.txt.  Without this file, this design will not compile.

	initial   //no es sintetizable pero le ayuda al sintetizador para inferir una memoria rom y para inicializarla
	begin		
		//$readmemh("Test_MIPS_1inst.hex", rom);	//Test1: instructions R,I,SW,LW,BEQ,BNE
		//$readmemh("Test_MIPS_jump.hex", rom);		//Test2: instructions jump
		//$readmemh("Test_MIPS_SW_LW.hex", rom);	//Test3: instructions sw, lw
		//$readmemh("testmem.hex", rom);	//Test4: memory
		//$readmemh("Test_S0.hex", rom);	//Test5: few instructions
		//$readmemh("Test_slti.hex", rom);	//Test6: slti instruction
		//$readmemh("Test_mult.hex", rom);	//Test7: mult instruction
		$readmemh("Test_jr.hex", rom);	//Test8: jr instruction

	end

	always @ (posedge clk)
	begin
		//data_temp <= data; //registra la dirección de lectura
		// Write
		if (we)
			data_temp <= wdata; //registra la dirección de lectura
			//ram[addr] <= data_temp;		
	end

	/* Write to RAM memory at the given address (addr) with the given data (data_temp)*/
//	always@(data_temp,addr)begin
//		ram[addr] <= data_temp;		
//	end
	
	always@(posedge clk)begin
		if(we)
			ram[addr] <= wdata;		
	end
	

	/* Continuous assigment implies read returns new data */
	assign q_ram = ram[addr];	
	assign q_rom = rom[addr];	
		
	/* Mux to steer the data (ROM/RAM) to the output */
	mux2to1
	#(
		.Nbit(DATA_WIDTH)
	)mux_mems
	(
		.mux_sel(mem_sel),
		.data1(q_rom),
		.data2(q_ram),
		.Data_out(q)
	);


endmodule
