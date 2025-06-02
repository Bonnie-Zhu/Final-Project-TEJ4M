/* -- subs_test.s */
.text
.global main

main:
    mov r0, #5         @ Initialize counter
loop:
    subs r0, r0, #1    @ Decrement and set flags
    bne loop           @ Loop until Z=1 (r0=0)
    bx lr
