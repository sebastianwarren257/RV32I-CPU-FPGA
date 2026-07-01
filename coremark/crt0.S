.section .text
.global _start
_start:
    li sp, 0x8000FFF0

    la t0, _bss_start
    la t1, _bss_end
bss_clear_loop:
    bge t0, t1, bss_clear_done
    sw  zero, 0(t0)
    addi t0, t0, 4
    j bss_clear_loop
bss_clear_done:

    call main

    /* main returned after portable_fini already signalled completion.
       Do NOT overwrite tohost here -- just halt so the real result
       (written by portable_fini) stays latched. */
halt:
    j halt