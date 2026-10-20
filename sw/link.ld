/* ============================================================================
 * link.ld - Ban do bo nho cho CPU RISC-V (Harvard: IMEM va DMEM tach rieng)
 *
 *   IMEM 0x0000 - 0x0FFF (4 KB) : ma lenh (.text)       -> Instruction_Mem
 *   DMEM 0x1000 - 0x1FFF (4 KB) : tohost, hang so, bien  -> Data_memory
 *        0x1000 tohost[0] = ket qua main(), 0x1004 tohost[1] = co "xong"
 *        stack: dinh 0x2000, moc xuong
 *
 *   LUU Y: CPU doc hang so (.rodata) bang lenh lw -> di vao Data_memory,
 *          nen .rodata phai nam trong DMEM (khong de canh code nhu thong thuong).
 * ==========================================================================*/
OUTPUT_ARCH("riscv")
ENTRY(_start)

MEMORY
{
    IMEM (rx)  : ORIGIN = 0x00000000, LENGTH = 4K
    DMEM (rw)  : ORIGIN = 0x00001000, LENGTH = 4K
}

SECTIONS
{
    .text : {
        *(.text.init)               /* crt0.S phai o dia chi 0x0 */
        *(.text .text.*)
    } > IMEM

    .tohost (NOLOAD) : {
        tohost = .;
        . = . + 16;
    } > DMEM

    .rodata : { *(.rodata .rodata.* .srodata .srodata.*) } > DMEM
    .data   : { *(.data .data.* .sdata .sdata.*) }         > DMEM

    .bss (NOLOAD) : {
        . = ALIGN(4);
        __bss_start = .;
        *(.bss .bss.* .sbss .sbss.* COMMON)
        . = ALIGN(4);
        __bss_end = .;
    } > DMEM

    __stack_top = ORIGIN(DMEM) + LENGTH(DMEM);

    /DISCARD/ : { *(.comment) *(.eh_frame*) *(.note*) }
}
