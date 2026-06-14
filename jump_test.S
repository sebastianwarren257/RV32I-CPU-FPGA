.section .text
.global _start
_start:

    # JAL: jump and link
    jal ra, jal_target
    j fail
jal_target:
    li t0, 0x80000004
    bne ra, t0, fail

    # JALR
    la t1, jalr_target
    jalr ra, t1, 0
    j fail
jalr_target:
    la t0, 0x80000020
    bne ra, t0, fail

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