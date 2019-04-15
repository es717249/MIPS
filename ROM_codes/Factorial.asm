.text

	#The instruction to read uart is: 0x1A100000

main:
	#Initializing stack pointer
	lui	$sp,0x1001
	ori	$sp,$sp,0x0100
	#0x1A100000
	#Initialize for storing Uart Rx data
	lui $t0,0x1001
	ori $t0,$t0,0x0028
	#Initialize for cleaning Uart Rx flag
	lui $t1,0x1001
	ori $t1,$t1,0x0029	
	#Initialize for Storing data in Uart Tx buffer
	lui $t3,0x1001
	ori $t3,$t3,0x002C
	#Initialize for Starting Uart Tx Transmission
	lui $t4,0x1001
	ori $t4,$t4,0x002E
	#Initialize for Cleaning Uart Tx flag
	lui $t5,0x1001
	ori $t5,$t5,0x002D

	#Keep checking while not receiving uart data
wait_uartrx:
	#UART RX flag will be stored in $0
	addi $s0,$s0,0			#this will be replaced by instruction: 0x1A100001 - read_Uart. Opcode 6 
	andi $zero,$zero,0		#workaround, need to be fixed. It's written 
	beq  $s0,$zero,wait_uartrx
#save data from uart
get_uart:
	lw $a0,0($t0)		#From address 0x10010028  UART RX	
	#clean rx flag from uart
	addi $s1,$s1,0
	sw $s1,0($t1)		#write to 0x10010029 to clean rx flag
	jal Factorial 		# Calling procedure
	j Send_to_Tx				# Jump to Main label
	
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
Send_to_Tx:
	#see the result in V0 register
	addi $v0,$v0,0
	sw $v0, 0($t3)			#Save any number in Tx buffer
	#Send start bit
	addi $s1,$s1,1			#Send start bit
	sw $s1, 0($t4)			#Send start bit
	#Wait till the transmission is done 
wait_txdone:
	addi $s0,$s0,0			#This will be replaced by: 0x1C100000, target $s0. Tx_flag will be stored in $s0
	andi $zero,$zero,0		#workaround, need to be fixed. It's written 
	beq  $s0,$zero,wait_txdone	#go again to wait_txdone
#Clean the Tx flag
	andi $s1,$s1,0
	sw $s1,0($t5)		#Clean the Tx flag
	

	#Send the data to the leds @TODO: pending to verify
		#lui $s3,0x1001
		#ori $s3,$s3,0x0024
		#sw $s0,0($s3)	#write the data to the leds
	andi $s0,$s0,0
	j wait_uartrx
	
