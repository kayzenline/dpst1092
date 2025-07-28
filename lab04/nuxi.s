# Author: JIAWEN LIN
# Date: 04/06/2025
# z5647814


main:


    li $v0, 5
    syscall
    move $t0, $v0  

  
    andi $s0, $t0, 0xFF
    srl  $t2, $t0, 8
    andi $s1, $t2, 0xFF
    srl  $t2, $t0, 16
    andi $s2, $t2, 0xFF
    srl  $t2, $t0, 24
    andi $s3, $t2, 0xFF



check_U:
    bne $s0, 85, check_U_1
    li $t3, 0
    j check_N
check_U_1:
    bne $s1, 85, check_U_2
    li $t3, 8
    j check_N
check_U_2:
    bne $s2, 85, check_U_3
    li $t3, 16
    j check_N
check_U_3:
    li $t3, 24



check_N:
    bne $s0, 78, check_N_1
    li $t4, 0
    j check_I
check_N_1:
    bne $s1, 78, check_N_2
    li $t4, 8
    j check_I
check_N_2:
    bne $s2, 78, check_N_3
    li $t4, 16
    j check_I
check_N_3:
    li $t4, 24



check_I:
    bne $s0, 73, check_I_1
    li $t5, 0
    j check_X
check_I_1:
    bne $s1, 73, check_I_2
    li $t5, 8
    j check_X
check_I_2:
    bne $s2, 73, check_I_3
    li $t5, 16
    j check_X
check_I_3:
    li $t5, 24



check_X:
    bne $s0, 88, check_X_1
    li $t6, 0
    j change_start
check_X_1:
    bne $s1, 88, check_X_2
    li $t6, 8
    j change_start
check_X_2:
    bne $s2, 88, check_X_3
    li $t6, 16
    j change_start
check_X_3:
    li $t6, 24




change_start:

    # b -> s4..s7
    li $v0, 5
    syscall
    move $t1, $v0   

    andi $s4, $t1, 0xFF
    srl  $t2, $t1, 8
    andi $s5, $t2, 0xFF
    srl  $t2, $t1, 16
    andi $s6, $t2, 0xFF
    srl  $t2, $t1, 24
    andi $s7, $t2, 0xFF


    # t3..t6 -> t7
    li $t7, 0
    sllv $t1, $s4, $t3
    move $t7, $t1

    sllv $t1, $s5, $t4
    or $t7, $t7, $t1

    sllv $t1, $s6, $t5
    or $t7, $t7, $t1

    sllv $t1, $s7, $t6
    or $t7, $t7, $t1



    li $v0, 1
    move $a0, $t7
    syscall

    li $v0, 11
    li $a0, '\n'
    syscall

    li $v0, 10
    syscall

	li	$v0, 0
	jr	$ra	
    