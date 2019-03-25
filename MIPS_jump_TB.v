/* Test for jump instructions 
        
    Simulation with modelsim:
    vsim -voptargs=+acc=npr

    Testing the following code in file: JumpTest.asm, and using Test_MIPS_jump.hex
*/
module MIPS_jump_TB;

localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 8;
	reg clk=0; 				        /* clk signal */
	reg reset; 			            /* async signal to reset */
	/* Test signals */
    reg [3:0]state;
    
MIPS_new#(
    .DATA_WIDTH(DATA_WIDTH),/* length of data */
    .ADDR_WIDTH(ADDR_WIDTH)/* bits to address the elements */
)testing_unit
(
	.clk(clk), 				        /* clk signal */
	.reset(reset), 			        /* async signal to reset */
	/* Test signals */
    .count_state(state)
);


initial begin
 	forever #10 clk=!clk;
end

initial begin 
    /* Beginning of simulation */
    #0 reset=1'b0;
    #10 reset =1'b1;

    /* Processing instruction 22100000: add $s0, $s0,0	# Loading constant */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

    /* Processing instruction 22310005: add $s1, $s1,5	# Loading constant */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
        
    /* Processing instruction 12110002: beq $s0,$s1, exit	# Branch if equal */
    //beq 0
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    
    /* Processing instruction 22100001: addi $s0,$s0,1		# Set rt (t0) if rs(s0) < imm (s0) */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

    /* Processing instruction 08100002: j while	    # Jumping to while label    */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //UPDATEPC

    //beq 1
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //UPDATEPC
    //add
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //UPDATEPC
    //jump
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //UPDATEPC
    //beq 2
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //UPDATEPC
    //add
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //UPDATEPC
    //jump
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //UPDATEPC
    
    #20 state=1;    //FETCH
end 

endmodule