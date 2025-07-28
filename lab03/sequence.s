# Author: JIAWEN LIN
# Date: 27/05/2025
# z5647814	
    .text
main:
	li $v0, 4
	la $a0, string
	syscall
	li $v0, 5
	syscall
	move $t1, $v0 #start1

	move $t4, $t1#i = start
	li $v0, 4
	la $a0, string1
	syscall
	li $v0, 5
	syscall
	move $t2, $v0 #stop10

	li $v0, 4
	la $a0, string2
	syscall
	li $v0, 5
	syscall
	move $t3, $v0 #step-2

if1:
	bgt $t2, $t1, if3

if2:
	bgt $t3, 0, end
loop:	
	blt $t4, $t2, end
	li $v0, 1
	move $a0, $t4
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	add $t4, $t4, $t3

	j loop
if3:
	ble $t3, 0, end
loop1:
	bgt $t4, $t2, end
	li $v0, 1
	move $a0, $t4
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	add $t4, $t4, $t3

	j loop1

end:
	li $v0, 0
	jr $ra

	.data
string:
	.asciiz "Enter the starting number: "
string1:
	.asciiz "Enter the stopping number: "
string2:
	.asciiz "Enter the step size: "