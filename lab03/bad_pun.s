# Author: JIAWEN LIN
# Date: 21/05/2025
# z5647814
main:
	la $a0, string
	li $v0, 4
	syscall

	li $v0, 0
	jr $ra

	.data
string:
	.asciiz "Well, this was a MIPStake!\n"