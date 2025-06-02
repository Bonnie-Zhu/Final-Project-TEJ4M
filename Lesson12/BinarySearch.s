/* -- BinarySearch.s */
.data
array: .word 1, 3, 5, 7, 9, 11, 13, 15, 17, 19
length: .word 10
target: .word 13
result_msg: .asciz "Found at index: %d\n"
not_found_msg: .asciz "Target not found\n"

.text
.global main

binary_search:
    ldr r4, =array       @ Load array address
    ldr r5, =length      @ Load length address
    ldr r5, [r5]         @ r5 = length
    mov r2, #0           @ low = 0
    sub r6, r5, #1       @ high = length - 1

search_loop:
    cmp r2, r6           @ while (low <= high)
    bgt not_found

    add r3, r2, r6       @ mid = low + high
    mov r3, r3, ASR #1   @ mid = (low + high) / 2

    ldr r7, [r4, r3, LSL #2] @ Load array[mid]

    cmp r7, r1           @ Compare array[mid] and target
    moveq r0, r3         @ If equal, return mid (predicated)
    bxeq lr              @ Early exit if found (predicated)
    addlt r2, r3, #1     @ If mid < target, low = mid + 1 (predicated)
    subgt r6, r3, #1     @ If mid > target, high = mid - 1 (predicated)
    b search_loop

not_found:
    mov r0, #-1          @ Return -1 if not found
    bx lr

main:
    push {lr}
    ldr r1, =target
    ldr r1, [r1]         @ r1 = target value (13)
    bl binary_search

    cmp r0, #-1
    ldreq r0, =not_found_msg
    ldrne r0, =result_msg
    movne r1, r0         @ Pass index to printf
    bl printf

    pop {lr}
    bx lr
