.syntax unified
.cpu cortex-a53
.fpu neon-fp-armv8

.data
@ Hilbert matrix H₃ elements (row-major)
h11: .double 1.0
h12: .double 0.5
h13: .double 0.3333333333
h21: .double 0.5
h22: .double 0.3333333333
h23: .double 0.25
h31: .double 0.3333333333
h32: .double 0.25
h33: .double 0.2

format: .asciz "det(H₃) = %.15f\n"

.text
.global main
main:
    push {lr}
    
    @ Load matrix elements
    vldr d0, h11  @ a
    vldr d1, h12  @ b
    vldr d2, h13  @ c
    vldr d3, h21  @ d
    vldr d4, h22  @ e
    vldr d5, h23  @ f
    vldr d6, h31  @ g
    vldr d7, h32  @ h
    vldr d8, h33  @ i

    @ Compute det(H₃) = a(ei-fh) - b(di-fg) + c(dh-eg)
    @ First term: a(ei-fh)
    vmul.f64 d9, d4, d8   @ ei
    vmls.f64 d9, d5, d7   @ ei - fh
    vmul.f64 d9, d0, d9   @ a*(ei-fh)

    @ Second term: -b(di-fg)
    vmul.f64 d10, d3, d8  @ di
    vmls.f64 d10, d5, d6  @ di - fg
    vnmul.f64 d10, d1, d10 @ -b*(di-fg)

    @ Third term: c(dh-eg)
    vmul.f64 d11, d3, d7  @ dh
    vmls.f64 d11, d4, d6  @ dh - eg
    vmul.f64 d11, d2, d11 @ c*(dh-eg)

    @ Sum all terms
    vadd.f64 d12, d9, d10
    vadd.f64 d12, d12, d11

    @ Print result
    vmov r2, r3, d12
    ldr r0, =format
    bl printf

    mov r0, #0
    pop {pc}
