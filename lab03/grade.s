# Author: JIAWEN LIN
# Date: 21/05/2025
#z5647814
.text
main:
        li $v0, 4
        la $a0, string1
        syscall

        li $v0, 5
        syscall
        move $t0, $v0
	
	blt $t0, 50, mark1
        blt $t0, 65, mark2
        blt $t0, 75, mark3
        blt $t0, 85, mark4
        j mark5
        


mark1:
        li $v0, 4
        la $a0, string2
        syscall
        j end
mark2:
        li $v0, 4
        la $a0, string3
        syscall
        j end
mark3:
        li $v0, 4
        la $a0, string4
        syscall
        j end
mark4:
        li $v0, 4
        la $a0, string5
        syscall
        j end
mark5:
        li $v0, 4
        la $a0, string6
        syscall
        j end

end:
        li $v0, 10
        jr $ra
.data
string1:
        .asciiz "Enter a mark: "
string2:
        .asciiz "FL\n"
string3:
        .asciiz "PS\n"
string4:
        .asciiz "CR\n"
string5:
        .asciiz "DN\n"
string6:
        .asciiz "HD\n"