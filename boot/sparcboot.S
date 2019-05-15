.section .text
.align 16
.global _start

_start:
        call 1f                      ! put PC on the stack.
        mov %o7, %l0                 ! use the delay slot to grab it
1:      mov 0x60, %l3                ! 0x60 is the offset to the putstr pointer
        add %l3, %o0, %l3            ! actual address holding the putstr pointer
        ld [%l3], %l5                ! address of function

        mov %l4, %o0                 ! first argument is pointer
        mov 0x0b, %o1                ! second argument is number of characters
        call %l5                     ! call function
        nop                          ! waste the delay slot for simplicity

2:
        call kmain                   ! loop forever
        nop
