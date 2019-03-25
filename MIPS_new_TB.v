/*Testing MIPS_new:
    
    Simulation with modelsim:
    vsim -voptargs=+acc=npr

    Testing the following code in file: Test_MIPS_1inst.asm, and using Test_MIPS_1inst.hex
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
    
    // ################### Testing add, addi, & sll instructions ################### //

    #0 state=0;    //IDLE

    /* Processing instruction 21080003: addi $t0,$t0,0x03 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

    /* Processing instruction 21290003: addi $t1,$t1,0x04 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK


    /* Processing instruction 11090002: beq $8,$9,x02
    - To test this change the previous instructions(in .hex file), so the registers have the same values*/
    
    /*  OR */

    /* Processing instruction 15090002: bne $8,$9,x02
    - To test this change the previous instructions(in .hex file), so the registers have the same values
    */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK


    /* If beq was selected to branch, do not uncomment the following 2 cycles, otherwise uncomment */
    //################################## begin
//    #20 state=1;    //FETCH
//    #20 state=2;    //DECODE
//    #20 state=3;    //EXECUTE
//    #20 state=4;    //WRITE BACK

//    #20 state=1;    //FETCH
//    #20 state=2;    //DECODE
//    #20 state=3;    //EXECUTE
//    #20 state=4;    //WRITE BACK
    //##################################  end 

    /* Processing instruction : lui $s0,0x1001 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

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
    
    /* Processing instruction 01288820: add $s1,$t1,$t0 = 4+1*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

    /* Processing instruction 022a9020: add $s2,$s1,$t2 = 5+A*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

    /* Processing instruction 00118880: sll $s1,$s1,0x02 = 5<<2, 5x4*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

    /* Processing instruction 022a9025: or $s2,$s1,$t2 = 20d|A = 0x1E */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

    /* Processing instruction 325300f0: andi $s3,$s2,0xF0 = 0x1E & 0xF0 =0x10 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK

    // ################### Testing store and load instructions ################### //
    /* Processing instruction ad910000: sw $s1,0,($t4) : store 0x14 in 0x02*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //STORE

    /* Processing instruction ad920004: sw $s2,4,($t4) : store 0x1E in 0x02+4*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //STORE

    /* Processing instruction ad930008: sw $s3,8,($t4) : store 0x10 in 0x02+8*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //STORE

    /* Processing instruction ad8b000c: sw $t3,12,($t4) : store 0xFF in 0x02+C */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //STORE
    
    /* Processing instruction 8d940000: lw  $s4,0,($t4) : load 20d in 0x02+4*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //LOAD
    
    /* Processing instruction 8d950004: lw  $s5,4,($t4) :load 0x1E in 0x02+8*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //LOAD
    
    /* Processing instruction 8d960008: lw  $s6,8,($t4) :load 0x10 in 0x02+C*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //LOAD


end 

endmodule