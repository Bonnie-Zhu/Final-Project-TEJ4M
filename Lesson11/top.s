/* -- test_top.s */
.data
msg: .asciz "Top of stack value: %d\n"

.text
.global main
main:
    push {lr}
    
    @ Push some test values
    mov r0, #42
    push {r0}
    mov r0, #100
    push {r0}
    
    bl top           @ Call our top function
    
    @ Print the result
    mov r1, r0
    ldr r0, =msg
    bl printf
    
    @ Clean up stack
    add sp, sp, #8
    pop {lr}
    bx lr
