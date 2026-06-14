.section .text
.global _start
_start:
    li t0, 1
    li t1, 0x80001000
    sw t0, 0(t1)
loop:
    j loop
