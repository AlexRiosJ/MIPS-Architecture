#JR test
addi $t0, $zero, 1
jal TEST
addi $t0, $zero, 3
j Exit
TEST:
addi $t0, $zero, 2
jr $ra
Exit:
