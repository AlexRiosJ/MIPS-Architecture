.text
addi $s0,$zero,8
addi $s1,$zero,3

andi $s2,$zero,8
ori  $s2,$zero,8
lui  $s2,10
sll  $s2,$s0,1
srl  $s2,$s0,1

add $zero,$zero,$zero

and  $s2,$s0,$s1
or   $s2,$s0,$s1
nor  $s2,$s0,$s1
add  $s2,$s0,$s1
sub  $s2,$zero,$s0
addi $s0,$zero,0x0000
sll  $s0,$s0,16
sw   $s2, ($s0)
lw   $s1, ($s0)