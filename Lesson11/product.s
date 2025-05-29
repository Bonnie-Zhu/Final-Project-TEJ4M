@ product.s
.global main

main:
    push {lr}
    ldr r0, =5         @ n = 5
    ldr r1, =3         @ m = 3
    bl multiply
    ldr r1, =5
    ldr r2, =3
    ldr r3, =result_str
    bl printf
    pop {lr}
    bx lr

multiply:
    push {lr}
    mov r2, #0          @ Initialize accumulator
    bl product
    pop {lr}
    bx lr

product:
    cmp r1, #0
    moveq r0, r2
    bxeq lr
    add r2, r2, r0
    sub r1, r1, #1
    b product

.data
result_str: .asciz "%d * %d = %d\n"
