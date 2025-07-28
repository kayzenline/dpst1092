# DPST1092 25T2 ... prac exam, question 3
# return the number of peaks in an array of integers
#
# A peak is a value that is both preceded and succeeded
# by a value smaller than itself
#
# ie:
# Both the value before and the value after the current value
# are smaller than the current value
#
# eg:
# [1, 3, 2, 5, 4, 4, 9, 0, 1, -9, -5, -7]
#     ^     ^        ^     ^       ^
# The value 3, 5, 9, 1, -5 are all peaks in this array
# So your function should return 5

.text
.globl prac_q3

prac_q3:
	# YOU DO NOT NEED TO CHANGE THE LINES ABOVE HERE


	# REPLACE THIS LINE WITH YOUR CODE
	move	$t0, $a0	# array
	move	$t1, $a1	# length
	li $t2, 0
	li $t3, 1
loop:
	addi $t4, $t1, -1
	bge $t3, $t4, end
	mul $t5, $t3, 4
	add $t6, $t0, $t5
	lw $t7, ($t6)
	lw $t8, -4($t6)
	lw $t9, 4($t6)
	ble $t7, $t8, continue
	ble $t7, $t9, continue
	addi $t2, $t2, 1
continue:
	addi $t3, $t3, 1
	j loop
end:
	move $v0, $t2
	jr	$ra


# ADD ANY EXTRA FUNCTIONS BELOW THIS LINE
