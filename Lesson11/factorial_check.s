/* -- factorial_check.s */
.data
error_msg: .asciz "Input must be <= 12\n"
result_msg: .asciz "%d! = %d\n"

.text
.global main

factorial:
    @ Check for input > 12
    cmp r0, #12
    movgt r0, #-1
    bxgt lr
    
    @ Base case
    cmp r0, #0
    moveq r0, #1
    bxeq lr
    
    @ Recursive case
    push {lr}
    push {r0}
    sub r0, r0, #1
    bl factorial
    pop {r1}
    mul r0, r0, r1
    pop {lr}
    bx lr

main:
    push {lr}
    sub sp, sp, #8
    
    @ Get input
    ldr r0, =format
    mov r1, sp
    bl scanf
    
    @ Compute factorial
    ldr r0, [sp]
    bl factorial
    
    @ Check for error
    cmp r0, #-1
    ldreq r0, =error_msg
    bleq printf
    beq done
    
    @ Print result
    mov r2, r0
    ldr r1, [sp]
    ldr r0, =result_msg
    bl printf

done:
    add sp, sp, #8
    pop {lr}
    bx lr

.data
format: .asciz "%d"
