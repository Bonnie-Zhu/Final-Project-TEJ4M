/* -- lseekdemo.s -- */
.text
.global _start
_start:
    push {r4-r6, lr}

    /* Open file */
    ldr r0, =filename
    mov r1, #0x42       @ O_RDWR|O_CREAT
    mov r2, #384        @ 600 octal
    mov r7, #5          @ open
    svc 0
    cmp r0, #-1
    beq error
    mov r4, r0          @ save fd

    /* Write initial data */
    ldr r1, =data1
    mov r2, #(data1end - data1)
    mov r7, #4          @ write
    svc 0

    /* Seek to position 5 */
    mov r0, r4          @ fd
    mov r1, #5          @ offset
    mov r2, #0          @ SEEK_SET
    mov r7, #19         @ lseek
    svc 0

    /* Write more data */
    ldr r1, =data2
    mov r2, #(data2end - data2)
    mov r7, #4          @ write
    svc 0

    /* Close file */
    mov r0, r4
    mov r7, #6          @ close
    svc 0

    b exit

error:
    ldr r1, =errmsg
    mov r2, #(errmsgend - errmsg)
    mov r0, #1          @ stdout
    mov r7, #4          @ write
    svc 0

exit:
    mov r7, #1          @ exit
    svc 0

.data
filename: .asciz "/home/bonnie/lseektest.txt"
data1: .asciz "Hello World\n"
data1end:
data2: .asciz "INSERTED"
data2end:
errmsg: .asciz "Error occurred\n"
errmsgend:
