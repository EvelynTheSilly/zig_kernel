.global _Reset
_Reset:
    ldr x30, =stack_top	                    // setup stack
    mov sp, x30                             // load stack pointer
    ldr x0, =_vector_table                  // load vtable into r0
    msr VBAR_EL1, x0
    isb              // move r0 to base vector table register
    bl _entry                               // go to zig entry point
    b .                                     // hang forever


.section .vectors, "ax"
.align 11                // 2KB alignment required
.global _vector_table
_vector_table:

// ========== Exceptions from EL0 ==========
el0_sync:
    b el0_sync_handler
    .space 128 - (. - el0_sync)

el0_irq:
    b el0_irq_handler
    .space 128 - (. - el0_irq)

el0_fiq:
    b el0_fiq_handler
    .space 128 - (. - el0_fiq)

el0_serror:
    b el0_serror_handler
    .space 128 - (. - el0_serror)

// ========== Exceptions from EL1 ==========
el1_sync:
    b el1_sync_handler
    .space 128 - (. - el1_sync)

el1_irq:
    b el1_irq_handler
    .space 128 - (. - el1_irq)

el1_fiq:
    b el1_fiq_handler
    .space 128 - (. - el1_fiq)

el1_serror:
    b el1_serror_handler
    .space 128 - (. - el1_serror)
