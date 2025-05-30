.global main

.section .text

main:
    push {lr}            @ Save link register
    mov r0, #5           @ Compute 5! (test case)
    bl factorial         @ Call factorial
    mov r1, r0           @ Store result for printf
    ldr r0, =result_str  @ Load format string
    bl printf            @ Print result
    mov r0, #0           @ Return 0
    pop {lr}             @ Restore link register
    bx lr                @ Exit

@ Tail-recursive factorial (n in r0, preserves r0 & r1)
factorial:
    mov r2, r0           @ Use r2 instead of r0 (preserve r0)
    mov r3, #1           @ Use r3 instead of r1 (preserve r1)
    b factorial_tail     @ Start tail recursion

factorial_tail:
    cmp r2, #0           @ if n == 0, return acc
    beq return_fact
    cmp r2, #1           @ if n == 1, return acc
    beq return_fact
    mul r3, r3, r2       @ acc = acc * n
    sub r2, r2, #1       @ n = n - 1
    b factorial_tail     @ Tail call (no recursion stack growth)

return_fact:
    mov r0, r3           @ Return result in r0
    bx lr                @ Exit function

.section .data
result_str: .asciz "Factorial: %d\n"
