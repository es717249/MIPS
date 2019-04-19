.text
Main: 
	lui $s0,0x1001		#store gpio addr
	ori $s1,$s0,0x0024	#store gpio addr
	addi $s2, $zero, 1	#initial value to store in gpio
	addi $s3, $s3, 8	#save number of loops
	
loop:
	sw $s2, 0($s1)	#Starting "loop"
	sll $s2, $s2,1
	addi $s3,$s3,-1
	bne $s3,$zero,loop #branch to "loop"
exit:
