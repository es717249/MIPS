.text
main:
	addi $a0,$a0,2 # Loading constant
	jal Factorial # Calling procedure
	j Exit	# Jump to Main label
	
Factorial:
	addi $ra,$ra,0
	addi $a0, $a0, 1 # Factorial: if n = 1
	jr $ra # Return to the caller	
Exit:
	addi $a0,$a0,1	#in Exit