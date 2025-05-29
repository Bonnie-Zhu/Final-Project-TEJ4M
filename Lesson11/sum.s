@ sum.s
.global main

main:
    push {lr}
    ldr r0, =7         @ n = 7
    ldr r1, =4         @ m = 4
    bl sum
    ldr r1, =7
    ldr r2, =4
    ldr r3, =result_str
    bl printf
    pop {lr}
    bx lr

sum:
    cmp r1, #0
    bxeq lr
    add r0, r0, #1
    sub r1, r1, #1
    b sum

.data
result_str: .asciz "%d + %d = %d\n"
