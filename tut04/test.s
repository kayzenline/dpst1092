.text
N_SIZE = 10
main:
        li $t0, 0 #i = 0
        

loop:
        bge $t0, 10, end #i < N_SIZE
        mul $t2, $t0, 4 #set offset
        la $t3, numbers	#load address of numbbers
        add  $t3, $t2, $t3 #move address
        li $v0, 5 #scanf
        syscall
        move $t3, $v0 # &number[i]
        addi $t0, $t0, 1 #i++
        j loop

end:
        jr $ra
.data
numbers:
        .space 4 * 10