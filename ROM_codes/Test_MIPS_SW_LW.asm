.text 

	add $t0,$t0,0x03
	lui $s0,0x1001	
	addi $s0,$s0,0x00
	
	sw  $t0,0,($s0)		#store 3 in 0x10010001
	lw  $s1,0,($s0)		#load $s0 in $s1
	
	addi $s1,$s1,0

#Writing to GPIO	
	lui $s2,0x1001	
	addi $s2,$s2,0x24
	
	sw $t0,0,($s2)
	
	