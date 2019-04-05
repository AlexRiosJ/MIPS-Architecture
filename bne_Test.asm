#BNE test
addi $t0, $zero, 2
bne $t0,$zero bneWORKS
addi $t0, $zero, 1 #si t1 llega a ser 1, no hizo branch
bneWORKS:
