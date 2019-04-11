.text 

#The instruction to read uart is: 0x1A100000
	#save the bit in $s0
	lui $t0,0x1001
	ori $t0,$t0,0x0029
	lui $t1,0x1001
	ori $t1,$t1,0x0028
wait_uartrx:
	addi $s0,$s0,0	#this will be replaced by instruction: 0x1A100001 - read_Uart
	beq  $s0,$zero,wait_uartrx
get_uart:
	#save data from uart
	lw $s2,0($t1)
	addi $s2,$s2,1
	#clean rx flag from uart
	addi $s1,$s1,0
	sw $s1,0($t0)
	addi $s1,$s1,1
