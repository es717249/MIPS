.text 
    add $t0,$t0,0x03
    add $t1,$t1,0x03

    #load addr 0x10010024 - GPIO addr
    lui $s0,0x1001
	addi $s0,$s0,0x24

    lui $s1,0x1001
	addi $s1,$s1,0x28

    lui $s2,0x1001
	addi $s2,$s2,0x2C

    
