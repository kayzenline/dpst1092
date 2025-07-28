# Author: JIAWEN LIN
# Date: 26/05/2025
# z5647814
main:
	li $t0, 1 #i
	li $v0, 4
	la $a0, string
	syscall
	li $v0, 5
	syscall
	move $t1, $v0 #number

	ble $t0, $t1, loop
	.data
string:
	.asciiz "Enter a number: "
string1:
	.asciiz "\n"
	.text
loop:
	bgt $t0, $t1, end
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 4
	la $a0, string1
	syscall
	addi $t0, $t0, 1
	j loop
end:
	li $v0, 0
	jr $ra