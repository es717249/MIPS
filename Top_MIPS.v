module Top_MIPS #(
    parameter DATA_WIDTH=32,	/* length of data */
    parameter ADDR_WIDTH=8 		/* bits to address the elements */
)
(
    /* inputs */
    input clk_sys, 					/* MIPS clk signal - 50MHz*/
	input reset, 				/* async signal to reset */	
    input enable,                /* enable signal */	
    input SerialDataIn, //it's the input data port 
    /* outputs */
    output [7:0]leds,            /* output leds */    
    output [7:0] uartdata,
    output SerialDataOut,
    output happylight,           /* alive clk signal */
    output Rx_flag  //indicates the data was completely received 
);

wire [2:0] counter /*synthesis keep*/; 		/* 7 states */
wire flag;
/* Clock generator signals */
wire flag_clk1/*synthesis keep*/;
wire pll_clk;
wire pll_locked;


assign happylight = flag_clk1;


MIPS_new#(
    .DATA_WIDTH(DATA_WIDTH),/* length of data */
    .ADDR_WIDTH(ADDR_WIDTH)/* bits to address the elements */
)testing_unit
(
	.clk(clk_sys), 				        /* clk signal */
	.reset(reset), 			        /* async signal to reset */
	/* Test signals */
    .SerialDataIn(SerialDataIn),
    .Rx_flag(Rx_flag),
    .DataRx_out(uartdata),
    .SerialDataOut(SerialDataOut),
    .gpio_data_out(leds)
);


pll2 samplingclk(
        .refclk(clk_sys),   //  refclk.clk
		.rst(reset),      //   reset.reset
		.outclk_0(pll_clk) // outclk0.clk		
);
/* Generate 1s clock  */

ClockGen #(
	// Parameter Declarations
    .MAXIMUM_VALUE(32'd50000000)	
)clock_1s
(
	// Input Ports
	.clk(clk_sys),
	.reset(reset),
    .enable(enable),
	.flag(flag_clk1)
);



endmodule