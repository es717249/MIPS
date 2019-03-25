.text
Main:
	lui $s0,0x1001
	ori $s1,$s0,0x0024
	addi $s2,$zero,1
	addi $s3,$s3,8
loop:
	sw $s2,0($s1)
	sll $s2,$s2,1
	addi,$s3,$s3,-1
	bne $s3,$zero, loop
exit: