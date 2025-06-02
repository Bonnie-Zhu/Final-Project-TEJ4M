/* -- comparison_ops.s */
.data
a: .word -50
b: .word 0x3        @ Binary 0011
msg1: .asciz "cmn: r0 + 100 >= 0\n"
msg2: .asciz "tst: LSB is 0 (even)\n"
msg3: .asciz "teq: r0 == r1\n"

.text
.global main

main:
    push {lr}

    @ Test cmn (Compare Negative)
    ldr r0, =a
    ldr r0, [r0]      @ r0 = -50
    cmn r0, #100      @ r0 + 100 = 50 (sets flags)
    bge cmn_pass      @ Branch if result >= 0
    b cmn_end

cmn_pass:
    ldr r0, =msg1
    bl printf

cmn_end:
    @ Test tst (Test Bits)
    ldr r0, =b
    ldr r0, [r0]      @ r0 = 0x3 (0011)
    tst r0, #1        @ Check LSB
    beq tst_pass      @ Branch if LSB=0 (even)
    b tst_end

tst_pass:
    ldr r0, =msg2
    bl printf

tst_end:
    @ Test teq (Test Equality)
    mov r0, #5
    mov r1, #5
    teq r0, r1        @ r0 EOR r1
    beq teq_pass      @ Branch if equal
    b teq_end

teq_pass:
    ldr r0, =msg3
    bl printf

teq_end:
    pop {lr}
    bx lr
