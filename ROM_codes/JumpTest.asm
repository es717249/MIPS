.text
	add $s0, $s0,0	# Loading constant
	add $s1, $s1,2	# Loading constant

while:

	beq $s0,$s1, exit	# Branch if equal
	addi $s0,$s0,1		# Set rt (t0) if rs(s0) < imm (s0)
	j while			# Jumping to while label
exit:
	add $s1,$s1,1	#increment s1 only to test the end of jump instruction
