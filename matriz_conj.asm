.text
	addi $a0, $zero, 0x1001
	sll $a0, $a0, 16
	addi $a1, $zero, 1
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, -3
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 5
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 7
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 9
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 0
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 2
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, -4
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 6
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 8
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 1
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 3
	sw $a1, ($a0)

	addi $a0, $a0, 4
	addi $a1, $zero, -1
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 0
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 1
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 0
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 0
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 0
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, -5
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 7
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 9
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 0
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 1
	sw $a1, ($a0)
	
	addi $a0, $a0, 4
	addi $a1, $zero, 0
	sw $a1, ($a0)

	addi $s0, $zero, 0x1001
	sll $s0, $s0, 16
	add $s1, $s0, 0x60
		
	add $t0, $zero, $zero
	add $t1, $zero, $zero
	addi $t2, $zero, 4 # Dest Width
	addi $t3, $zero, 3 # Dest Height
	
	addi $t9, $zero, -1
	
	for_i:
		beq $t0, $t2, end_for_i
		for_j:
			beq $t1, $t3, end_for_j
			add $t4, $zero, $t0
			add $t4, $t4, $t0
			add $t4, $t4, $t0
			add $t4, $t4, $t1
			sll $t4, $t4, 3
			
			add $t5, $zero, $t1
			add $t5, $t5, $t1
			add $t5, $t5, $t1
			add $t5, $t5, $t1
			add $t5, $t5, $t0
			sll $t5, $t5, 3
			
			add $t6, $s0, $t4
			add $t8, $s1, $t5
			
			lw $t7, 0($t6)
			sw $t7, 0($t8)
			
			lw $t7, 4($t6)
			not $t7, $t7
			addi $t7, $t7, 1
			sw $t7, 4($t8)
			
			addi $t1, $t1, 1
			beq $zero, $zero, for_j
		end_for_j:
		add $t1, $zero, $zero
		addi $t0, $t0, 1
		beq $zero, $zero, for_i
	end_for_i:
	bne $t1, $t9, exit
exit:
	
