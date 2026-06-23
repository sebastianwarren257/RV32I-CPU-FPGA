.section .text
.global _start
_start:

    # DIV: 15 / 5 = 3
    li a0, 15
    li a1, 5
    div a2, a0, a1
    li a3, 3
    bne a2, a3, fail
        
    # DIVU: 15 / 5 = 3
    divu a2, a0, a1
    bne a2, a3, fail

    # DIV: 5 / 15 = 0
    div a2, a1, a0
    li a3, 0
    bne a2, a3, fail

    # REM: 5 % 15 = 5
    rem a2, a1, a0
    li a3, 5
    bne a2, a3, fail


    # DIV: -15 / 5 = -3
    li a0, -15
    div a2, a0, a1
    li a3, -3
    bne a2, a3, fail

    # DIVU: -15 / 5 = 4294967281 / 5 = 858993456
    divu a2, a0, a1
    li a3, 858993456
    bne a2, a3, fail

    # DIV: -15 / -5 = 3
    li a1, -5
    div a2, a0, a1
    li a3, 3
    bne a2, a3, fail

    # REM: -15 % 4 = -3
    li a1, 4
    rem a2, a0, a1
    li a3, -3
    bne a2, a3, fail

    # REMU: -15 % 4 = 4294967281 % 4 = 1
    remu a2, a0, a1
    li a3, 1
    bne a2, a3, fail

    # REMU: 15 % 4 = 3
    li a0, 15
    remu a2, a0, a1
    li a3, 3
    bne a2, a3, fail


pass:
    li t0, 1
    li t1, 0x80001000
    sw t0, 0(t1)
    j pass

fail:
    li t0, 2
    li t1, 0x80001000
    sw t0, 0(t1)
    j fail







