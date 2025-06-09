/* print_float_array.s - prints an array of floats */

.data
float_array:
    .float 1.1, 2.2, 3.3, 4.4, 5.5
float_array_end:
    .word 0  /* Just a marker */

message:
    .asciz "Float value: %f\n"

.text
.globl main

main:
    push {r4-r5, lr}
    
    ldr r4, =float_array    /* r4 = pointer to array */
    mov r5, #0              /* r5 = counter */
    
print_loop:
    cmp r5, #5
    bge end_print
    
    /* Load float value into s0 */
    vldr s0, [r4]
    
    /* Convert to double in d0 for printf */
    vcvt.f64.f32 d0, s0
    
    /* Prepare and call printf */
    ldr r0, =message
    vmov r2, r3, d0
    bl printf
    
    add r4, r4, #4    /* Move to next float (4 bytes) */
    add r5, r5, #1    /* Increment counter */
    b print_loop
    
end_print:
    pop {r4-r5, lr}
    bx lr
