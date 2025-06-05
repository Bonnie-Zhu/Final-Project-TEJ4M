.section .note.GNU-stack,"",%progbits

.data
.align 2
format: .asciz "Factorial of %d is %.0f\n"
oneval: .float 1.0

.text
.global main
.extern printf

main:
    push {lr}

    mov r4, #10              @ Calculate factorial of 10 (change as needed)

    vmov s0, r4              @ s0 = n
    vcvt.f32.s32 s0, s0

    ldr r0, =oneval
    vldr s1, [r0]            @ s1 = result = 1.0
    vldr s2, [r0]            @ s2 = constant 1.0

loop:
    vmul.f32 s1, s1, s0      @ result *= n
    vsub.f32 s0, s0, s2      @ n -= 1

    vcmp.f32 s0, s2          @ if n > 1.0
    vmrs APSR_nzcv, FPSCR
    bgt loop

    vcvt.f64.f32 d0, s1      @ convert to double
    ldr r0, =format
    mov r1, r4
    vmov r2, r3, d0
    bl printf

    mov r0, #0
    pop {pc}
