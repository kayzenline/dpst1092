# Author: JIAWEN LIN
# Date: 27/05/2025
# z5647814
	.text
main:
	li $t0, 1 #i
	li $t2, 7 #7
	li $t3, 11 #11
	li $t5, 0 #0

	li $v0, 4
	la $a0, string
	syscall
	li $v0, 5
	syscall
	move $t1, $v0 #number

loop:
	bge $t0, $t1, end
	div $t0, $t2
	mfhi $t6 #remainder1
	div $t0, $t3
	mfhi $t4 #remainder2
	beq $t4, $t5, if
	beq $t6, $t5, if
loop_end:
	addi $t0, $t0, 1 
	j loop
if:

	li $v0, 1
	move $a0, $t0
	syscall

	li $v0, 4
	la $a0, string1
	syscall

	j loop_end


end:
	li $v0, 0
	jr $ra

	.data
string:
	.asciiz "Enter a number: "
string1:
	.asciiz "\n"