.text 

	add $t0,$t0,0x03
	add $t1,$t1,0x03
	beq $t0,$t1, main	# Branch if equal
	addi $t0,$t0,0x07
	addi $t1,$t1,0x07
		# Jumping to while label
main:
##############################
	lui $s0,0x1001	
	add $t0,$t0,0x01
	add $t1,$t1,0x04
	add $t2,$t2,0x0A
	add $t3,$t3,0xFF
	lui $t4,0x1001
#	addi $t4,$t4,0x24
	addi $t4,$t4,0x00

	add $s1,$t1,$t0	 #t0+t1 =1+4
	add $s2,$s1,$t2	 #5+A = F
	sll $s1,$s1,0x02 #5<<2 = 20d
	or  $s2,$s1,$t2	 #(20d | A)=1E
	andi $s3,$s2,0xF0 #1E & F0 = 10
	sw  $s1,0,($t4)	#20d,--> 0x02%4
	sw  $s2,4,($t4)	#0x1E,--> (0x02+4)%4
	sw  $s3,8,($t4)	#0x10,--> (0x02+8)%4
	sw  $t3,12,($t4)	#0xFF,--> (0x02+C)%4
	
	lw  $s4,0,($t4)
	lw  $s5,4,($t4)
	lw  $s6,8,($t4)
	
	addi $s4,$s4,0
	addi $s4,$s4,1
	addi $s5,$s5,0
	addi $s5,$s5,1	
	addi $s6,$s6,0	
	addi $s6,$s6,1
