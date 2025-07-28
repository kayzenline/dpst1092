# Author: JIAWEN LIN
# Date: 28/05/2025
# z5647814
# Author: JIAWEN LIN
# Date: 28/05/2025
# z5647814
.text
main:
        li $t1, 1 #n = 1

        li $v0, 4
        la $a0, string
        syscall

        li $v0, 5
        syscall
        move $t0, $v0 #how_many
loop1:
        bgt $t1, $t0, loop1_end #n <= how_many
        li $t4, 0 #total = 0
        li $t2, 1 #j = 1


loop2:
        bgt $t2, $t1, loop2_end #j <= n
	li $t3, 1 #i = 1

loop3:
        bgt $t3, $t2, loop3_end #i <= j
        add $t4, $t4, $t3 #total = total + i
        addi $t3, $t3, 1 #i = i +1
	j loop3

loop3_end:

        addi $t2, $t2, 1 #j = j + 1
	j loop2

loop2_end:
        li $v0, 1
        move $a0, $t4
        syscall

        li $v0, 11
        li $a0, '\n'
        syscall
	
        addi $t1, $t1, 1
	j loop1

loop1_end:
        li $v0, 0
        jr $ra
string:
        .asciiz "Enter how many: "
