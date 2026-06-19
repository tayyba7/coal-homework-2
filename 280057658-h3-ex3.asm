#--------------------------------------------------
# Function: ageInDays
# Input : $a0 = birth date (yyyymmdd)
#         $a1 = current date (yyyymmdd)
# Output: $v0 = age in days
#--------------------------------------------------

ageInDays:

    # -------- Extract birth date --------
    li   $t0, 10000
    div  $a0, $t0
    mflo $s0        # birth year
    mfhi $t1

    li   $t0, 100
    div  $t1, $t0
    mflo $s1        # birth month
    mfhi $s2        # birth day

    # -------- Extract current date --------
    li   $t0, 10000
    div  $a1, $t0
    mflo $s3        # current year
    mfhi $t1

    li   $t0, 100
    div  $t1, $t0
    mflo $s4        # current month
    mfhi $s5        # current day

    # -------- Convert birth date to total days --------
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal dateToDays
    move $t8, $v0

    # -------- Convert current date to total days --------
    move $a0, $s3
    move $a1, $s4
    move $a2, $s5
    jal dateToDays
    move $t9, $v0

    # -------- Age in days --------
    sub  $v0, $t9, $t8

    jr   $ra


#--------------------------------------------------
# Function: dateToDays
# Input : $a0 = year, $a1 = month, $a2 = day
# Output: $v0 = total days
#--------------------------------------------------

dateToDays:

    li $t0, 0        # total days
    li $t1, 1        # year counter

# -------- Year Loop --------
YEAR_LOOP:
    bge $t1, $a0, END_YEAR

    move $t2, $t1

    # check leap year
    li $t3, 400
    div $t2, $t3
    mfhi $t4
    beq $t4, $zero, ADD_366

    li $t3, 100
    div $t2, $t3
    mfhi $t4
    beq $t4, $zero, ADD_365

    li $t3, 4
    div $t2, $t3
    mfhi $t4
    beq $t4, $zero, ADD_366

ADD_365:
    addi $t0, $t0, 365
    j NEXT_YEAR

ADD_366:
    addi $t0, $t0, 366

NEXT_YEAR:
    addi $t1, $t1, 1
    j YEAR_LOOP

END_YEAR:

# -------- Month Loop --------
    li $t1, 1

MONTH_LOOP:
    bge $t1, $a1, END_MONTH

    li $t3, 31

    beq $t1, 4, M30
    beq $t1, 6, M30
    beq $t1, 9, M30
    beq $t1, 11, M30
    beq $t1, 2, FEB

    j ADD_MONTH

M30:
    li $t3, 30
    j ADD_MONTH

FEB:
    # check leap year for Feb
    move $t2, $a0

    li $t5, 400
    div $t2, $t5
    mfhi $t6
    beq $t6, $zero, FEB29

    li $t5, 100
    div $t2, $t5
    mfhi $t6
    beq $t6, $zero, FEB28

    li $t5, 4
    div $t2, $t5
    mfhi $t6
    beq $t6, $zero, FEB29

FEB28:
    li $t3, 28
    j ADD_MONTH

FEB29:
    li $t3, 29

ADD_MONTH:
    add $t0, $t0, $t3
    addi $t1, $t1, 1
    j MONTH_LOOP

END_MONTH:

# -------- Add remaining days --------
    add $t0, $t0, $a2

    move $v0, $t0
    jr $ra