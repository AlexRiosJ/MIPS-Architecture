#lw/sw test
.text
	addi $s1, $zero, 0x1001
	sll $s1, $s1, 16
	addi $t0, $zero, 5
	sw $t0, 0($s1)
	lw $t1, 0($s1)
