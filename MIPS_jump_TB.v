/* Test for jump instructions 
        
    Simulation with modelsim:
    vsim -voptargs=+acc=npr

    Testing the following code in file: JumpTest.asm, and using Test_MIPS_jump.hex
*/
module MIPS_jump_TB;

    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 8;
    localparam MAXIMUM_VALUE = 4'd6;
	reg clk=0; 				        /* clk signal */
	reg reset=0; 			        /* async signal to reset */
    reg enable=0;                   /* enable signal for start of operation */
	/* Test signals */
    reg [3:0]state;
    wire flag;
    wire[2:0] counter;
    wire [7:0] gpio_data_out;
    
MIPS_new#(
    .DATA_WIDTH(DATA_WIDTH),/* length of data */
    .ADDR_WIDTH(ADDR_WIDTH)/* bits to address the elements */
)testing_unit
(
	.clk(clk), 				        /* clk signal */
	.reset(reset), 			        /* async signal to reset */
	/* Test signals */
    //.count_state(state)
    .count_state(counter),
    .gpio_data_out(gpio_data_out)
);

CounterwFlag_P 
#(
	// Parameter Declarations
    .MAXIMUM_VALUE(MAXIMUM_VALUE)	
)machine_cycle_cnt
(
	// Input Ports
	.clk(clk),
	.reset(reset),
    .enable(enable),
	.flag(flag),
    .counter(counter)
);

initial begin
 	forever #10 clk=!clk;
end

initial begin 
    /* Beginning of simulation */
    #0 reset=1'b0;
    #0  enable =1'b0;
    #10 reset =1'b1;
    #0  enable =1'b1;

    /* Processing instruction 22100000: add $s0, $s0,0	# Loading constant */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE

    /* Processing instruction 22310005: add $s1, $s1,5	# Loading constant */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE
        
    /* Processing instruction 12110002: beq $s0,$s1, exit	# Branch if equal */
    //beq 0
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE
    
    /* Processing instruction 22100001: addi $s0,$s0,1		# Set rt (t0) if rs(s0) < imm (s0) */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE
    

    /* Processing instruction 08100002: j while	    # Jumping to while label    */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //UPDATEPC
    #20 state=5;    //DUMMY STATE

    //beq 1
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //UPDATEPC
    #20 state=5;    //DUMMY STATE
    //add
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //UPDATEPC
    #20 state=5;    //DUMMY STATE
    //jump
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //UPDATEPC
    #20 state=5;    //DUMMY STATE
    //beq 2
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //UPDATEPC
    #20 state=5;    //DUMMY STATE
    //add
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //UPDATEPC
    #20 state=5;    //DUMMY STATE
    //jump
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //UPDATEPC
    #20 state=5;    //DUMMY STATE
    
    #20 state=1;    //FETCH
end 

endmodule