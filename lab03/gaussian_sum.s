# Author: JIAWEN LIN
# Date: 24/05/2025
#z5647814

main:
	li  $v0, 4 
	la  $a0, string1
	syscall 

	li $v0, 5  
  	syscall 
  	move $t0, $v0 
	sw $t0, number1

	li  $v0, 4 
	la  $a0, string2
	syscall 

	li $v0, 5  
  	syscall 
  	move $t0, $v0 
	sw $t0, number2

	lw $t0, number1
	lw $t1, number2

	addi $t2, $t1, 1
	sub $t3, $t2, $t0
	add $t4, $t0, $t1
	mul $t5, $t3, $t4
	li $t6, 2
	div $t7, $t5, $t6

	li  $v0, 4 
	la  $a0, string3
	syscall 

	li  $v0, 1
	move $a0, $t0
	syscall

	li  $v0, 4 
	la  $a0, string4
	syscall 

	li  $v0, 1 
	move  $a0, $t1
	syscall 

	li  $v0, 4
	la  $a0, string5
	syscall 

	li  $v0, 1 
	move  $a0, $t7
	syscall 
	
	li  $v0, 4
	la  $a0, string6
	syscall 

	li  $v0, 0     
   	jr  $ra

   	.data
number1: .space 4   
number2: .space 4

string1:
    	.asciiz "Enter first number: "
string2:
    	.asciiz "Enter second number: "
string3:
    	.asciiz "The sum of all numbers between "
string4:
    	.asciiz " and "
string5:
    	.asciiz " (inclusive) is: "
string6:
    	.asciiz "\n"


