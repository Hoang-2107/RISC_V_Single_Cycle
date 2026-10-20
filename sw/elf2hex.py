"""Chuyen file ELF thanh 2 file hex cho $readmemh (moi dong 1 word 32-bit).

  imem.hex : dia chi 0x0000 - 0x0FFF  (dong 0 = dia chi 0x0000)
  dmem.hex : dia chi 0x1000 - 0x1FFF  (dong 0 = dia chi 0x1000)

Cach dung: python elf2hex.py <objcopy.exe> <prog.elf> <thu_muc_ra>
"""
import subprocess
import sys
from pathlib import Path

IMEM_BASE, DMEM_BASE, MEM_SIZE = 0x0000, 0x1000, 0x1000


def read_bytes(objcopy, elf, out):
    """Doc tung byte theo dia chi tu dinh dang 'verilog' cua objcopy."""
    tmp = out / "prog.vh"           # objcopy tren Windows khong ghi ra stdout duoc
    subprocess.run([objcopy, "-O", "verilog", elf, str(tmp)], check=True)
    text = tmp.read_text()
    mem, addr = {}, 0
    for tok in text.split():
        if tok.startswith("@"):
            addr = int(tok[1:], 16)
        else:
            mem[addr] = int(tok, 16)
            addr += 1
    return mem


def write_hex(mem, base, path, name):
    used = [a for a in mem if base <= a < base + MEM_SIZE]
    n_words = (max(used) - base) // 4 + 1 if used else 1
    with open(path, "w") as f:
        f.write(f"// {name}: dong 0 = dia chi 0x{base:04X}, {n_words} word\n")
        for i in range(n_words):
            a = base + 4 * i
            word = sum(mem.get(a + b, 0) << (8 * b) for b in range(4))  # little-endian
            f.write(f"{word:08x}\n")
    return n_words


def main():
    objcopy, elf, out = sys.argv[1], sys.argv[2], Path(sys.argv[3])
    out.mkdir(parents=True, exist_ok=True)
    mem = read_bytes(objcopy, elf, out)
    bad = [a for a in mem if a >= DMEM_BASE + MEM_SIZE]
    if bad:
        sys.exit(f"[LOI] Co du lieu ngoai DMEM tai 0x{min(bad):X}")
    ni = write_hex(mem, IMEM_BASE, out / "imem.hex", "IMEM")
    nd = write_hex(mem, DMEM_BASE, out / "dmem.hex", "DMEM")
    print(f"imem.hex: {ni} lenh ({ni * 4} byte / 4096)")
    print(f"dmem.hex: {nd} word du lieu ban dau")


if __name__ == "__main__":
    main()
