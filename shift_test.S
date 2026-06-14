.section .text
.global _start
_start:


    # SLL: 4 << 2 = 16
    li a0, 4
    li a1, 2
    sll a2, a0, a1
    li a3, 16
    bne a2, a3, fail
    
    # SRL: 4 >> 2 = 1
    srl a2, a0, a1
    li a3, 1
    bne a2, a3, fail

    # SRA +: 4 >> 2 = 1
    sra a2, a0, a1
    bne a2, a3, fail

    # SRA -: -8 >> 2 = -2
    li a0, -8
    li a1, 2
    sra a2, a0, a1
    li a3, -2
    bne a2, a3, fail

    # SLLI: 4 << 2 = 16
    li a0, 4
    slli a2, a0, 2
    li a3, 16
    bne a2, a3, fail

    # SRLI: 4 >> 2 = 1
    srli a2, a0, 2
    li a3, 1
    bne a2, a3, fail

    # SRAI +: 4 >> 2 = 1
    srai a2, a0, 2
    bne a2, a3, fail

    # SRAI -: -8 >> 2 = -2
    li a0, -8
    srai a2, a0, 2
    li a3, -2
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
