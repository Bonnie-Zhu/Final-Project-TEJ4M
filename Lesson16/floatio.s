/* -- floatio.s -- */
.arch armv7-a            @ Specify ARMv7 architecture (supports VFP)
.fpu vfpv3               @ Enable VFPv3 floating-point unit
.syntax unified          @ Use unified syntax (supports both ARM/Thumb)

.text
.global _start

_start:
    push {r4-r11, lr}    @ Save additional registers if needed

    /* Prompt for filename */
    mov r0, #1
    ldr r1, =filename_prompt
    ldr r2, =filename_prompt_end
    sub r2, r2, r1
    mov r7, #4           @ sys_write
    svc 0

    /* Read filename */
    mov r0, #0           @ stdin
    ldr r1, =input_filename
    mov r2, #100         @ max length
    mov r7, #3           @ sys_read
    svc 0

    /* Remove newline */
    ldr r1, =input_filename
    add r1, r1, r0       @ r0 = bytes read
    sub r1, #1           @ move back to newline
    mov r2, #0           @ null terminator
    strb r2, [r1]        @ replace '\n' with '\0'

    /* Open file */
    ldr r0, =input_filename
    mov r1, #0           @ O_RDONLY
    mov r7, #5           @ sys_open
    svc 0

    cmp r0, #-1
    beq open_error

    mov r4, r0           @ Save file descriptor

    /* Read floats from file */
    ldr r1, =float_buffer
    mov r2, #400         @ 100 floats * 4 bytes
    mov r7, #3           @ sys_read
    svc 0

    mov r5, r0           @ Bytes read
    cmp r5, #0
    ble read_error

    /* Close file */
    mov r0, r4
    mov r7, #6           @ sys_close
    svc 0

    /* Print array header */
    mov r0, #1
    ldr r1, =array_header
    ldr r2, =array_header_end
    sub r2, r2, r1
    mov r7, #4           @ sys_write
    svc 0

    /* Print floats */
    mov r6, #0           @ Counter
    ldr r4, =float_buffer

print_loop:
    cmp r6, r5, lsr #2   @ r5 (bytes) / 4 = float count
    bge print_done

    /* Load float into FPU */
    ldr r0, [r4], #4     @ Load float, increment pointer
    vmov s0, r0          @ Move to FPU register (VFP)
    vcvt.f64.f32 d0, s0  @ Convert to double

    /* Convert to string */
    ldr r0, =float_str
    bl ftoa

    /* Print float string */
    mov r0, #1
    ldr r1, =float_str
    mov r2, #16          @ Max length
    mov r7, #4           @ sys_write
    svc 0

    /* Print newline */
    mov r0, #1
    ldr r1, =newline
    mov r2, #1
    mov r7, #4
    svc 0

    add r6, r6, #1       @ Increment counter
    b print_loop

print_done:
    b exit

open_error:
    mov r0, #1
    ldr r1, =open_error_msg
    ldr r2, =open_error_msg_end
    sub r2, r2, r1
    mov r7, #4
    svc 0
    b exit

read_error:
    mov r0, #1
    ldr r1, =read_error_msg
    ldr r2, =read_error_msg_end
    sub r2, r2, r1
    mov r7, #4
    svc 0

exit:
    pop {r4-r11, lr}
    mov r7, #1           @ sys_exit
    svc 0

/* --- ftoa: Float to ASCII (VFP version) --- */
ftoa:
    push {r1-r5, lr}
    mov r1, r0           @ Buffer address
    mov r2, #0           @ Negative flag

    /* Check if negative */
    vmov r3, d0          @ Check sign bit
    tst r3, #0x8000000000000000
    beq positive
    mov r2, #1
    vneg.f64 d0, d0

positive:
    /* Extract integer part */
    vcvt.u32.f64 s1, d0  @ Convert to integer (truncate)
    vmov r3, s1          @ Get integer part

    /* Convert integer to ASCII */
    mov r4, #10
    mov r5, #0           @ Digit counter

int_loop:
    udiv r0, r3, r4
    mls r3, r0, r4, r3   @ Remainder in r3
    add r3, r3, #'0'
    push {r3}
    add r5, r5, #1
    mov r3, r0
    cmp r3, #0
    bne int_loop

    /* Add negative sign if needed */
    cmp r2, #1
    bne int_digits
    mov r0, #'-'
    strb r0, [r1], #1

int_digits:
    cmp r5, #0
    beq zero_case
    pop {r0}
    strb r0, [r1], #1
    subs r5, r5, #1
    bne int_digits
    b decimal_point

zero_case:
    mov r0, #'0'
    strb r0, [r1], #1

decimal_point:
    mov r0, #'.'
    strb r0, [r1], #1

    /* Fractional part */
    vcvt.f64.u32 d1, s1  @ Convert integer back to float
    vsub.f64 d0, d0, d1  @ Fractional part
    mov r3, #6           @ Precision

frac_loop:
    vmul.f64 d0, d0, #10.0
    vcvt.u32.f64 s2, d0  @ Get digit
    vmov r0, s2
    add r0, r0, #'0'
    strb r0, [r1], #1
    vcvt.f64.u32 d1, s2
    vsub.f64 d0, d0, d1
    subs r3, r3, #1
    bne frac_loop

    /* Null-terminate */
    mov r0, #0
    strb r0, [r1]

    pop {r1-r5, lr}
    bx lr

.data
filename_prompt: .asciz "Enter filename containing float array: "
filename_prompt_end:
input_filename: .space 100
float_buffer: .space 400        @ 100 floats * 4 bytes
float_str: .space 16
array_header: .asciz "Array contents:\n"
array_header_end:
newline: .asciz "\n"
open_error_msg: .asciz "Error opening file.\n"
open_error_msg_end:
read_error_msg: .asciz "Error reading file.\n"
read_error_msg_end:
