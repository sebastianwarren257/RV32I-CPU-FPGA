.section .text
.global _start
_start:

    # MUL: 5 * 3 = 15
    li a0, 5
    li a1, 3
    mul a2, a0, a1
    li a3, 15
    bne a2, a3, fail

    # MULH: 0x80000000 * 2 signed, high bits = 0xFFFFFFFF
    li a0, 0x80000000
    li a1, 2
    mulh a2, a0, a1
    li a3, -1
    bne a2, a3, fail

    # MULHU: 0xFFFFFFFF * 0xFFFFFFFF unsigned, high bits = 0xFFFFFFFE
    li a0, -1
    li a1, -1
    mulhu a2, a0, a1
    li a3, -2
    bne a2, a3, fail

    # MULHSU: -1 (signed) * 2 (unsigned), high bits = 0xFFFFFFFF
    li a0, -1
    li a1, 2
    mulhsu a2, a0, a1
    li a3, -1
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