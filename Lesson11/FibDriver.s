.global main
.extern printf

.section .text

main:
    push {lr}                @ Save return address

    @ Test cases: Compute Fib(0) to Fib(10)
    mov r4, #0               @ Initialize counter (n = 0)
    ldr r5, =max_n           @ Load max value (e.g., 10)
    ldr r5, [r5]

loop:
    @ Prepare to call Fib(n)
    mov r0, r4               @ Argument: n
    bl fib                   @ Call tail-recursive Fib(n)

    @ Print result: "Fib(n) = X\n"
    mov r2, r0               @ Store Fib(n) result
    ldr r0, =output_fmt      @ Format string
    mov r1, r4               @ n (for printing)
    bl printf                @ Call printf

    @ Check if we've reached max_n
    add r4, r4, #1           @ n++
    cmp r4, r5
    ble loop                 @ Loop if n ≤ max_n

    @ Exit
    mov r0, #0               @ Return 0
    pop {lr}                 @ Restore return address
    bx lr                    @ Exit program

@ Tail-recursive Fibonacci (assumed to be in Fib.s)
fib:
    @ Your tail-recursive Fib impl here (or link externally)
    @ Example (if not external):
    mov r2, #0               @ a = 0
    mov r3, #1               @ b = 1
    b fib_tail

fib_tail:
    cmp r0, #0
    moveq r0, r2             @ if n==0, return a
    bxeq lr
    cmp r0, #1
    moveq r0, r3             @ if n==1, return b
    bxeq lr
    add r1, r2, r3           @ next = a + b
    mov r2, r3               @ a = b
    mov r3, r1               @ b = next
    sub r0, r0, #1           @ n--
    b fib_tail               @ Tail call

.section .data
output_fmt: .asciz "Fib(%d) = %d\n"
max_n:      .word 10         @ Compute Fib(0) to Fib(10)
