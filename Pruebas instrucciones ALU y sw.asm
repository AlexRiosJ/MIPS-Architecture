.text
addi $s0,$zero,8
addi $s1,$zero,3

andi $s2,$zero,8
ori  $s2,$zero,8
lui  $s2,10
sll  $s2,$s0,1
srl  $s2,$s0,1

add $zero,$zero,$zero



addi $s0, $zero, 11
addi $s1, $zero, 10
addi $s2, $zero, 1
label:
sub $s0, $s0, $s2

and  $s2,$s0,$s1
or   $s2,$s0,$s1
nor  $s2,$s0,$s1
add  $s2,$s0,$s1
sub  $s2,$zero,$s0
beq  $s0, $s1, label

addi $s0, $zero, 8 # Number of disks
add $s1, $zero, $zero
addi $s1, $s1, 0x1001
sll $s1, $s1, 16 # Save address of tower A
addi $s2, $s1, 0x20 # Save address of tower B
addi $s3, $s2, 0x20 # Save address of tower C
add $t0, $s0, $zero

beq $t0, $zero, end_for
sw $t0, ($s1)
addi $s1, $s1, 4
addi $t0, $t0, -1
end_for:
lw $s0, ($s1)


