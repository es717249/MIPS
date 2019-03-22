/*Testing MIPS_new this version tests:
    Instruction preparation module
    RegFile module
    ALU module
    Memory unit
    Manually introducing the instruction , data and control signals
*/
module MIPS_new_TB;

    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 8;
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
    
    #0 state=0;    //IDLE
    /* Processing instruction 21080001: addi $t0,$t0,0x01 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    /* Check at this point that the Register File has in RD1 and RD2 the desired value */
    
    /* Processing instruction 21290004: addi $t1,$t1,0x04 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    
    /* Processing instruction 214a000a: addi $t2,$t2,0x0A */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

    /* Processing instruction 216b00ff: addi $t3,$t3,0xFF */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

    /* Processing instruction 218c0002: addi $t4,$t4,0x02 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    
    /* Processing instruction 01288820: add $s1,$t1,$t0*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

    /* Processing instruction 022a9020: add $s2,$s1,$t2 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK


end 

endmodule