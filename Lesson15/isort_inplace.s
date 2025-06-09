/* isort_inplace.s - insertion sort that sorts an array in-place by address */

.data
array:
    .word 5, 3, 8, 1, 9, 2, 7, 4, 6, 0
array_end:
    .word 0  /* Just a marker */

message:
    .asciz "Sorted array: %d %d %d %d %d %d %d %d %d %d\n"

.text
.globl main

/* Insertion sort function that sorts an array in-place
   Parameters:
   r0 - address of array
   r1 - number of elements */
isort_inplace:
    push {r4-r8, lr}
    
    mov r4, r0        /* r4 = array address */
    mov r5, r1        /* r5 = number of elements */
    mov r6, #1        /* r6 = i (outer loop counter) */
    
outer_loop:
    cmp r6, r5
    bge end_outer
    
    ldr r7, [r4, r6, lsl #2]  /* r7 = key = array[i] */
    sub r8, r6, #1            /* r8 = j = i-1 */
    
inner_loop:
    cmp r8, #0
    blt end_inner
    
    ldr r2, [r4, r8, lsl #2]  /* r2 = array[j] */
    cmp r2, r7
    ble end_inner
    
    add r3, r8, #1
    str r2, [r4, r3, lsl #2]  /* array[j+1] = array[j] */
    sub r8, r8, #1            /* j-- */
    b inner_loop
    
end_inner:
    add r3, r8, #1
    str r7, [r4, r3, lsl #2]  /* array[j+1] = key */
    
    add r6, r6, #1            /* i++ */
    b outer_loop
    
end_outer:
    pop {r4-r8, lr}
    bx lr

main:
    push {r4, lr}
    
    /* Call isort_inplace */
    ldr r0, =array        /* r0 = address of array */
    mov r1, #10           /* r1 = number of elements */
    bl isort_inplace
    
    /* Print sorted array */
    ldr r0, =message
    ldr r1, =array
    ldr r1, [r1]
    ldr r2, =array
    ldr r2, [r2, #4]
    ldr r3, =array
    ldr r3, [r3, #8]
    ldr r4, =array
    ldr r4, [r4, #12]
    ldr r5, =array
    ldr r5, [r5, #16]
    ldr r6, =array
    ldr r6, [r6, #20]
    ldr r7, =array
    ldr r7, [r7, #24]
    ldr r8, =array
    ldr r8, [r8, #28]
    ldr r9, =array
    ldr r9, [r9, #32]
    ldr r10, =array
    ldr r10, [r10, #36]
    push {r10}
    bl printf
    add sp, sp, #4
    
    pop {r4, lr}
    bx lr
