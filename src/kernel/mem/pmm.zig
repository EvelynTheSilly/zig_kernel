/// phsysial memory manager
///
const std = @import("std");
const get_kernel_code_start = @import("shared.zig").get_kernel_code_start;
const get_kernel_code_end = @import("shared.zig").get_kernel_code_end;

const PAGE_SIZE = 4096; // 4kb
const RAM_START = 0x40000000; // QEMU 'virt' usually starts RAM here
const RAM_SIZE = 1024 * 1024 * 1024; // Assume 1GB
const TOTAL_PAGES = RAM_SIZE / PAGE_SIZE;

// A simple bitmap. 1 bit per page.
// will likely be a arraybitset... unless you have like 256kb. does the same thing either way
var bitmap = std.StaticBitSet(TOTAL_PAGES);

/// SAFETY: assumes the memory passed in is valid and within bounds
/// includes the end page and the start page
fn set_page_region(start_page: u64, end_page: u64, value: bool) void {
    var current_page = start_page;
    while (current_page <= end_page) {
        defer current_page += 1; // increment current page at the end
        bitmap[current_page] = value;
    }
}

fn set_memory_region(mem_start: usize, mem_end: usize, value: bool) void {
    // sanity check for valid range
    if (mem_end <= mem_start) return;

    // Clamp to RAM bounds
    const start = @min(mem_start, RAM_SIZE);
    const end = @min(mem_end, RAM_SIZE);
    if (end <= start) return;

    const first_page = start / PAGE_SIZE;
    const last_page = end / PAGE_SIZE; // greedy: claim even 1 byte

    var page: usize = first_page;
    while (page <= last_page and page < TOTAL_PAGES) : (page += 1) {
        bitmap[page] = value;
    }
}
pub fn init() void {
    // Mark everything as FREE
    set_page_region(0, TOTAL_PAGES, false);

    // Mark the kernel's own code/data as USED
    const kernel_start = get_kernel_code_start();
    const kernel_end = get_kernel_code_end();
    set_memory_region(kernel_start, kernel_end, true);
}

// might be useful to implement later
pub fn alloc_page() ?usize {
    // Scan 'bitmap' for the first '0' bit.
    // Flip it to '1'.
    // Return (index * PAGE_SIZE) + RAM_START;
}
