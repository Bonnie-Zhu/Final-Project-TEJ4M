/* -- create_exist.s -- */
.text
.global _start
_start:
    push {r4, lr}

    /* OPEN (CREATE) FILE */
    ldr r0, =newfile
    mov r1, #0x42       @ O_RDWR|O_CREAT
    mov r2, #384        @ 600 octal permissions
    mov r7, #5          @ open
    svc 0

    cmp r0, #-1         @ check for error
    beq err

    mov r4, r0          @ save file descriptor

    /* WRITE TO FILE */
    mov r0, r4
    ldr r1, =testdata
    mov r2, #(testdataend - testdata)
    mov r7, #4          @ write
    svc 0

    /* CLOSE FILE */
    mov r0, r4
    mov r7, #6          @ close
    svc 0

    b exit

err:
    ldr r1, =errmsg
    mov r2, #(errmsgend - errmsg)
    mov r7, #4          @ write
    svc 0

exit:
    mov r7, #1          @ exit
    svc 0

.data
errmsg: .asciz "Error opening file\n"
errmsgend:
newfile: .asciz "/home/bonnie/testfile.txt"
testdata: .asciz "This is test data\n"
testdataend:
