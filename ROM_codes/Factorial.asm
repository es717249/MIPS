.text
main:
	lui	$sp,0x1001
	ori	$sp,$sp,0x0100
	addi $a0,$a0,9 # Loading constant
	jal Factorial # Calling procedure
	j Exit	# Jump to Main label
	
Factorial:
	slti $t0, $a0, 1 # if n = 1
	beq $t0, $zero, Loop # Branch to Loop
	addi $v0, $zero, 1 # Loading 1
	jr $ra # Return to the caller	
Loop:	
	addi $sp, $sp,-8 # Decreasing the stack pointer
	sw $ra 4($sp) # Storing n
	sw $a0, 0($sp) #  Storing the resturn address
	addi $a0, $a0, -1 # Decreasing n
	jal Factorial # recursive function
	lw $a0, 0($sp) # Loading values from stak
	lw $ra, 4($sp) # Loading values from stak
	addi $sp, $sp, 8 # Increasing stack pointer
	mult $a0, $v0 # Multiplying n*Factorial(n-1)
	mflo $v0
	jr $ra  # Return to the caller
Exit:
	addi $v0,$v0,0
	lui $s0,0x1001
	ori $s0,$s0,0x0024
	sw  $v0,0($s0)
