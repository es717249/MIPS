.text 

	add $t0,$t0,0x03
	lui $s0,0x1001
	ori $s0,$s0,0x0000
	
	sw  $t0,0,($s0)		#store 3 in 0x10010001
	lw  $s1,0,($s0)		#load $s0 in $s1
	
	addi $s1,$s1,0

#Writing to GPIO	
	lui $s2,0x1001
	ori $s2,$s2,0x0024
	
	sw $t0,0,($s2)
	
	
