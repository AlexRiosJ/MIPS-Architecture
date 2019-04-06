# Authors: Alejandro Rios, Javier Ochoa
# Exp: is708932, is702811
# Date: Abr 1, 2019
# Tower Of Hanoi - 3 disks

.text
	addi $s0, $zero, 3 # Number of disks
	addi $s1, $s1, 0x1001
	sll $s1, $s1, 16 # Save address of tower A
	addi $s2, $s1, 0x20 # Save address of tower B
	addi $s3, $s2, 0x20 # Save address of tower C
	add $t0, $s0, $zero
	
	for: # Fill tower A with all the disks
		beq $t0, $zero, end_for
		sw $t0, ($s1)
		addi $s1, $s1, 4
		addi $t0, $t0, -1
		j for
		end_for:
	
	main:
		add $a0, $s0, $zero # Biggest disk
		add $a1, $s1, $zero # Source
		add $a2, $s3, $zero # Destination
		add $a3, $s2, $zero # Spare
		jal move_tower # First call (disk, source, dest, spare)
		j exit # Exit jump
	
	move_tower:
		addi $sp, $sp, -4 # Save space in stack
		sw $ra, ($sp) # Save return address
		# If (disk == 1)
		beq $a0, 1, equal_one 
		# Else
		addi $a0, $a0, -1 # Look for a smaller disk (first)
		add $t0, $a2, $zero # temp = dest
		add $a2, $a3, $zero # dest = spare
		add $a3, $t0, $zero # spare = temp
		jal move_tower # First recursive call
		add $t0, $a2, $zero # temp = dest
		add $a2, $a3, $zero # dest = spare
		add $a3, $t0, $zero # spare = temp
		
		# This move_disk code does not need to be called so is writen here
		# pop
		addi $a1, $a1, -4
		lw $t0, ($a1) # Get value of element at the top
		sw $zero, ($a1) # Write 0 in white space
		# push
		sw $t0, ($a2) # Push at the top of the tower
		addi $a2, $a2, 4 # Update top pointer
		
		addi $a0, $a0, -1 # Look for a smaller disk (second)
		add $t0, $a1, $zero # temp = source
		add $a1, $a3, $zero # source = spare
		add $a3, $t0, $zero # spare = temp
		jal move_tower # Second recursive call
		add $t0, $a1, $zero # temp = source
		add $a1, $a3, $zero # source = spare
		add $a3, $t0, $zero # spare = temp
		j end_if # End of if statement
		 
	equal_one:
		# This move_disk code does not need to be called so is writen here
		# pop
		addi $a1, $a1, -4
		lw $t0, ($a1) # Get value of element at the top
		sw $zero, ($a1) # Write 0 in white space
		# push
		sw $t0, ($a2) # Push at the top of the tower
		addi $a2, $a2, 4 # Update top pointer
		
	end_if: # Save stack values
		addi $a0, $a0, 1 # Get the disk for the general call
		lw $ra, ($sp) # Return address
		addi $sp, $sp, 4 # Bring back address in stack pointer
		jr $ra # Return to recursive general
		
	exit: # End
