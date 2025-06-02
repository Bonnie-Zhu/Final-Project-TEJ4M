/* -- factorial.s */
.data
n: .word 5
result_msg: .asciz "Factorial of %d is %d\n"

.text
.global main

factorial:
    push {lr}           @ Save return address
    mov r1, r0          @ Move n to r1
    mov r0, #1          @ Initialize result = 1

factorial_loop:
    cmp r1, #1          @ Compare n with 1
    ble factorial_end    @ If n <= 1, exit
    mov r2, r0          @ Copy result to temp register
    mul r0, r2, r1      @ result = result * n (using different registers)
    sub r1, r1, #1      @ n = n - 1
    b factorial_loop

factorial_end:
    pop {lr}            @ Restore return address
    bx lr

main:
    push {lr}
    ldr r0, =n
    ldr r0, [r0]        @ Load n (5)
    bl factorial

    @ Prepare printf arguments:
    ldr r1, =n
    ldr r1, [r1]        @ Load original n (5)
    mov r2, r0          @ Move result to r2
    ldr r0, =result_msg @ Format string
    bl printf

    pop {lr}
    bx lr
