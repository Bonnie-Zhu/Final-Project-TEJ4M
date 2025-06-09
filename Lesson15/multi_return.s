/* multi_return.s - demonstrates returning multiple values */

.data
value1: .word 0
value2: .word 0
value3: .word 0

message: .asciz "Returned values: %d, %d, %d\n"

.text
.globl main

/* Function that returns multiple values through pointers
   Parameters:
   r0 - address to store first return value
   r1 - address to store second return value
   r2 - address to store third return value */
return_multiple:
    mov r3, #10
    str r3, [r0]    /* Store 10 at first address */
    
    mov r3, #20
    str r3, [r1]    /* Store 20 at second address */
    
    mov r3, #30
    str r3, [r2]    /* Store 30 at third address */
    
    bx lr

main:
    push {lr}
    
    /* Call return_multiple with addresses to store results */
    ldr r0, =value1
    ldr r1, =value2
    ldr r2, =value3
    bl return_multiple
    
    /* Print the returned values */
    ldr r0, =message
    ldr r1, =value1
    ldr r1, [r1]
    ldr r2, =value2
    ldr r2, [r2]
    ldr r3, =value3
    ldr r3, [r3]
    bl printf
    
    pop {lr}
    bx lr
