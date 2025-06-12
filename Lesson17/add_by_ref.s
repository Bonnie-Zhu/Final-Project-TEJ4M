/* add_by_ref.s */
.data
message: .asciz "The sum of %d and %d is %d\n"
a: .word 5
b: .word 7

.text
.globl main

/* Function that adds two numbers passed by reference */
add_by_ref:
    push {fp, lr}       /* Save frame pointer and return address */
    mov fp, sp         /* Establish new stack frame */
    
    /* Load the values from the references */
    ldr r2, [r0]       /* Load first value from address in r0 */
    ldr r3, [r1]       /* Load second value from address in r1 */
    
    /* Perform addition */
    add r0, r2, r3     /* Store result in r0 */
    
    mov sp, fp         /* Restore stack pointer */
    pop {fp, lr}       /* Restore frame pointer and return address */
    bx lr              /* Return */

main:
    push {fp, lr}      /* Save frame pointer and return address */
    
    /* Pass addresses of a and b */
    ldr r0, =a         /* Load address of a into r0 */
    ldr r1, =b         /* Load address of b into r1 */
    bl add_by_ref      /* Call the function */
    
    /* Prepare for printf call */
    mov r3, r0         /* Result from add_by_ref */
    ldr r2, =b
    ldr r2, [r2]       /* Value of b */
    ldr r1, =a
    ldr r1, [r1]       /* Value of a */
    ldr r0, =message   /* Format string */
    bl printf          /* Call printf */
    
    pop {fp, lr}       /* Restore frame pointer and return address */
    bx lr              /* Return to system */
