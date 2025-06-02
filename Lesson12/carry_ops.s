/* -- carry_ops.s */
.text
.global main

main:
    @ Test movs
    movs r0, #0        @ r0 = 0, Z=1
    beq movs_ok        @ Branch if Z=1

movs_ok:
    @ Test adc (64-bit addition: r1:r0 += 1)
    mov r0, #0xFFFFFFFF @ Lower 32 bits
    mov r1, #0          @ Upper 32 bits
    adds r0, r0, #1     @ r0 = 0, C=1
    adc r1, r1, #0      @ r1 = 0 + 0 + C = 1

    @ Test sbc (64-bit subtraction: r1:r0 -= 1)
    subs r0, r0, #1     @ r0 = 0xFFFFFFFF, C=0 (borrow)
    sbc r1, r1, #0      @ r1 = 1 - 0 - !C = 0

    @ Test rsc (Reverse subtract with carry)
    rsbs r0, r0, #0     @ r0 = 0 - r0 (negation)
    rsc r1, r1, #0      @ r1 = 0 - r1 - !C

    bx lr
