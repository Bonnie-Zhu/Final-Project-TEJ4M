.global main
.global printf

.section .text

main:
    push {lr}               @ Save link register
    
    @ Create test list: Node1 -> Node2 -> Node3 -> NULL
    ldr r0, =node1          @ Load address of first node
    bl list_length          @ Call list_length function
    
    @ Print the result
    mov r1, r0              @ Move length to second argument
    ldr r0, =length_str     @ Load format string
    bl printf              @ Call printf
    
    mov r0, #0              @ Return 0 from main
    pop {lr}               @ Restore link register
    bx lr                  @ Return from main

list_length:
    push {lr}              @ Save link register
    cmp r0, #0             @ Check if current node is NULL
    beq end_list_length    @ If NULL, return 0
    
    ldr r1, [r0, #4]       @ Load next node pointer
    mov r0, r1             @ Move next node to first argument
    bl list_length         @ Recursive call
    
    add r0, r0, #1         @ Increment count
    b return_list_length   @ Skip the NULL case increment

end_list_length:
    mov r0, #0             @ Return 0 for NULL node

return_list_length:
    pop {lr}              @ Restore link register
    bx lr                 @ Return from function

.section .data
node1: 
    .word 1                @ Data for node1
    .word node2            @ Pointer to next node (node2)
    
node2: 
    .word 2                @ Data for node2
    .word node3            @ Pointer to next node (node3)
    
node3: 
    .word 3                @ Data for node3
    .word 0                @ NULL pointer (end of list)
    
length_str: 
    .asciz "List length: %d\n"
