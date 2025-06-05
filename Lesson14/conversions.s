
/* conversions.s */
/* PROPER DATA SECTION */
.data
int_num: .word 42
float_num: .float 3.14159
double_num: .double 2.71828
format_int: .asciz "Integer: %d\n"
format_float: .asciz "Float: %f\n"
format_double: .asciz "Double: %f\n"

.text
.global main
main:
    /* Load integer */
    ldr r0, =int_num
    ldr r0, [r0]          @ Get actual integer value
    
    /* Convert int to float */
    vmov s0, r0           @ Move to FP register
    vcvt.f32.s32 s0, s0   @ Convert to float
    
    /* Convert to double for printf */
    vcvt.f64.f32 d0, s0
    
    /* Print integer */
    ldr r0, =format_int
    ldr r1, =int_num
    ldr r1, [r1]
    bl printf
    
    /* Print float (as double) */
    ldr r0, =format_float
    vmov r2, r3, d0
    bl printf
    
    /* Load and print actual float */
    ldr r1, =float_num
    vldr s1, [r1]
    vcvt.f64.f32 d1, s1
    ldr r0, =format_float
    vmov r2, r3, d1
    bl printf
    
    /* Exit properly */
    mov r0, #0
    bx lr
