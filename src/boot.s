.global _Reset
_Reset:                                     // starts in el2
    /* --- Configure any EL1 control registers here (SCTLR_EL1, etc.) if needed --- */
    /* Example (optional): set SCTLR_EL1 to sane defaults later when enabling MMU */

    /* --- Prepare SPSR_EL2 to return to EL1h via ERET ---
       SPSR_EL2.M[3:0] must select EL1h (0b0101) in AArch64.
       Optionally set DAIF bits (interrupt masks) in SPSR to mask IRQ/FIQ/SError if desired.
       Many boot sequences use an immediate like 0x3c5 here (M=0101, DAIF masked). */
    //mov    x2, #0x3c5       // common value: return to EL1h with interrupts masked (verify for your use)
    //msr    spsr_el2, x2

    /* --- Set return address for ERET to el1_start --- */
    adrp   x2, el1_start
    add    x2, x2, :lo12:el1_start
    msr    elr_el2, x2
    isb

    /* drop to EL1 */
    eret


.global el0_start
el0_start:
    mov x0, #42                             // example syscall argument
    svc #0                                  // triggers synchronous exception to EL1
    nop

.global el1_start
el1_start:
    // el1 stack setup
    ldr x30, =stack_top
    mov sp, x30
    ldr x0, =_vector_table                  // load vtable into r0
    msr VBAR_EL1, x0
    isb                                     // move r0 to base vector table register
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
    stp     x19, x20, [sp, #-16]!
    stp     x21, x22, [sp, #-16]!
    stp     x23, x24, [sp, #-16]!
    stp     x25, x26, [sp, #-16]!
    stp     x27, x28, [sp, #-16]!
    stp     x29, x30, [sp, #-16]!
.endm

.section .vectors, "ax"
.align 11                                   // 2KB alignment required
.global _vector_table
_vector_table:

// ========== Exceptions from EL0 ==========
el0_sync:
    DUMP_REGISTERS
    
    bl el0_sync_handler

    LOAD_REGISTERS
    
    eret    
    .space 128 - (. - el0_sync)

el0_irq:
    DUMP_REGISTERS

    bl el0_irq_handler

    LOAD_REGISTERS
    
    eret   
    .space 128 - (. - el0_irq)

el0_fiq:
    DUMP_REGISTERS

    bl el0_fiq_handler

    LOAD_REGISTERS
    
    eret   
    .space 128 - (. - el0_fiq)

el0_serror:
    DUMP_REGISTERS

    bl el0_serror_handler

    LOAD_REGISTERS
    
    eret   
    .space 128 - (. - el0_serror)

// ========== Exceptions from EL1 ==========
el1_sync:
    DUMP_REGISTERS

    bl el1_sync_handler

    LOAD_REGISTERS
    
    eret   
    .space 128 - (. - el1_sync)

el1_irq:
    DUMP_REGISTERS

    bl el1_irq_handler

    LOAD_REGISTERS
    
    eret   
    .space 128 - (. - el1_irq)

el1_fiq:
    DUMP_REGISTERS

    bl el1_fiq_handler

    LOAD_REGISTERS
    
    eret   
    .space 128 - (. - el1_fiq)

el1_serror:
    DUMP_REGISTERS

    bl el1_serror_handler

    LOAD_REGISTERS
    
    eret   
    .space 128 - (. - el1_serror)

// ========== Exceptions from EL2 ==========
el2_sync:
    DUMP_REGISTERS
 
    bl el2_sync_handler

    LOAD_REGISTERS
    
    eret
    .space 128 - (. - el2_sync)

el2_irq:
    DUMP_REGISTERS
 
    bl el2_irq_handler

    LOAD_REGISTERS
    
    eret
    .space 128 - (. - el2_irq)

el2_fiq:
    DUMP_REGISTERS
 
    bl el2_fiq_handler

    LOAD_REGISTERS
    
    eret
    .space 128 - (. - el2_fiq)

el2_serror:
    DUMP_REGISTERS
 
    bl el2_serror_handler

    LOAD_REGISTERS
    
    eret
    .space 128 - (. - el2_serror)
