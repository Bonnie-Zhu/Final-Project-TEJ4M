@ binomial.s
.global main

main:
    push {lr}
    @ Valid case
    ldr r0, =5         @ n = 5
    ldr r1, =2         @ k = 2
    bl binomial
    ldr r1, =5
    ldr r2, =2
    ldr r3, =valid_str
    bl printf
    
    @ Invalid case
    ldr r0, =4
    ldr r1, =5
    bl binomial
    ldr r1, =4
    ldr r2, =5
    ldr r3, =invalid_str
    bl printf
    
    pop {lr}
    bx lr

binomial:
    push {r4, r5, lr}
    cmp r0, #0
    blt invalid
    cmp r1, #0
    blt invalid
    cmp r1, r0
    bgt invalid
    
    cmp r0, #0
    moveq r0, #1
    beq end
    cmp r1, #0
    moveq r0, #1
    beq end
    cmp r1, r0
    moveq r0, #1
    beq end
    
    mov r4, r0
    mov r5, r1
    sub r0, r4, #1
    bl binomial
    push {r0}
    sub r0, r4, #1
    sub r1, r5, #1
    bl binomial
    pop {r1}
    add r0, r0, r1
    b end
    
invalid:
    mov r0, #-1
    
end:
    pop {r4, r5, lr}
    bx lr

.data
valid_str: .asciz "C(%d, %d) = %d\n"
invalid_str: .asciz "C(%d, %d) = %d (invalid)\n"
