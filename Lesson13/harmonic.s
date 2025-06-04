.syntax unified
.cpu cortex-a53
.fpu neon-fp-armv8

.section .note.GNU-stack,"",%progbits  @ Add this to fix the warning

.data
sum:    .double 0.0
k:      .double 1.0
one:    .double 1.0
format: .asciz "Stopped at k = %d, sum = %.15f\n"

.text
.global main
.type main, %function
main:
    push {r4, lr}        @ Save registers
    
    @ Load addresses
    ldr r0, =sum
    ldr r1, =k
    ldr r2, =one
    
    @ Load double values
    vldr d0, [r0]       @ sum
    vldr d1, [r1]       @ k
    vldr d2, [r2]       @ 1.0
    mov r4, #0          @ counter

loop:
    vdiv.f64 d3, d2, d1  @ 1.0/k
    vadd.f64 d0, d0, d3  @ sum +=
    vadd.f64 d1, d1, d2  @ k += 1.0
    add r4, r4, #1

    @ Check for convergence
    vdiv.f64 d4, d2, d1
    vadd.f64 d5, d0, d4
    vcmp.f64 d5, d0
    vmrs APSR_nzcv, fpscr
    bne loop

    @ Print results
    vmov r2, r3, d0     @ sum to r2:r3
    mov r1, r4          @ counter
    ldr r0, =format
    bl printf

    @ Exit
    mov r0, #0
    pop {r4, pc}

.size main, .-main
