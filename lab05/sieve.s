# Sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
# JIWEN LIN (z5647814) 10/06/2025

# Constants
ARRAY_LEN = 1000

main:

	# TODO: add your code here
        li $t0, 2
for_loop:
        
        bge $t0, ARRAY_LEN, end


if:
        la $t1, prime
        add $t1, $t1, $t0
        lb $t6, 0($t1)
        bne $t6, 1, increment_i

        li $v0, 1
        move $a0, $t0
        syscall
        li $v0, 11
        li $a0, '\n'
        syscall
sec_for_loop:
        li $t5, 2
        mul $t2, $t5, $t0
sec_for_loop_cond:
        bge $t2, ARRAY_LEN, increment_i

        la $t3, prime
        add $t3, $t3, $t2
        li $t4, 0
        sb $t4, 0($t3)
        add $t2, $t2, $t0
        j sec_for_loop_cond
increment_i:
        addi $t0, $t0, 1     
        j for_loop        
end:
	li	$v0, 0
	jr	$ra			# return 0;

	.data
prime:
	.byte	1:ARRAY_LEN		# uint8_t prime[ARRAY_LEN] = {1, 1, ...};
