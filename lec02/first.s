.text
main:
	li $v0, #v0 = 1
	li $a0, #a0 = 52
	syscall

	jr $ra #nreturn 0

.data