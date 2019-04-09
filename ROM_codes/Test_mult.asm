.text 
	addi $s0,$s0,7
	add $s0,$s0,2
	add $t1,$t1,4
	mult $s0,$t1
	mflo $t2
	addi $t2,$t2,1
	#save to gpio unit
	lui $t3,0x1001
	ori $t4,$t3,0x0024
	addi $t5,$t5,7	
	sw $t2,0($t4)
	#sw $t5,0($t4)
