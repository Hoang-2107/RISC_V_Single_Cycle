# ============================================================================
# crt0.S - Code khoi dong cho CPU RISC-V don chu ky (RV32I)
#   Chay TRUOC main():
#     1. Dat con tro stack sp = dinh DMEM (0x2000, stack moc xuong)
#     2. Xoa vung .bss ve 0 (bien toan cuc chua khoi tao)
#     3. Goi main()
#     4. Ghi gia tri tra ve cua main vao tohost[0] (0x1000)
#        va co "xong" = 1 vao tohost[1] (0x1004) -> testbench doc 2 o nay
#     5. Dung tai cho (vong lap vo han)
# ============================================================================
    .section .text.init, "ax"
    .globl _start
_start:
    la   sp, __stack_top        # sp = 0x2000

    la   t0, __bss_start        # xoa .bss
    la   t1, __bss_end
1:  bgeu t0, t1, 2f
    sw   zero, 0(t0)
    addi t0, t0, 4
    j    1b

2:  call main                   # a0 = gia tri tra ve cua main()

    la   t0, tohost
    sw   a0, 0(t0)              # tohost[0] = ket qua
    li   t1, 1
    sw   t1, 4(t0)              # tohost[1] = 1 -> bao "da xong"
    add  a0, a0, zero           # ghi lai a0 -> LED tren board (last_wb) hien ket qua

3:  j    3b                     # dung chuong trinh
