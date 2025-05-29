/* -- reverse_list.s */
.data
list: .word 1, 2, 3, 4, 5, 0 @ Null-terminated list
msg: .asciz "%d "

.text
.global main

@ Recursive list reversal
@ Input: r0 = array address, r1 = start index, r2 = end index
reverse_list:
    cmp r1, r2
    bxge lr          @ Return if start >= end
    
    @ Load elements
    ldr r3, [r0, r1, LSL #2]  @ arr[start]
    ldr r4, [r0, r2, LSL #2]  @ arr[end]
    
    @ Swap them
    str r4, [r0, r1, LSL #2]  @ arr[start] = arr[end]
    str r3, [r0, r2, LSL #2]  @ arr[end] = arr[start]
    
    @ Recurse
    push {lr}
    add r1, r1, #1   @ start++
    sub r2, r2, #1   @ end--
    bl reverse_list
    pop {lr}
    bx lr

@ Helper to print list
print_list:
    push {r4, lr}
    mov r4, r0
    mov r1, #0
print_loop:
    ldr r2, [r4], #4
    cmp r2, #0
    beq print_done
    ldr r0, =msg
    bl printf
    b print_loop
print_done:
    mov r0, #10      @ Newline
    bl putchar
    pop {r4, lr}
    bx lr

main:
    push {lr}
    
    @ Print original list
    ldr r0, =list
    bl print_list
    
    @ Reverse the list
    ldr r0, =list
    mov r1, #0       @ Start index
    mov r2, #4       @ End index (0-based, adjust as needed)
    bl reverse_list
    
    @ Print reversed list
    ldr r0, =list
    bl print_list
    
    pop {lr}
    bx lr
