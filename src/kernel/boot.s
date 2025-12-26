.global _Reset
_Reset:                                     // starts in el2
    b el1_start

    // --- ALL OF THIS ISNT NECASARY ---
    // all of this is setup for exiting el2
    // i thought i was in el2
    // i am not, never was, no clue why i thought i got there

    // stack for EL2 (must exist or sync exception explodes)
    ldr x0, =el2_stack_top
    mov sp, x0

    isb
    // reuse EL1 vectors (good enough)
    ldr x0, =_vector_table
    msr VBAR_EL2, x0
    isb

    // allow EL1 to run AArch64
    mrs x0, HCR_EL2
    orr x0, x0, #(1 << 31)   // HCR_EL2.RW = 1
    msr HCR_EL2, x0
    isb

    // set EL1 stack
    ldr x0, =el1_stack_top
    msr SP_EL1, x0

    // set EL1 entry point
    ldr x0, =el1_start
    msr ELR_EL2, x0

    // return state → EL1h
    mov x0, #(0b0101)        // EL1h, interrupts masked
    msr SPSR_EL2, x0

    eret






.global el0_start
el0_start:
    mov x0, #42                             // example syscall argument
    svc #0                                  // triggers synchronous exception to EL1
    b .

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

.macro DUMP_REGISTERS
    stp     x19, x20, [sp, #-16]!
    stp     x21, x22, [sp, #-16]!
    stp     x23, x24, [sp, #-16]!
    stp     x25, x26, [sp, #-16]!
    stp     x27, x28, [sp, #-16]!
    stp     x29, x30, [sp, #-16]!
.endm

.macro LOAD_REGISTERS
    ldp     x29, x30, [sp], #16
    ldp     x27, x28, [sp], #16
    ldp     x25, x26, [sp], #16
    ldp     x23, x24, [sp], #16
    ldp     x21, x22, [sp], #16
    ldp     x19, x20, [sp], #16
.endm

.section .vectors, "ax"
.align 11                                   // 2KB alignment required
.global _vector_table
_vector_table:

// ========== Exceptions from EL1 ==========
// ================== sp0 ==================
el1_sp0_sync:
    DUMP_REGISTERS

    bl el1_sp0_sync_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el1_sp0_sync)

el1_sp0_irq:
    DUMP_REGISTERS

    bl el1_sp0_irq_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el1_sp0_irq)

el1_sp0_fiq:
    DUMP_REGISTERS

    bl el1_sp0_fiq_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el1_sp0_fiq)

el1_sp0_serror:
    DUMP_REGISTERS

    bl el1_sp0_serror_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el1_sp0_serror)

// ================== spx ==================
el1_spx_sync:
    DUMP_REGISTERS

    bl el1_spx_sync_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el1_spx_sync)

el1_spx_irq:
    DUMP_REGISTERS

    bl el1_spx_irq_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el1_spx_irq)

el1_spx_fiq:
    DUMP_REGISTERS

    bl el1_spx_fiq_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el1_spx_fiq)

el1_spx_serror:
    DUMP_REGISTERS

    bl el1_spx_serror_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el1_spx_serror)

// ========== Exceptions from EL0 ==========
// ================ AArch64 ================
el0_aarch64_sync:
    DUMP_REGISTERS

    bl el0_aarch64_sync_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el0_aarch64_sync)

el0_aarch64_irq:
    DUMP_REGISTERS

    bl el0_aarch64_irq_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el0_aarch64_irq)

el0_aarch64_fiq:
    DUMP_REGISTERS

    bl el0_aarch64_fiq_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el0_aarch64_fiq)

el0_aarch64_serror:
    DUMP_REGISTERS

    bl el0_aarch64_serror_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el0_aarch64_serror)

// ================ AArch32 ================
el0_aarch32_sync:
    DUMP_REGISTERS

    bl el0_aarch32_sync_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el0_aarch32_sync)

el0_aarch32_irq:
    DUMP_REGISTERS

    bl el0_aarch32_irq_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el0_aarch32_irq)

el0_aarch32_fiq:
    DUMP_REGISTERS

    bl el0_aarch32_fiq_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el0_aarch32_fiq)

el0_aarch32_serror:
    DUMP_REGISTERS

    bl el0_aarch32_serror_handler

    LOAD_REGISTERS

    eret
    .space 128 - (. - el0_aarch32_serror)
