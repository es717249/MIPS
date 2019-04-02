.text
	lui	$t0,0x40
	addi	$t0,$t0,0x08
main:
	addi	$a0,$0,6		#m=6	base 
	addi	$a1,$0,6		#n=6	power
	add	$a0,$a1,$a0
	addi	$a0,$a0,1
	addi	$a0,$a0,1
	addi	$a0,$a0,1
jump2:
	jr	$t0
