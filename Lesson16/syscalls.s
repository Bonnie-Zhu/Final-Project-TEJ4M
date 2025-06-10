/* -- syscalls.s -- */
.text
.global _start

_start:
    push {r4, lr}

    /* Get and display current time */
    ldr r0, =time_buffer       @ buffer for time_t
    mov r7, #13                @ time syscall
    svc 0

    cmp r0, #-1                @ check for error
    beq time_error

    /* Convert time to string */
    ldr r0, =time_buffer
    ldr r0, [r0]               @ load time value
    ldr r1, =time_str
    bl ctime                   @ convert to string

    /* Print time string */
    mov r0, #1
    ldr r1, =time_header
    mov r2, #(time_header_end - time_header)
    mov r7, #4
    svc 0

    mov r0, #1
    ldr r1, =time_str
    mov r2, #26                @ length of ctime string
    mov r7, #4
    svc 0

    /* Create a directory */
    ldr r0, =dir_name          @ directory name
    mov r1, #0755              @ permissions (rwxr-xr-x)
    mov r7, #39                @ mkdir syscall
    svc 0

    cmp r0, #-1                @ check for error
    beq dir_error

    /* Success message */
    mov r0, #1
    ldr r1, =dir_success_msg
    mov r2, #(dir_success_msg_end - dir_success_msg)
    mov r7, #4
    svc 0

    b exit

time_error:
    mov r0, #1
    ldr r1, =time_error_msg
    mov r2, #(time_error_msg_end - time_error_msg)
    mov r7, #4
    svc 0
    b exit

dir_error:
    mov r0, #1
    ldr r1, =dir_error_msg
    mov r2, #(dir_error_msg_end - dir_error_msg)
    mov r7, #4
    svc 0

exit:
    pop {r4, lr}
    mov r7, #1
    svc 0

/* Simple ctime implementation */
/* r0 = time_t, r1 = buffer */
ctime:
    push {r4-r6, lr}
    /* This would normally call localtime and format the string */
    /* For simplicity, we'll just return a placeholder */
    ldr r2, =time_format
    mov r3, #0

copy_loop:
    ldrb r4, [r2, r3]
    cmp r4, #0
    beq copy_done
    strb r4, [r1, r3]
    add r3, r3, #1
    b copy_loop

copy_done:
    pop {r4-r6, lr}
    bx lr

.data
time_buffer: .word 0
time_str: .space 26
time_header: .asciz "Current time is: "
time_header_end:
time_format: .asciz "Wed Jun 10 12:00:00 2023\n"
time_error_msg: .asciz "Error getting time.\n"
time_error_msg_end:
dir_name: .asciz "new_directory"
dir_success_msg: .asciz "Directory created successfully.\n"
dir_success_msg_end:
dir_error_msg: .asciz "Error creating directory.\n"
dir_error_msg_end:
