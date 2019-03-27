/*Testing MIPS_new:
    
    Simulation with modelsim:
    vsim -voptargs=+acc=npr

    Testing the following code in file: Test_MIPS_1inst.asm, and using Test_MIPS_1inst.hex
*/
module MIPS_new_TB;

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
    //.count_state(state)
    .count_state(counter)
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
    #0  reset=1'b0;
    #0  enable =1'b0;
    #10 reset =1'b1;
    #0  enable =1'b1;
    
    // ################### Testing add, addi, & sll instructions ################### //

    #0 state=0;    //IDLE

    /* Processing instruction 21080003: addi $t0,$t0,0x03 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE

    /* Processing instruction 21290003: addi $t1,$t1,0x03 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE


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
    #20 state=5;    //DUMMY STATE


    /* If beq was selected to branch, do not uncomment the following 2 cycles, otherwise uncomment */
    //################################## begin
//    #20 state=1;    //FETCH
//    #20 state=2;    //DECODE
//    #20 state=3;    //EXECUTE
//    #20 state=4;    //WRITE BACK
//    #20 state=5;    //DUMMY STATE

//    #20 state=1;    //FETCH
//    #20 state=2;    //DECODE
//    #20 state=3;    //EXECUTE
//    #20 state=4;    //WRITE BACK
//    #20 state=5;    //DUMMY STATE
    //##################################  end 

    /* Processing instruction 3c101001: lui $s0,0x1001 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE

    /* Processing instruction 21080001: addi $t0,$t0,0x01 = 3+1 = 4*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE
    /* Check at this point that the Register File has in RD1 and RD2 the desired value */
    
    /* Processing instruction 21290004: addi $t1,$t1,0x04 = 3+4=7, or 3+3=6 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE
    
    /* Processing instruction 214a000a: addi $t2,$t2,0x0A , store 0xA*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE

    /* Processing instruction 216b00ff: addi $t3,$t3,0xFF ,store 0xFF*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE

    /* Processing instruction 3c0c1001: lui $t4,0x1001 ,store 0x10010000*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE
    
    /* Processing instruction 218c0000: addi $t4,$t4,0x0 ,store  0x10010000*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE  


    /* Processing instruction 01288820: add $s1,$t1,$t0 = 7+4 =B, or 6+4=A*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE

    /* Processing instruction 022a9020: add $s2,$s1,$t2 = B+A=15h, or A+A=14h*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE

    /* Processing instruction 00118880: sll $s1,$s1,0x02 = B<<2 (11x4=2c), or A<<2 (10x4=28) */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE

    /* Processing instruction 022a9025: or $s2,$s1,$t2 = 2C|A= 0x2E, or 28|A= 0x2A  */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE

    /* Processing instruction 325300f0: andi $s3,$s2,0xF0 = 0x2E & 0xF0 =0x20, or  0x2A & 0xF0 =0x20 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE
    /* The result will not be seen at this point */

    // ################### Testing store and load instructions ################### //
    /* Processing instruction ad910000: sw $s1,0,($t4) : store 0x2C or 0x28 in 0x10010000+0*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //STORE
    #20 state=5;    //STORE DUMMY

    /* Processing instruction ad920004: sw $s2,4,($t4) : store 0x2E or 0x2A in 0x10010000+4*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //STORE
    #20 state=5;    //STORE DUMMY

    /* Processing instruction ad930008: sw $s3,8,($t4) : store 0x20 in 0x10010000+8*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //STORE
    #20 state=5;    //STORE DUMMY

    /* Processing instruction ad8b000c: sw $t3,12,($t4) : store 0xFF in 0x10010000+C */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //STORE
    #20 state=5;    //STORE DUMMY
    
    /* Processing instruction 8d940000: lw  $s4,0,($t4) : load 20d in 0x10010000+4*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //LOAD
    #20 state=5;    //LOAD DUMMY
    
    
    /* Processing instruction 8d950004: lw  $s5,4,($t4) :load 0x1E in 0x10010000+8*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //LOAD
    #20 state=5;    //LOAD DUMMY
    
    /* Processing instruction 8d960008: lw  $s6,8,($t4) :load 0x10 in 0x10010000+C*/
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //GET EFFECTIVE ADDRESS
    #20 state=4;    //LOAD
    #20 state=5;    //LOAD DUMMY

    //Verify content of RAM

    /* Processing instruction 22940000: addi $s4,$s4,0x00 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE
    /* Processing instruction 22940001: addi $s4,$s4,0x01 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE

    /* Processing instruction 22b50000: addi $s5,$s5,0x00 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE
    /* Processing instruction 22b50001: addi $s5,$s5,0x01 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE

    /* Processing instruction 22d60000: addi $s6,$s6,0x00 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE
    /* Processing instruction 22d60001: addi $s6,$s6,0x01 */
    #20 state=1;    //FETCH
    #20 state=2;    //DECODE
    #20 state=3;    //EXECUTE
    #20 state=4;    //WRITE BACK
    #20 state=5;    //DUMMY STATE

end 

endmodule