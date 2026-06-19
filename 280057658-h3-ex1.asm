.data
msg: .asciiz "Enter year: "

.text
.globl main

main:
    # input
    li $v0, 4
    la $a0, msg
    syscall

    li $v0, 5
    syscall
    move $a0, $v0

    # call function
    jal isLeapYear

    # print result (0 or 1)
    move $a0, $v0
    li $v0, 1
    syscall

    # exit
    li $v0, 10
    syscall


# function
isLeapYear:
    li   $t0, 400
    div  $a0, $t0
    mfhi $t1
    beq  $t1, $zero, ONE

    li   $t0, 100
    div  $a0, $t0
    mfhi $t1
    beq  $t1, $zero, ZERO

    li   $t0, 4
    div  $a0, $t0
    mfhi $t1
    beq  $t1, $zero, ONE

ZERO:
    li $v0, 0
    jr $ra

ONE:
    li $v0, 1
    jr $ra