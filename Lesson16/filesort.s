/* -- filesort.s -- */
.text
.global _start

_start:
    push {r4-r8, lr}

    /* Prompt for filename */
    mov r0, #1                  @ stdout
    ldr r1, =filename_prompt    @ prompt message
    mov r2, #(filename_prompt_end - filename_prompt) @ length
    mov r7, #4                  @ write syscall
    svc 0

    /* Read filename input */
    mov r0, #0                  @ stdin
    ldr r1, =input_filename     @ buffer for filename
    mov r2, #100                @ max length
    mov r7, #3                  @ read syscall
    svc 0

    /* Remove newline from filename */
    ldr r1, =input_filename
    add r1, r1, r0              @ point to end of string
    sub r1, #1                  @ back one byte
    mov r2, #0                  @ null terminator
    strb r2, [r1]               @ replace newline

    /* Open input file */
    ldr r0, =input_filename     @ filename
    mov r1, #0                  @ read-only flag
    mov r2, #0                  @ mode (ignored for read)
    mov r7, #5                  @ open syscall
    svc 0

    cmp r0, #-1                 @ check for error
    beq open_error

    mov r4, r0                  @ save file descriptor

    /* Read file contents */
    ldr r1, =buffer             @ buffer address
    mov r2, #1000               @ max bytes to read
    mov r7, #3                  @ read syscall
    svc 0

    mov r5, r0                  @ save number of bytes read
    cmp r5, #0                  @ check if read failed
    ble read_error

    /* Close input file */
    mov r0, r4                  @ file descriptor
    mov r7, #6                  @ close syscall
    svc 0

    /* Sort the buffer */
    ldr r0, =buffer             @ array start
    mov r1, r5                  @ number of elements
    bl insertion_sort           @ call sort routine

    /* Open file for writing (truncate) */
    ldr r0, =input_filename     @ filename
    mov r1, #0x201              @ O_WRONLY|O_TRUNC
    mov r2, #0644               @ permissions
    mov r7, #5                  @ open syscall
    svc 0

    cmp r0, #-1                 @ check for error
    beq open_error

    mov r4, r0                  @ save file descriptor

    /* Write sorted data back to file */
    ldr r1, =buffer             @ buffer address
    mov r2, r5                  @ number of bytes to write
    mov r7, #4                  @ write syscall
    svc 0

    /* Close output file */
    mov r0, r4                  @ file descriptor
    mov r7, #6                  @ close syscall
    svc 0

    /* Success message */
    mov r0, #1                  @ stdout
    ldr r1, =success_msg        @ message
    mov r2, #(success_msg_end - success_msg) @ length
    mov r7, #4                  @ write syscall
    svc 0

    b exit

open_error:
    mov r0, #1                  @ stdout
    ldr r1, =open_error_msg     @ error message
    mov r2, #(open_error_msg_end - open_error_msg) @ length
    mov r7, #4                  @ write syscall
    svc 0
    b exit

read_error:
    mov r0, #1                  @ stdout
    ldr r1, =read_error_msg     @ error message
    mov r2, #(read_error_msg_end - read_error_msg) @ length
    mov r7, #4                  @ write syscall
    svc 0

exit:
    pop {r4-r8, lr}
    mov r7, #1                  @ exit syscall
    svc 0

/* Insertion sort routine */
insertion_sort:
    /* r0 = array address, r1 = length */
    push {r4-r7, lr}
    mov r4, #1                  @ i = 1

outer_loop:
    cmp r4, r1                  @ i < length?
    bge sort_done

    ldrb r5, [r0, r4]           @ key = array[i]
    sub r6, r4, #1              @ j = i - 1

inner_loop:
    cmp r6, #0                  @ j >= 0?
    blt inner_done
    ldrb r7, [r0, r6]           @ array[j]
    cmp r7, r5                  @ array[j] > key?
    ble inner_done

    add r2, r6, #1              @ j+1
    strb r7, [r0, r2]           @ array[j+1] = array[j]
    sub r6, r6, #1              @ j--
    b inner_loop

inner_done:
    add r2, r6, #1              @ j+1
    strb r5, [r0, r2]           @ array[j+1] = key
    add r4, r4, #1              @ i++
    b outer_loop

sort_done:
    pop {r4-r7, lr}
    bx lr

.data
filename_prompt: .asciz "Enter filename to sort: "
filename_prompt_end:
input_filename: .space 100
buffer: .space 1000
success_msg: .asciz "File sorted successfully.\n"
success_msg_end:
open_error_msg: .asciz "Error opening file.\n"
open_error_msg_end:
read_error_msg: .asciz "Error reading file.\n"
read_error_msg_end:
