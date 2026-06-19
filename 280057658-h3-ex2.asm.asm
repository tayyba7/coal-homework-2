.data
msg: .asciiz "Enter date (yyyymmdd): "

.text
.globl main

main:
    # ask input
    li $v0, 4
    la $a0, msg
    syscall

    # read integer
    li $v0, 5
    syscall
    move $a0, $v0

    # call function
    jal isValidDate

    # print result (0 or 1)
    move $a0, $v0
    li $v0, 1
    syscall

    # exit
    li $v0, 10
    syscall


#--------------------------------------------------
# Function: isValidDate
#--------------------------------------------------
isValidDate:

    # year = input / 10000
    li   $t0, 10000
    div  $a0, $t0
    mflo $t1        # year
    mfhi $t2        # mmdd

    # month = mmdd / 100
    li   $t0, 100
    div  $t2, $t0
    mflo $t3        # month
    mfhi $t4        # day

    # check month 1–12
    blt $t3, 1, INVALID
    bgt $t3, 12, INVALID

    # check day >=1
    blt $t4, 1, INVALID

    # ---- February ----
    beq $t3, 2, FEB

    # ---- 31-day months ----
    li $t5, 31
    beq $t3, 1, CHECK
    beq $t3, 3, CHECK
    beq $t3, 5, CHECK
    beq $t3, 7, CHECK
    beq $t3, 8, CHECK
    beq $t3, 10, CHECK
    beq $t3, 12, CHECK

    # ---- 30-day months ----
    li $t5, 30
    beq $t3, 4, CHECK
    beq $t3, 6, CHECK
    beq $t3, 9, CHECK
    beq $t3, 11, CHECK

# ---- February logic ----
FEB:
    # year % 400
    li $t0, 400
    div $t1, $t0
    mfhi $t6
    beq $t6, $zero, FEB29

    # year % 100
    li $t0, 100
    div $t1, $t0
    mfhi $t6
    beq $t6, $zero, FEB28

    # year % 4
    li $t0, 4
    div $t1, $t0
    mfhi $t6
    beq $t6, $zero, FEB29

FEB28:
    li $t5, 28
    j CHECK

FEB29:
    li $t5, 29

# ---- Final check ----
CHECK:
    ble $t4, $t5, VALID

INVALID:
    li $v0, 0
    jr $ra

VALID:
    li $v0, 1
    jr $ra