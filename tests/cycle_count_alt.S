.section .text
.global _start
_start:
    li t1, 0x80001004
    lw t0, 0(t1)      # read cycle count once
    addi x0, x0, 0
    lw t0, 0(t1)      # read again, should be higher
    
    li t0, 1
    li t1, 0x80001000
    sw t0, 0(t1)
loop:
    j loop