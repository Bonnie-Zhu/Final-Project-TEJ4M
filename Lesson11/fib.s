@ fib.s
.global main

main:
    push {lr}
    ldr r0, =10        @ n = 10
    bl fib
    ldr r1, =10
    ldr r2, =result_str
    bl printf
    pop {lr}
    bx lr

fib:
    push {r4, lr}
    cmp r0, #0
    moveq r0, #0
    beq end
    cmp r0, #1
    moveq r0, #1
    beq end
    mov r4, r0
    sub r0, r0, #1
    bl fib
    mov r1, r0
    sub r0, r4, #2
    bl fib
    add r0, r1, r0
end:
    pop {r4, lr}
    bx lr

.data
result_str: .asciz "Fib(%d) = %d\n"
