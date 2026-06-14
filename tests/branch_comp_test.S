.section .text
.global _start
_start:


    # BEQ: NOT TAKEN 4 != 5
    li a0, 4
    li a1, 5
    beq a0, a1, fail

    # BEQ: TAKEN 4 == 4
    li a1, 4
    beq a0, a1, beq_pass
    j fail
    beq_pass:

    # BNE: NOT TAKEN 4==4
    bne a0, a1, fail

    # BNE: TAKEN 4!=5
    li a1, 5
    bne a0, a1, bne_pass
    j fail
    bne_pass:

    # BLT: NOT TAKEN 1!<-1
    li a0, -1
    li a1, 1
    blt a1, a0, fail

    # BLT: TAKEN  -1<1
    blt a0, a1, blt_pass
    j fail
    blt_pass:

    # BGE: NOT TAKEN -1!>1
    bge a0, a1, fail

    # BGE: TAKEN 1>-1
    bge a1, a0, bge_pass
    j fail
    bge_pass:

    # BLTU: NOT TAKEN -1<1 but unsigned so -1 = 0XFFFFFFFF
    bltu a1, a0, fail

    # BLTU: TAKEN 1!<-1 but unsigned so -1 = 0xFFFFFFFF
    bltu a1, a0, bltu_pass
    j fail
    bltu_pass:

    # BGEU:  NOT TAKEN 1>-1 but unsigned so -1 = 0xFFFFFFFF
    bgeu a1, a0, fail

    # BGEU: TAKEN -1!>1 but unsigned so -1 = 0xFFFFFFFF
    bgeu a0, a1, bgeu_pass
    j fail
    bgeu_pass:

    # SLT: -1<1 = 1
    slt a2, a0, a1
    li a3, 1
    bne a2, a3, fail

    # SLTU:-1<1 = 0
    sltu a2, a0, a1
    li a3, 0
    bne a2, a3, fail


    # SLTI: -1<1 = 1
    slti a2, a0, 1
    li a3, 1
    bne a2, a3, fail

    # SLTIU: -1<1 = 0
    sltiu a2, a0, 1
    li a3, 0
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
