# Reads 10 numbers into an array,
# swaps any pairs of of number which are out of order
# and then prints the 10 numbers
# Author: JIAWEN LIN
# Date: 03/06/2025
# z5647814


# Constants
ARRAY_LEN = 10

main:
	# Registers:
	#  - $t0: int i
	#  - $t1: temporary result
	#  - $t2: temporary result
	#  TODO: add your registers here

scan_loop__init:
	li	$t0, 0				# i = 0;
scan_loop__cond:
	bge	$t0, ARRAY_LEN, scan_loop__end	# while (i < ARRAY_LEN) {

scan_loop__body:
	li	$v0, 5				#   syscall 5: read_int
	syscall					#   
						#
	mul	$t1, $t0, 4			#   calculate &numbers[i] == numbers + 4 * i
	la	$t2, numbers			#
	add	$t2, $t2, $t1			#
	sw	$v0, ($t2)			#   scanf("%d", &numbers[i]);

	addi	$t0, $t0, 1			#   i++;
	j	scan_loop__cond			# }
scan_loop__end:


	# TODO: add your code here!
    
	li	$t0, 1				# i = 1;
test_loop__start:
	bge	$t0, ARRAY_LEN, test_loop__end	# while (i < ARRAY_LEN) {

    mul $t1, $t0, 4 #i = t0           
    la  $t2, numbers             
    add $t2, $t2, $t1 #t2 = &numbers[i] 
    lw $t5, ($t2) #t5 = numbers[i] #x

    li $t8, 4
    sub $t6, $t1, $t8 
    la  $t3, numbers             
    add $t3, $t3, $t6 #t3 = &numbers[i - 1] 
    lw $t7, ($t3) #t7 = numbers[i - 1] #y

    bge $t5, $t7, test_loop__add
    sw $t5, ($t3) #numbers[i - 1] = x;
    sw $t7, ($t2) #numbers[i] = y;

test_loop__add:
	addi	$t0, $t0, 1			#   i++;
	j	test_loop__start			# }
test_loop__end:





print_loop__init:
	li	$t0, 0				# i = 0
print_loop__cond:
	bge	$t0, ARRAY_LEN, print_loop__end	# while (i < ARRAY_LEN) {

print_loop__body:
	mul	$t1, $t0, 4			#   calculate &numbers[i] == numbers + 4 * i
	la	$t2, numbers			#
	add	$t2, $t2, $t1			#
	lw	$a0, ($t2)			#
	li	$v0, 1				#   syscall 1: print_int
	syscall					#   printf("%d", numbers[i]);

	li	$v0, 11				#   syscall 11: print_char
	li	$a0, '\n'
	syscall					#   printf("%c", '\n');

	addi	$t0, $t0, 1			#   i++
	b	print_loop__cond		# }
print_loop__end:
	
	li	$v0, 0
	jr	$ra				# return 0;

	.data
numbers:
	.word	0:ARRAY_LEN			# int numbers[ARRAY_LEN] = {0};
