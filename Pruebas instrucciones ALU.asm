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
beq $s0, $s1, label
