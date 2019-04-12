.text

	#The instruction to read uart is: 0x1A100000

main:
	lui	$sp,0x1001
	ori	$sp,$sp,0x0100
	#0x1A100000
	#Initialize for cleaning Uart Rx flag
	lui $t0,0x1001
	ori $t0,$t0,0x0029
	#Initialize for storing Uart Rx data
	lui $t1,0x1001
	ori $t1,$t1,0x0028
	#Keep checking while not receiving uart data
wait_uartrx:
	addi $s0,$s0,0	#this will be replaced by instruction: 0x1A100001 - read_Uart
	andi $zero,$zero,0
	beq  $s0,$zero,wait_uartrx
#save data from uart
get_uart:
	lw $a0,0($t1)		#From address 0x10010028  UART RX
	#addi $a0,$a0,9 # Loading constant
	#clean rx flag from uart
	addi $s1,$s1,0
	sw $s1,0($t0)
	jal Factorial # Calling procedure
	j Exit	# Jump to Main label
	
Factorial:
	slti $t2, $a0, 1 # if n = 1
	beq $t2, $zero, Loop # Branch to Loop
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
	#see the result in V0 register
	addi $v0,$v0,0
#	andi $s0,$s0,0	#clean the S0 register
	#Send the data to the leds 
	lui $s3,0x1001
	ori $s3,$s3,0x0024
	sw $s0,0($s3)	#write the data to the leds
		
	j wait_uartrx
	#lui $s2,0x1001
	#ori $s2,$s2,0x0024
	#sw  $v0,0($s2)
