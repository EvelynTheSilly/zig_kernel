.section .rodata
    /* Define the u8 buffer (string).
       We align to 8 bytes for good practice, though not strictly required for u8.
    */
    .align 3
hello_msg:
    .ascii "Hello, World!\n"
hello_msg_end:
    /* Calculate the length by subtracting start address from end address */
    .equ hello_msg_len, hello_msg_end - hello_msg

.section .text
.global _INIT

/* el0_start
   Entry point for EL0 code.
   Assumes the stack pointer (SP_EL0) is already set up by the bootloader/kernel.
*/
_INIT:
    /* 1. Set x0 = 1
       Context: Typically File Descriptor 1 (stdout)
    */
    mov x0, #1

    /* 2. Set x1 = Pointer to buffer
       We use 'adr' (Address Relative) to load the address of the label
       into x1. This is PC-relative and efficient.
    */
    adr x1, hello_msg

    /* 3. Set x2 = Length of buffer
       We load the immediate constant calculated in the .rodata section.
    */
    mov x2, #hello_msg_len

    /* (Optional) Set x8 = Syscall Number
       In Linux ABI, x8 holds the syscall number (Write is 64).
       In bare metal, this depends entirely on your exception handler implementation.
       I have omitted it to strictly follow your prompt constraints.
    */

    /* 4. Execute Supervisor Call
       This triggers a synchronous exception, handing control to the
       EL1 (Kernel) exception vector table.
    */
    svc #0

    /* 5. Hang / Infinite Loop
       If the syscall returns, we trap the CPU here so it doesn't
       execute garbage memory after the function.
    */
hang:
    wfe         // Wait For Event (Low power state)
    b hang
