// Quartus II Verilog Template
// Single Port ROM

module single_port_rom
#
(
	parameter DATA_WIDTH=32, 
	parameter ADDR_WIDTH=8
)
(
	input [(ADDR_WIDTH-1):0] addr,//for rom instruction mem. Program counter
	input [(DATA_WIDTH-1):0] data,//for ram data mem
	input we,
	input clk, 
	//output reg [(DATA_WIDTH-1):0] q
	output [(DATA_WIDTH-1):0] q
);

	// Declare the ROM variable
	reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0]; 
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	// Variable to hold the registered read address
	reg [ADDR_WIDTH-1:0] addr_logic;

	// Initialize the ROM with $readmemb.  Put the memory contents
	// in the file single_port_rom_init.txt.  Without this file,
	// this design will not compile.

	initial   //no es sintetizable pero le ayuda al sintetizador para inferir una memoria rom y para inicializarla
	begin
		$readmemh("rom_values_init.hex", rom);
	end

	assign q = rom[addr];
	/*
	always@ (posedge clk)
	begin
		q <= rom[addr];
	end
	*/


/*	always @(posedge clk) begin
		if(we)
			ram[addr] <= data;
			q <= ram[addr]; //registra la dirección de lectura
	end*/

	
endmodule
//21080001