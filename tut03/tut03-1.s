
main:
        li $v0, 4
        la $a0, string1
        syscall
        li $v0, 5
        syscall
        move $t0, $v0

        ble $t0,100, prom2
        bge $t0, 1000, prom2
        li $v0, 4
        li $a0, string2
        syscall
        j end


.text
string1:
        .asciiz "Enter a number: "
string2:
        .asciiz "medium\n"
string3:
        .asciiz "small/big\n"


prom2:
        li $v0, 4
        li $a0, string3
        syscall
        j end
end:
        jr $ra