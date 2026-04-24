; instructions one must never use in x86-64 assembly

DEFAULT REL
GLOBAL  main

SECTION .text

main:
    MOV CR0, RAX     ; never use - modifies control register
    MOV CR2, RAX     ; page-fault address register
    MOV CR3, RAX     ; page table base (paging root)
    MOV CR4, RAX     ; CPU feature switches (SMEP, SMAP, etc.)   
    LGDT [RAX]       ; never use - loads GDT
    LIDT [RAX]       ; never use - loads IDT
    LTR AX           ; never use - loads task register
    LLDT AX          ; never use - loads LDT
    MOV DR0, RAX     ; never use - modifies debug register
    CLTS             ; never use - clears task-switched flag
    WRMSR            ; never use - writes model-specific register
    RDMSR            ; never use - reads model-specific register
    INVLPG [RAX]     ; never use - invalidates TLB entry
    CLI              ; never use - disables interrupts
    STI              ; never use - enables interrupts
    UD2              ; never use - guaranteed fail
    CPUID            ; never use - gets CPU info, can cause issues on old CPUs
    RDTSC            ; never use - reads time-stamp counter, can cause issues on old CPUs
    SWAPGS           ; never use - swaps GS base, privileged in ring-3
    IRETQ            ; never use - returns from interrupt, dangerous in user code
    SYSENTER         ; never use - fast system call entry, OS-only behavior
    SYSEXIT          ; never use - fast system call exit, OS-only behavior
    SYSRET           ; never use - fast return from syscall, OS-only behavior
    VMXON [RAX]      ; never use - enable virtualization, ring-0 only
    VMXOFF           ; never use - disable virtualization, ring-0 only
    VMLAUNCH         ; never use - launch VM, ring-0 only
    VMRESUME         ; never use - resume VM, ring-0 only
    VMREAD [RAX], RBX ; never use - read VMCS field, virtualization only
    VMWRITE RBX, [RAX] ; never use - write VMCS field, virtualization only
    RSM              ; never use - resume from SMM, ring-0 only
    INVD             ; never use - invalidate caches without write-back
    WBINVD           ; never use - write back and invalidate caches
    INT 0x10         ; never use - old BIOS video services, obsolete in protected mode
    INT 0x13         ; never use - old BIOS disk services, unsafe in modern OS
    INT 0x14         ; never use - old BIOS serial communications
    INT 0x15         ; never use - old BIOS system services / memory info
    INT 0x16         ; never use - old BIOS keyboard services
    INT 0x17         ; never use - old BIOS printer services
    INT 0x19         ; never use - old BIOS bootstrap interrupt
    INT 0x1A         ; never use - old BIOS time services
    INT 0x2F         ; never use - old DOS multiplex interrupt
    INT 0x31         ; never use - old DPMI services
    INT 0x33         ; never use - old mouse services
    INT 0x21         ; never use - old DOS interrupt for services
    INT 0x80         ; never use - not windows compatible
    IN 0x0000        ; never use - direct port input - kernel only
    OUT 0x0000, AL   ; never use - direct port output - kernel only
    LMSW AX          ; never use - loads machine status word
    MONITOR          ; never use - sets up address monitoring, privileged
    MWAIT            ; never use - waits for address modification, privileged
    XSETBV           ; never use - sets XCR0, privileged
    XSAVE            ; save extended CPU state
    XRSTOR           ; restore extended CPU state
    XGETBV           ; read extended control register
    RDPMC            ; never use - reads performance counter, privileged
    INT3             ; debugger break (ok for debugging, not logic)
    ICEBP            ; undocumented debug trap
    HLT              ; never use - halts the CPU, sort of like an exit but dangerous