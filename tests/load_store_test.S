.section .text
.global _start
_start:

    # Setup base address in data region
    li t0, 0x80002000

    # SW + LW
    li t1, 0xDEADBEEF
    sw t1, 0(t0)
    lw t2, 0(t0)
    bne t1, t2, fail

    # SH + LH (store lower halfword, load sign extended)
    li t1, 0x00001234
    sh t1, 4(t0)
    lh t2, 4(t0)
    bne t1, t2, fail

    # SH + LHU (store lower halfword, load zero extended)
    li t1, 0x00008FFF
    sh t1, 4(t0)
    lhu t2, 4(t0)
    bne t1, t2, fail

    # SB + LB (store byte, load sign extended)
    li t1, 0x00000042
    sb t1, 8(t0)
    lb t2, 8(t0)
    bne t1, t2, fail

    # SB + LBU (store byte, load zero extended)
    li t1, 0x000000FF
    sb t1, 8(t0)
    lbu t2, 8(t0)
    bne t1, t2, fail

    # LB sign extension test (negative byte)
    li t1, 0xFFFFFF80
    sb t1, 12(t0)
    lb t2, 12(t0)
    bne t1, t2, fail

    # LH sign extension test (negative halfword)
    li t1, 0xFFFF8000
    sh t1, 16(t0)
    lh t2, 16(t0)
    bne t1, t2, fail

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