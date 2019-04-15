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
	#Initialize for Starting Uart Tx Transmission
	lui $t2,0x1001
	ori $t2,$t2,0x002E
	#Initialize for Storing data in Uart Tx buffer
	lui $t3,0x1001
	ori $t3,$t3,0x002C
	lui $t4,0x1001
	ori $t4,$t4,0x002D
	
	#Keep checking while not receiving uart data
wait_uartrx:
	#The rs will be selected 
	addi $s0,$s0,0	#this will be replaced by instruction: 0x1A100001 - read_Uart. Opcode 6 
	andi $zero,$zero,0		#workaround, need to be fixed. It's written 
	beq  $s0,$zero,wait_uartrx
#save data from uart
get_uart:
	lw $a0,0($t1)		#From address 0x10010028  UART RX
	#addi $a0,$a0,9 # Loading constant
	#clean rx flag from uart
	addi $s1,$s1,0
	sw $s1,0($t0)
	
	#Save any number in Tx buffer
	addi $s3,$s3,0x12345678			#Save any number in Tx buffer
	sw $s3, 0($t3)			#Save any number in Tx buffer
	#Send start bit
	addi $s1,$s1,1			#Send start bit
	sw $s1, 0($t2)			#Send start bit
	#Wait till the transmission is done 
wait_txdone:
	#
	addi $s0,$s0,0		#This will be replaced by: 0x1C100000, target $s0. Tx_flag will be stored in $s0
	andi $zero,$zero,0		#workaround, need to be fixed. It's written 
	beq  $s0,$zero,wait_txdone	#go again to wait_txdone
	#Clean the Tx flag
	andi $s1,$s1,0
	sw $s1,0($t4)		#Clean the Tx flag
	
	

	
