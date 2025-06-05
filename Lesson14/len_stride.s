/* len_stride.s - Final Working Version */
.section .note.GNU-stack,"",%progbits

.data
.align 2
format: .asciz "len=%d, stride=%d, result=%.2f\n"
values: .float 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0
zero_float: .float 0.0

.text
.global main
.extern printf

main:
    push {r4-r6, lr}

    ldr r0, =values
    vldmia r0, {s16-s23}   @ Load float values into VFP registers

    /* Test case 1: len=4, stride=1 */
    mov r4, #4
    mov r5, #1
    bl test_combo

    /* Test case 2: len=2, stride=2 */
    mov r4, #2
    mov r5, #2
    bl test_combo

    /* Test case 3: len=2, stride=4 */
    mov r4, #2
    mov r5, #4
    bl test_combo

    mov r0, #0
    pop {r4-r6, pc}

test_combo:
    push {r4-r6, lr}

    /* Load 0.0 into s0 (accumulator) */
    ldr r0, =zero_float
    vldr s0, [r0]

    mov r6, #0             @ i = 0

loop_start:
    cmp r6, r4
    bge loop_end

    /* index = i * stride */
    mul r1, r6, r5
    add r2, r1, #16        @ s(16 + index)

    /* Compare against each s register manually */
    cmp r2, #16
    beq add_s16
    cmp r2, #17
    beq add_s17
    cmp r2, #18
    beq add_s18
    cmp r2, #19
    beq add_s19
    cmp r2, #20
    beq add_s20
    cmp r2, #21
    beq add_s21
    cmp r2, #22
    beq add_s22
    cmp r2, #23
    beq add_s23
    b loop_continue

add_s16:
    vadd.f32 s0, s0, s16
    b loop_continue
add_s17:
    vadd.f32 s0, s0, s17
    b loop_continue
add_s18:
    vadd.f32 s0, s0, s18
    b loop_continue
add_s19:
    vadd.f32 s0, s0, s19
    b loop_continue
add_s20:
    vadd.f32 s0, s0, s20
    b loop_continue
add_s21:
    vadd.f32 s0, s0, s21
    b loop_continue
add_s22:
    vadd.f32 s0, s0, s22
    b loop_continue
add_s23:
    vadd.f32 s0, s0, s23
    b loop_continue

loop_continue:
    add r6, r6, #1
    b loop_start

loop_end:
    vcvt.f64.f32 d0, s0
    vmov r2, r3, d0        @ Put result into r2 (low), r3 (high)

    ldr r0, =format
    mov r1, r4             @ len
    mov r4, r5             @ stride
    bl printf

    pop {r4-r6, pc}
