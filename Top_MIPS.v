module Top_MIPS #(
    parameter DATA_WIDTH=32,	/* length of data */
    parameter ADDR_WIDTH=8 		/* bits to address the elements */
)
(
    /* inputs */
    input clk, 					/* MIPS clk signal - 50MHz*/
	input reset, 				/* async signal to reset */	
    input enable,                /* enable signal */	
    /* outputs */
    output [7:0]leds,            /* output leds */
    output happylight           /* alive clk signal */
);

wire [2:0] counter; 		/* 7 states */
wire flag;
/* Clock generator signals */
wire flag_clk1;
wire flag_clk2;

assign happylight = flag_clk1;

MIPS_new#(
    .DATA_WIDTH(DATA_WIDTH),/* length of data */
    .ADDR_WIDTH(ADDR_WIDTH)/* bits to address the elements */
)testing_unit
(
	.clk(clk), 				        /* clk signal */
	.reset(reset), 			        /* async signal to reset */
	/* Test signals */    
    .count_state(counter),
    .gpio_data_out(leds)
);

CounterwFlag_P #(
	// Parameter Declarations
    .MAXIMUM_VALUE(4'd6)	
)machine_cycle_cnt
(
	// Input Ports
	.clk(flag_clk2),
	.reset(reset),
    .enable(enable),
	.flag(flag),
    .counter(counter)
);

/* Generate 2s clock  */

ClockGen #(
	// Parameter Declarations
    .MAXIMUM_VALUE(32'd50000000)	
)clock_1s
(
	// Input Ports
	.clk(clk),
	.reset(reset),
    .enable(enable),
	.flag(flag_clk1)
);

ClockGen #(
	// Parameter Declarations
    .MAXIMUM_VALUE(2)	
)clock_2s
(
	// Input Ports
	.clk(flag_clk1),
	.reset(reset),
    .enable(enable),
	.flag(flag_clk2)
);

endmodule