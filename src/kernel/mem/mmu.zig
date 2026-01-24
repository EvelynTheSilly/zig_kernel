const std = @import("std");

const tcr_el1 = packed struct {
    T0SZ: u6, // table 0 size
    _reserved: u1,
    EPD0: u1,
    IRGN0: u2,
    ORGN0: u2,
    SH0: u2,
    TG0: u2,
    T1SZ: u6, // table 1 size
    A1: u1,
    EPD1: u1,
    IRGN1: u2,
    ORGN1: u2,
    SH1: u2,
    TG1: u2,
    IPS: u3,
    unused: u29, // unused bits to pack it up
};

/// memory attribute table
/// assigns attribute 1 and attribute 2 as packed u8s
///
/// attr examples:
/// - 0b11111111: full rights memory, basically just normal ram
/// - 0b00000000: no rights device memory
const mair_el1 = packed struct {
    attr0: u8, // AttrIndex[0]
    attr1: u8, // AttrIndex[1]
    attr2: u8,
    attr3: u8,
    attr4: u8,
    attr5: u8,
    attr6: u8,
    attr7: u8,
};

/// The register that holds the physical address of the root page table.
const ttbr_el1 = packed struct {
    /// CnP: Common not Private. Usually 0 (entries can be cached for this CPU).
    CnP: u1,

    /// BADDR: Base Physical Address of the translation table.
    /// In 48-bit config, this is bits [47:1] of the address.
    /// Since tables are 4KB aligned, the bottom bits are implicitly 0.
    baddr: u47,

    /// ASID: Address Space ID.
    asid: u16,
};

/// Block Descriptor (Maps memory directly)
/// We will use this at Level 2 to map 2MB blocks.
const BlockDescriptor = packed struct {
    valid: u1 = 1, // Must be 1
    type: u1 = 0, // 0 = Block (THIS IS KEY: 01 binary)

    /// Memory Attributes (MAIR Index)
    /// 1 = Device, 0 = Normal (matches your MAIR setup)
    attr_index: u3,

    /// Permissions
    ns: u1 = 0, // Non-Secure
    ap: u2, // 00=RW_EL1, 01=RW_Any, 10=RO_EL1, 11=RO_Any
    sh: u2, // Shareability (00=Non, 10=Outer, 11=Inner)
    af: u1, // Access Flag (Must be 1 to prevent hardware fault)
    ng: u1 = 0, // Not Global

    reserved1: u9 = 0,

    /// Output Physical Address
    /// For a 2MB block, bits [47:21] are the address.
    output_addr: u27,

    reserved2: u16 = 0,
};

comptime {
    if (@bitSizeOf(tcr_el1) != 64) {
        @compileError("invalid size for tcr_el1");
    }
    if (@bitSizeOf(mair_el1) != 64) {
        @compileError("invalid size for mair_el1");
    }
}

fn set_ttbr0_el1(value: u64) void {
    asm volatile (
        \\ msr ttbr0_el1, %[val]
        \\ isb
        :
        : [val] "r" (value),
        : .{ .memory = true });
}

fn set_ttbr1_el1(value: u64) void {
    asm volatile (
        \\ msr ttbr1_el1, %[val]
        \\ isb
        :
        : [val] "r" (value),
        : .{ .memory = true });
}

fn get_phys_addr(ptr: *anyopaque) u64 {
    return @intFromPtr(ptr);
}

// A 48-bit Virtual Address with 4KB pages requires 4 levels of translation.
// 48 bits = 9 (L0) + 9 (L1) + 9 (L2) + 9 (L3) + 12 (Offset).
// Each table contains 512 entries (2^9).

const ENTRY_COUNT = 512;

/// The Level 0 Table for TTBR0 (Lower / User space 0x0000...)
/// Must be aligned to 4KB (4096 bytes).
var ttbr0_l0: [ENTRY_COUNT]u64 align(4096) = undefined;

/// The Level 0 Table for TTBR1 (Upper / Kernel space 0xFFFF...)
/// Must be aligned to 4KB (4096 bytes).
var ttbr1_l0: [ENTRY_COUNT]u64 align(4096) = undefined;

pub fn init_mmu() void {

    // 1. Setup MAIR (Memory Attributes)
    // Attr0 = 0xFF (Normal Memory, Write-Back, Outer/Inner Shareable)
    // Attr1 = 0x00 (Device Memory, nGnRnE)
    // the rest being unused
    const mair_val = mair_el1{
        .attr0 = 0xFF, // normal mem
        .attr1 = 0x00, // dev mem
        .attr2 = 0,
        .attr3 = 0,
        .attr4 = 0,
        .attr5 = 0,
        .attr6 = 0,
        .attr7 = 0,
    };
    asm volatile ("msr mair_el1, %[v]"
        :
        : [v] "r" (@as(u64, @bitCast(mair_val))),
    );

    // 2. Setup TCR (Translation Control)
    // For 48-bit VA, TxSZ is 16 (64 - 48 = 16).
    const tcr_val = tcr_el1{
        // --- TTBR0 (User) ---
        .T0SZ = 16,
        .EPD0 = 0, // Enable walks
        .IRGN0 = 0b01, // Normal WBWA
        .ORGN0 = 0b01, // Normal WBWA
        .SH0 = 0b11, // Inner Shareable
        .TG0 = 0b00, // 4KB Granule (Note: 00 for 4KB on TG0)

        // --- TTBR1 (Kernel) ---
        .T1SZ = 16,
        .A1 = 0, // ASID from TTBR0 usually
        .EPD1 = 0, // Enable walks
        .IRGN1 = 0b01, // Normal WBWA
        .ORGN1 = 0b01, // Normal WBWA
        .SH1 = 0b11, // Inner Shareable
        .TG1 = 0b10, // 4KB Granule (Note: 10 for 4KB on TG1)

        .IPS = 0b101, // 48-bit Physical Address
    };
    asm volatile ("msr tcr_el1, %[v]"
        :
        : [v] "r" (@as(u64, @bitCast(tcr_val))),
    );

    // 3. Point TTBRs to our tables
    // We cast our struct to u64 for the register write
    const ttbr0_l0_value = ttbr_el1{
        .CnP = 0,
        .baddr = @truncate(get_phys_addr(&ttbr0_l0) >> 1), // Bit hackery: BADDR is bits 47:1
        .asid = 0,
    };
    const ttbr1_l0_value = ttbr_el1{
        .CnP = 0,
        .baddr = @truncate(get_phys_addr(&ttbr0_l0) >> 1), // Bit hackery: BADDR is bits 47:1
        .asid = 0,
    };
    // Easier way to set TTBR is often just raw u64 because the BADDR shift in packed structs is confusing
    // TTBR_EL1 = (PhysAddr & 0x0000_FFFF_FFFF_F000) | (ASID << 48)
    const ttbr0_raw = get_phys_addr(&ttbr0_l0_value);
    const ttbr1_raw = get_phys_addr(&ttbr1_l0_value);

    set_ttbr0_el1(ttbr0_raw);
    set_ttbr1_el1(ttbr1_raw);

    // 4. IMPORTANT: You must populate the tables before turning on the MMU (SCTLR_EL1.M = 1)
}
