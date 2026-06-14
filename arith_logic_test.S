.section .text
.global _start
_start:

    # ADD: 5 + 3 = 8
    li a0, 5
    li a1, 3
    add a2, a0, a1
    li a3, 8
    bne a2, a3, fail

    # ADDI: 5 + 10 = 15
    addi a2, a0, 10
    li a3, 15
    bne a2, a3, fail

    # SUB: 5 - 3 = 2
    sub a2, a0, a1
    li a3, 2
    bne a2, a3, fail

    # LUI: load 0xABCDE000
    lui a2, 0xABCDE
    li a3, 0xABCDE000
    bne a2, a3, fail

    # AND: 0xFF & 0x0F = 0x0F
    li a0, 0xFF
    li a1, 0X0F
    and a2, a0, a1
    bne a2, a1, fail

    # OR: 0xFF || 0x0F = 0xFF
    or a2, a0, a1
    bne a2, a0, fail

    # XOR: 0xFF ^ 0x0F = 0xF0
    li a3, 0xF0
    xor a2, a0, a1
    bne a2, a3, fail

    # ANDI: 0xFF & 0x0F = 0x0F
    andi a2, a0, 0x0F
    bne a2, a1, fail

    # ORI: 0xF0 | 0x0F = 0xFF
    li a0, 0xF0
    ori a2, a0, 0x0F
    li a3, 0xFF
    bne a2, a3, fail

    # XORI: 0xFF ^ 0x0F = 0xF0
    li a0, 0xFF
    xori a2, a0, 0x0F
    li a3, 0xF0
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