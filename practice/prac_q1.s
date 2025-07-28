# DPST1092 25T2 ... prac exam, question 1
# Read in an integer, and print out the results of doubling the value 10 times

NUM_ITERS = 10

main:
	li	$v0, 5			# syscall 5: read_int
	syscall				#
	move	$t0, $v0		# scanf("%d", &a);

main__loop_init:
	li	$t1, NUM_ITERS		# int count = NUM_ITERS;
main__loop_cond:
	blez	$t1, main__loop_end	# while (count > 0) {

main__loop_body:
	# TODO: modify the contents of this loop
	mul $t0, $t0, 2
	addi $t1, $t1, -1
	li	$v0, 1			#   syscall 1: print_int
	move	$a0, $t0		#
	syscall				#   printf("%d", a);

	li	$v0, 11			#   syscall 11: print_char
	li	$a0, '\n'		#
	syscall				#   putchar('\n');

	j	main__loop_cond		# }

main__loop_end:
	li	$v0, 0
	jr	$ra			# return 0;
