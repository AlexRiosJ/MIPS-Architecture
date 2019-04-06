#beq test
addi $t1, $zero, 0
beq $t1,$zero beqWORKS
addi $t1, $zero, 1 #si t1 llega a ser 1, no hizo branch
beqWORKS:
