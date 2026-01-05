.global _Reset
_Reset:                                     // starts in el2
    b el1_start

.global el1_start
el1_start:
    // el1 stack setup
    ldr x0, =el1_stack_top
    mov sp, x0
    // el1 vtable setup
    ldr x0, =_vector_table                  // load vtable into r0
    msr VBAR_EL1, x0
    isb                                     // move r0 to base vector table register
    // enter zig
    b _entry                                // go to zig entry point
    b .                                     // hang forever
