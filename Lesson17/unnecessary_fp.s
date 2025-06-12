/* unnecessary_fp.s */
.data
message: .asciz "The result is %d\n"

.text
/* Function that doubles a number using unnecessary frame pointer */
double:
    push {fp, lr}      /* Save frame pointer and return address */
    mov fp, sp         /* Establish stack frame (unnecessary) */
    
    /* Could just do 'add r0, r0, r0' but we'll use local storage */
    sub sp, sp, #4     /* Allocate space for local var (unnecessary) */
    str r0, [fp, #-4]  /* Store parameter in local storage */
    ldr r0, [fp, #-4]  /* Load it back */
    add r0, r0, r0     /* Double the value */
    
    mov sp, fp         /* Restore stack pointer */
    pop {fp, lr}       /* Restore frame pointer and return address */
    bx lr              /* Return */

.globl main
main:
    push {fp, lr}      /* Save frame pointer and return address */
    
    mov r0, #5        /* Value to double */
    bl double         /* Call the function */
    
    /* Print result */
    mov r1, r0        /* Result from double */
    ldr r0, =message  /* Format string */
    bl printf         /* Call printf */
    
    pop {fp, lr}      /* Restore frame pointer and return address */
    bx lr             /* Return to system */
