# Reads 10 numbers into an array, bubblesorts them
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
	li	$t0, 0				# i = 0
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
	b	scan_loop__cond			# }
scan_loop__end:

	# TODO: add your code here!
    li $s0, 1  #swapped = 1
loop1_cond:
    beqz $s0, print_loop__init
    li $s0, 0
    li	$t0, 1	# i = 1

loop02_cond:
    bge $t0, ARRAY_LEN, loop1_cond
loop02_body:
    # x = numbers[i]
    la $t4, numbers
    mul $t5, $t0, 4
    add $t4, $t4, $t5
    lw  $t6, ($t4)

    # y = numbers[i - 1]
    addi $t9, $t0, -1
    mul  $t8, $t9, 4
    la   $t3, numbers
    add  $t3, $t3, $t8
    lw   $t7, ($t3)

    # if x < y then swap
    bge $t6, $t7, loop02_addi
    sw  $t7, ($t4)     # numbers[i] = y
    sw  $t6, ($t3)     # numbers[i - 1] = x
    li  $s0, 1         # swapped = 1


loop02_addi:
    addi $t0, $t0, 1
    j loop02_cond
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
	li	$a0, '\n'			#
	syscall					#   printf("%c", '\n');

	addi	$t0, $t0, 1			#   i++
	b	print_loop__cond		# }
print_loop__end:
	
	li	$v0, 0
	jr	$ra				# return 0;


	.data
numbers:
	.word	0:ARRAY_LEN			# int numbers[ARRAY_LEN] = {0};
