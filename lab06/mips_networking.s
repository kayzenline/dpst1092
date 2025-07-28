# Reads a 4-byte value and reverses the byte order, then prints it
# JIAWEN LIN(z5647814) 16/06/2025
########################################################################
# .TEXT <main>
main:
	# Locals:
	#	- $t0: int network_bytes
	#	- $t1: int computer_bytes
	#	- Add your registers here!


	li	$v0, 5		# scanf("%d", &x);
	syscall
	move $t0, $v0 		#network_bytes
	#
	# Your code here!
	#
	li $t1, 0 	# computer_bytes = 0;
	li $t2, 0xFF 	#byte_mask = BYTE_MASK;
	#################
	and $t3, $t0, $t2
	sll $t3, $t3, 24
	or $t1, $t1, $t3
	################
	sll $t4, $t2, 8
	and $t3, $t0, $t4
	sll $t3, $t3, 8
	or $t1, $t1, $t3
	################
	sll $t4, $t2, 16
	and $t3, $t0, $t4
	sra $t3, $t3, 8
	or $t1, $t1, $t3
	################
	sll $t4, $t2, 24
	and $t3, $t0, $t4
	sra $t3, $t3, 24
	or $t1, $t1, $t3

	move	$a0, $t1	# printf("%d\n", x);
	li	$v0, 1
	syscall

	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall

main__end:
	li	$v0, 0		# return 0;
	jr	$ra
