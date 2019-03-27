/*Testing MIPS_new:
    
    Simulation with modelsim:
    vsim -voptargs=+acc=npr

    Testing the following code in file: Test_MIPS_1inst.asm, and using Test_MIPS_1inst.hex
*/
module MIPS_swlw_TB;

    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 32;
	reg clk=0; 				        /* clk signal */
	reg reset; 			            /* async signal to reset */
	/* Test signals */
    reg [3:0]state;
    
MIPS_new
#
(
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
    
    // ################### Testing add, addi, & sll instructions ################### //

    #0 state=0;    //IDLE

    /* Processing instruction 21080003: addi $t0,$t0,0x03 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

    /* Processing instruction 3c101001: lui $s0,0x1001 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

    /* Processing instruction 22100001: addi $t0,$t0,0x01 = 3+1 = 4*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    
    /* Check at this point that the Register File has in RD1 and RD2 the desired value */
    
    
    /* Processing instruction ae080000: sw $s1,0,($t4) : store 0x2C or 0x28 in 0x10010000+0*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //STORE
    #20 state=5;    //STORE DUMMY

       
    /* Processing instruction 8e110000: lw  $s4,0,($t4) : load 20d in 0x10010000+4*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //LOAD
    #20 state=5;    //LOAD DUMMY
    
    /* Processing instruction 22310000: addi $s6,$s6,0x01 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

end 

endmodule