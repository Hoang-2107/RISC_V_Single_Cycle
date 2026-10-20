# Tập lệnh RV32I – Trường mã lệnh và tín hiệu điều khiển (dạng nhị phân)

Tài liệu tra cứu cho CPU RISC-V đơn chu kỳ trong project `D:\RISC` (Arty A7-100T).
Mọi mã nhị phân được sinh tự động từ bảng định nghĩa khớp với RTL hiện tại:
`Control_unit.v`, `ALU_Control.v`, `ALU.v`, `Imm_Gen.v`, `Branch_Comp.v`, `Data_memory.v`.

## 1. Sáu dạng lệnh và vị trí các trường bit

```
 bit:   31        25 24    20 19    15 14  12 11         7 6       0
       +-----------+--------+--------+------+------------+---------+
 R     |  funct7   |  rs2   |  rs1   |funct3|     rd     | opcode  |
 I     |      imm[11:0]     |  rs1   |funct3|     rd     | opcode  |
 S     | imm[11:5] |  rs2   |  rs1   |funct3|  imm[4:0]  | opcode  |
 B     |imm[12|10:5]|  rs2  |  rs1   |funct3|imm[4:1|11] | opcode  |
 U     |              imm[31:12]            |     rd     | opcode  |
 J     |      imm[20|10:1|11|19:12]         |     rd     | opcode  |
       +-----------+--------+--------+------+------------+---------+
        7 bit       5 bit    5 bit    3 bit    5 bit       7 bit
```

| Trường | Bit | Độ rộng | Ý nghĩa |
|---|---|---|---|
| opcode | [6:0] | 7 | Nhóm lệnh → `Control_unit` |
| rd | [11:7] | 5 | Thanh ghi đích (x0–x31), `Register_file.write_reg` |
| funct3 | [14:12] | 3 | Phân biệt lệnh trong nhóm → `ALU_Control`, `Branch_Comp`, `Data_memory` |
| rs1 | [19:15] | 5 | Thanh ghi nguồn 1, `Register_file.read_reg1` |
| rs2 | [24:20] | 5 | Thanh ghi nguồn 2, `Register_file.read_reg2` |
| funct7 | [31:25] | 7 | Chỉ bit `funct7[5]` = `inst[30]` được dùng: add/sub, srl/sra, srli/srai |

### Cách ghép immediate (`Imm_Gen.v`, mở rộng dấu từ `inst[31]`)

| Dạng | Giá trị immediate 32 bit | Lệnh |
|---|---|---|
| I | `{20{inst[31]}}, inst[31:20]` | addi…, lb…lhu, jalr |
| S | `{20{inst[31]}}, inst[31:25], inst[11:7]` | sb, sh, sw |
| B | `{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0` | beq…bgeu |
| U | `inst[31:12], 12'b0` | lui, auipc |
| J | `{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0` | jal |

B và J đã gắn sẵn bit 0 = 0 (offset tính theo byte) nên **không** đi qua `Shift_barek`.

## 2. Bảng tập lệnh RV32I và mã nhị phân

Ký hiệu: `rd`, `rs1`, `rs2` = 5 bit số thanh ghi; `imm` = các bit immediate.

| # | Lệnh | Dạng | opcode | funct3 | funct7 | Mẫu mã lệnh 32 bit (từ bit 31 → 0) | Phép toán |
|---|---|---|---|---|---|---|---|
| 1 | **add** | R | `0110011` | `000` | `0000000` | `0000000 rs2 rs1 000 rd 0110011` | rd = rs1 + rs2 |
| 2 | **sub** | R | `0110011` | `000` | `0100000` | `0100000 rs2 rs1 000 rd 0110011` | rd = rs1 - rs2 |
| 3 | **sll** | R | `0110011` | `001` | `0000000` | `0000000 rs2 rs1 001 rd 0110011` | rd = rs1 << rs2[4:0] |
| 4 | **slt** | R | `0110011` | `010` | `0000000` | `0000000 rs2 rs1 010 rd 0110011` | rd = (rs1 < rs2) có dấu |
| 5 | **sltu** | R | `0110011` | `011` | `0000000` | `0000000 rs2 rs1 011 rd 0110011` | rd = (rs1 < rs2) không dấu |
| 6 | **xor** | R | `0110011` | `100` | `0000000` | `0000000 rs2 rs1 100 rd 0110011` | rd = rs1 ^ rs2 |
| 7 | **srl** | R | `0110011` | `101` | `0000000` | `0000000 rs2 rs1 101 rd 0110011` | rd = rs1 >> rs2[4:0] (logic) |
| 8 | **sra** | R | `0110011` | `101` | `0100000` | `0100000 rs2 rs1 101 rd 0110011` | rd = rs1 >>> rs2[4:0] (số học) |
| 9 | **or** | R | `0110011` | `110` | `0000000` | `0000000 rs2 rs1 110 rd 0110011` | rd = rs1 \| rs2 |
| 10 | **and** | R | `0110011` | `111` | `0000000` | `0000000 rs2 rs1 111 rd 0110011` | rd = rs1 & rs2 |
| 11 | **addi** | I | `0010011` | `000` | `-` | `imm[11:0] rs1 000 rd 0010011` | rd = rs1 + imm |
| 12 | **slti** | I | `0010011` | `010` | `-` | `imm[11:0] rs1 010 rd 0010011` | rd = (rs1 < imm) có dấu |
| 13 | **sltiu** | I | `0010011` | `011` | `-` | `imm[11:0] rs1 011 rd 0010011` | rd = (rs1 < imm) không dấu |
| 14 | **xori** | I | `0010011` | `100` | `-` | `imm[11:0] rs1 100 rd 0010011` | rd = rs1 ^ imm |
| 15 | **ori** | I | `0010011` | `110` | `-` | `imm[11:0] rs1 110 rd 0010011` | rd = rs1 \| imm |
| 16 | **andi** | I | `0010011` | `111` | `-` | `imm[11:0] rs1 111 rd 0010011` | rd = rs1 & imm |
| 17 | **slli** | I | `0010011` | `001` | `0000000` | `0000000 shamt rs1 001 rd 0010011` | rd = rs1 << shamt |
| 18 | **srli** | I | `0010011` | `101` | `0000000` | `0000000 shamt rs1 101 rd 0010011` | rd = rs1 >> shamt (logic) |
| 19 | **srai** | I | `0010011` | `101` | `0100000` | `0100000 shamt rs1 101 rd 0010011` | rd = rs1 >>> shamt (số học) |
| 20 | **lb** | I | `0000011` | `000` | `-` | `imm[11:0] rs1 000 rd 0000011` | rd = sext(M[rs1+imm][7:0]) |
| 21 | **lh** | I | `0000011` | `001` | `-` | `imm[11:0] rs1 001 rd 0000011` | rd = sext(M[rs1+imm][15:0]) |
| 22 | **lw** | I | `0000011` | `010` | `-` | `imm[11:0] rs1 010 rd 0000011` | rd = M[rs1+imm][31:0] |
| 23 | **lbu** | I | `0000011` | `100` | `-` | `imm[11:0] rs1 100 rd 0000011` | rd = zext(M[rs1+imm][7:0]) |
| 24 | **lhu** | I | `0000011` | `101` | `-` | `imm[11:0] rs1 101 rd 0000011` | rd = zext(M[rs1+imm][15:0]) |
| 25 | **sb** | S | `0100011` | `000` | `-` | `imm[11:5] rs2 rs1 000 imm[4:0] 0100011` | M[rs1+imm][7:0]  = rs2[7:0] |
| 26 | **sh** | S | `0100011` | `001` | `-` | `imm[11:5] rs2 rs1 001 imm[4:0] 0100011` | M[rs1+imm][15:0] = rs2[15:0] |
| 27 | **sw** | S | `0100011` | `010` | `-` | `imm[11:5] rs2 rs1 010 imm[4:0] 0100011` | M[rs1+imm][31:0] = rs2 |
| 28 | **beq** | B | `1100011` | `000` | `-` | `imm[12\|10:5] rs2 rs1 000 imm[4:1\|11] 1100011` | if (rs1 == rs2) PC += imm |
| 29 | **bne** | B | `1100011` | `001` | `-` | `imm[12\|10:5] rs2 rs1 001 imm[4:1\|11] 1100011` | if (rs1 != rs2) PC += imm |
| 30 | **blt** | B | `1100011` | `100` | `-` | `imm[12\|10:5] rs2 rs1 100 imm[4:1\|11] 1100011` | if (rs1 <  rs2) PC += imm (có dấu) |
| 31 | **bge** | B | `1100011` | `101` | `-` | `imm[12\|10:5] rs2 rs1 101 imm[4:1\|11] 1100011` | if (rs1 >= rs2) PC += imm (có dấu) |
| 32 | **bltu** | B | `1100011` | `110` | `-` | `imm[12\|10:5] rs2 rs1 110 imm[4:1\|11] 1100011` | if (rs1 <  rs2) PC += imm (không dấu) |
| 33 | **bgeu** | B | `1100011` | `111` | `-` | `imm[12\|10:5] rs2 rs1 111 imm[4:1\|11] 1100011` | if (rs1 >= rs2) PC += imm (không dấu) |
| 34 | **jal** | J | `1101111` | `-` | `-` | `imm[20\|10:1\|11\|19:12] rd 1101111` | rd = PC+4; PC += imm |
| 35 | **jalr** | I | `1100111` | `000` | `-` | `imm[11:0] rs1 000 rd 1100111` | rd = PC+4; PC = (rs1+imm) & ~1 |
| 36 | **lui** | U | `0110111` | `-` | `-` | `imm[31:12] rd 0110111` | rd = imm << 12  (ALU: 0 + imm) |
| 37 | **auipc** | U | `0010111` | `-` | `-` | `imm[31:12] rd 0010111` | rd = PC + (imm << 12) |

**Chưa hỗ trợ** (lệnh hệ thống, chương trình C đơn giản không dùng):

| Lệnh | Dạng | opcode | funct3 | Ghi chú |
|---|---|---|---|---|
| fence | I | `0001111` | `000` | đồng bộ bộ nhớ |
| ecall | I | `1110011` | `000` | gọi hệ điều hành (imm = 0) |
| ebreak | I | `1110011` | `000` | điểm dừng debug (imm = 1) |

## 3. Tín hiệu điều khiển theo opcode (`Control_unit.v`)

| Nhóm | opcode | Branch | MemRead | MemtoReg | MemWrite | ALUSrc | RegWrite | ALUOp | Jal | Jalr | ALU_a_sel | Vector |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| R | `0110011` | 0 | 0 | 0 | 0 | 0 | 1 | `10` | 0 | 0 | `00` | `000001_10_00_00` |
| I-ALU | `0010011` | 0 | 0 | 0 | 0 | 1 | 1 | `11` | 0 | 0 | `00` | `000011_11_00_00` |
| LOAD | `0000011` | 0 | 1 | 1 | 0 | 1 | 1 | `00` | 0 | 0 | `00` | `011011_00_00_00` |
| STORE | `0100011` | 0 | 0 | 0 | 1 | 1 | 0 | `00` | 0 | 0 | `00` | `000110_00_00_00` |
| BRANCH | `1100011` | 1 | 0 | 0 | 0 | 0 | 0 | `01` | 0 | 0 | `00` | `100000_01_00_00` |
| JAL | `1101111` | 0 | 0 | 0 | 0 | 0 | 1 | `00` | 1 | 0 | `00` | `000001_00_10_00` |
| JALR | `1100111` | 0 | 0 | 0 | 0 | 1 | 1 | `00` | 0 | 1 | `00` | `000011_00_01_00` |
| LUI | `0110111` | 0 | 0 | 0 | 0 | 1 | 1 | `00` | 0 | 0 | `10` | `000011_00_00_10` |
| AUIPC | `0010111` | 0 | 0 | 0 | 0 | 1 | 1 | `00` | 0 | 0 | `01` | `000011_00_00_01` |
| khác (default) | – | 0 | 0 | 0 | 0 | 0 | 0 | `00` | 0 | 0 | `00` | `000000_00_00_00` |

**Vector** = `Branch MemRead MemtoReg MemWrite ALUSrc RegWrite _ ALUOp[1:0] _ Jal Jalr _ ALU_a_sel[1:0]`

| Tín hiệu | = 0 | = 1 |
|---|---|---|
| ALUSrc | ALU.B = rs2 | ALU.B = immediate |
| MemtoReg | ghi ngược = kết quả ALU | ghi ngược = dữ liệu đọc từ DMEM |
| Jal / Jalr | – | ghi ngược = PC+4; PC = PC+imm (Jal) / (rs1+imm)&~1 (Jalr) |
| ALU_a_sel | `00` ALU.A = rs1 · `01` ALU.A = PC (auipc) · `10` ALU.A = 0 (lui) | |
| Branch | – | `Branch_Comp` so sánh rs1/rs2 theo funct3 → nhảy nếu đúng |

## 4. Mã điều khiển ALU (`ALU_Control.v` → `ALU.v`)

| ALU_ctrl | Phép toán | Biểu thức |
|---|---|---|
| `0000` | ADD | `A + B` |
| `0001` | SUB | `A - B` |
| `0010` | AND | `A & B` |
| `0011` | OR | `A \| B` |
| `0100` | XOR | `A ^ B` |
| `0101` | SLL | `A << B[4:0]` |
| `0110` | SRL | `A >> B[4:0]` |
| `0111` | SRA | `$signed(A) >>> B[4:0]` |
| `1000` | SLT | `$signed(A) < $signed(B) ? 1 : 0` |
| `1001` | SLTU | `A < B ? 1 : 0` |
| khác | – | 0 |

| ALUOp | Dùng cho | ALU_ctrl |
|---|---|---|
| `00` | load, store, jalr, lui, auipc | `0000` (ADD) |
| `01` | branch | `0001` (SUB) – kết quả không dùng, `Branch_Comp` quyết định nhảy |
| `10` | R-type | theo funct3 + funct7[5] |
| `11` | I-type ALU | theo funct3 (+ funct7[5] chỉ cho srli/srai) |

| funct3 | funct7[5] | ALUOp = 10 (R) | ALUOp = 11 (I) | ALU_ctrl |
|---|---|---|---|---|
| `000` | 0 | add | addi | `0000` |
| `000` | 1 | sub | addi (bỏ qua funct7) | `0001` / `0000` |
| `001` | – | sll | slli | `0101` |
| `010` | – | slt | slti | `1000` |
| `011` | – | sltu | sltiu | `1001` |
| `100` | – | xor | xori | `0100` |
| `101` | 0 | srl | srli | `0110` |
| `101` | 1 | sra | srai | `0111` |
| `110` | – | or | ori | `0011` |
| `111` | – | and | andi | `0010` |

## 5. funct3 trong lệnh nhánh và truy cập bộ nhớ

| funct3 | Branch (`Branch_Comp`) | Load (`Data_memory`) | Store (`Data_memory`) |
|---|---|---|---|
| `000` | beq  rs1 == rs2 | lb  (byte, có dấu) | sb (byte) |
| `001` | bne  rs1 != rs2 | lh  (half, có dấu) | sh (half) |
| `010` | – | lw  (word) | sw (word) |
| `011` | – | – | – |
| `100` | blt  < có dấu | lbu (byte, không dấu) | – |
| `101` | bge  >= có dấu | lhu (half, không dấu) | – |
| `110` | bltu < không dấu | – | – |
| `111` | bgeu >= không dấu | – | – |

## 6. Giải mã chương trình `rv32i_test.hex`

Các trường nhị phân xếp theo dạng R: `funct7 rs2 rs1 funct3 rd opcode` (với I/S/B/U/J các bit này là immediate).

| PC | Mã hex | funct7 · rs2 · rs1 · f3 · rd · opcode | Nhóm | rd | rs1 | rs2 | imm | Lệnh |
|---|---|---|---|---|---|---|---|---|
| `0x00` | `ffb00093` | `1111111 11011 00000 000 00001 0010011` | I-ALU | x1 | x0 | – | -5 | `addi x1, x0, -5` |
| `0x04` | `00700113` | `0000000 00111 00000 000 00010 0010011` | I-ALU | x2 | x0 | – | 7 | `addi x2, x0, 7` |
| `0x08` | `123451b7` | `0001001 00011 01000 101 00011 0110111` | LUI | x3 | – | – | 0x12345000 | `lui x3, 0x12345` |
| `0x0C` | `00001217` | `0000000 00000 00000 001 00100 0010111` | AUIPC | x4 | – | – | 0x00001000 | `auipc x4, 0x1` |
| `0x10` | `00209463` | `0000000 00010 00001 001 01000 1100011` | BRANCH | – | x1 | x2 | 8 | `bne x1, x2, +8` |
| `0x14` | `001f8f93` | `0000000 00001 11111 000 11111 0010011` | I-ALU | x31 | x31 | – | 1 | `addi x31, x31, 1` |
| `0x18` | `0020c463` | `0000000 00010 00001 100 01000 1100011` | BRANCH | – | x1 | x2 | 8 | `blt x1, x2, +8` |
| `0x1C` | `001f8f93` | `0000000 00001 11111 000 11111 0010011` | I-ALU | x31 | x31 | – | 1 | `addi x31, x31, 1` |
| `0x20` | `00115463` | `0000000 00001 00010 101 01000 1100011` | BRANCH | – | x2 | x1 | 8 | `bge x2, x1, +8` |
| `0x24` | `001f8f93` | `0000000 00001 11111 000 11111 0010011` | I-ALU | x31 | x31 | – | 1 | `addi x31, x31, 1` |
| `0x28` | `00116463` | `0000000 00001 00010 110 01000 1100011` | BRANCH | – | x2 | x1 | 8 | `bltu x2, x1, +8` |
| `0x2C` | `001f8f93` | `0000000 00001 11111 000 11111 0010011` | I-ALU | x31 | x31 | – | 1 | `addi x31, x31, 1` |
| `0x30` | `0020f463` | `0000000 00010 00001 111 01000 1100011` | BRANCH | – | x1 | x2 | 8 | `bgeu x1, x2, +8` |
| `0x34` | `001f8f93` | `0000000 00001 11111 000 11111 0010011` | I-ALU | x31 | x31 | – | 1 | `addi x31, x31, 1` |
| `0x38` | `00208a63` | `0000000 00010 00001 000 10100 1100011` | BRANCH | – | x1 | x2 | 20 | `beq x1, x2, +20` |
| `0x3C` | `00100293` | `0000000 00001 00000 000 00101 0010011` | I-ALU | x5 | x0 | – | 1 | `addi x5, x0, 1` |
| `0x40` | `00109663` | `0000000 00001 00001 001 01100 1100011` | BRANCH | – | x1 | x1 | 12 | `bne x1, x1, +12` |
| `0x44` | `00100313` | `0000000 00001 00000 000 00110 0010011` | I-ALU | x6 | x0 | – | 1 | `addi x6, x0, 1` |
| `0x48` | `008003ef` | `0000000 01000 00000 000 00111 1101111` | JAL | x7 | – | – | 8 | `jal x7, +8` |
| `0x4C` | `001f8f93` | `0000000 00001 11111 000 11111 0010011` | I-ALU | x31 | x31 | – | 1 | `addi x31, x31, 1` |
| `0x50` | `06000413` | `0000011 00000 00000 000 01000 0010011` | I-ALU | x8 | x0 | – | 96 | `addi x8, x0, 96` |
| `0x54` | `004404e7` | `0000000 00100 01000 000 01001 1100111` | JALR | x9 | x8 | – | 4 | `jalr x9, 4(x8)` |
| `0x58` | `001f8f93` | `0000000 00001 11111 000 11111 0010011` | I-ALU | x31 | x31 | – | 1 | `addi x31, x31, 1` |
| `0x5C` | `001f8f93` | `0000000 00001 11111 000 11111 0010011` | I-ALU | x31 | x31 | – | 1 | `addi x31, x31, 1` |
| `0x60` | `001f8f93` | `0000000 00001 11111 000 11111 0010011` | I-ALU | x31 | x31 | – | 1 | `addi x31, x31, 1` |
| `0x64` | `04000513` | `0000010 00000 00000 000 01010 0010011` | I-ALU | x10 | x0 | – | 64 | `addi x10, x0, 64` |
| `0x68` | `808185b7` | `1000000 01000 00011 000 01011 0110111` | LUI | x11 | – | – | 0x80818000 | `lui x11, 0x80818` |
| `0x6C` | `28358593` | `0010100 00011 01011 000 01011 0010011` | I-ALU | x11 | x11 | – | 643 | `addi x11, x11, 643` |
| `0x70` | `00b52023` | `0000000 01011 01010 010 00000 0100011` | STORE | – | x10 | x11 | 0 | `sw x11, 0(x10)` |
| `0x74` | `00050603` | `0000000 00000 01010 000 01100 0000011` | LOAD | x12 | x10 | – | 0 | `lb x12, 0(x10)` |
| `0x78` | `00154683` | `0000000 00001 01010 100 01101 0000011` | LOAD | x13 | x10 | – | 1 | `lbu x13, 1(x10)` |
| `0x7C` | `00251703` | `0000000 00010 01010 001 01110 0000011` | LOAD | x14 | x10 | – | 2 | `lh x14, 2(x10)` |
| `0x80` | `00055783` | `0000000 00000 01010 101 01111 0000011` | LOAD | x15 | x10 | – | 0 | `lhu x15, 0(x10)` |
| `0x84` | `002500a3` | `0000000 00010 01010 000 00001 0100011` | STORE | – | x10 | x2 | 1 | `sb x2, 1(x10)` |
| `0x88` | `00251123` | `0000000 00010 01010 001 00010 0100011` | STORE | – | x10 | x2 | 2 | `sh x2, 2(x10)` |
| `0x8C` | `00052803` | `0000000 00000 01010 010 10000 0000011` | LOAD | x16 | x10 | – | 0 | `lw x16, 0(x10)` |
| `0x90` | `0000a893` | `0000000 00000 00001 010 10001 0010011` | I-ALU | x17 | x1 | – | 0 | `slti x17, x1, 0` |
| `0x94` | `0ff5f913` | `0000111 11111 01011 111 10010 0010011` | I-ALU | x18 | x11 | – | 255 | `andi x18, x11, 255` |
| `0x98` | `4010d993` | `0100000 00001 00001 101 10011 0010011` | I-ALU | x19 | x1 | – | 1 | `srai x19, x1, 1` |
| `0x9C` | `fff14a13` | `1111111 11111 00010 100 10100 0010011` | I-ALU | x20 | x2 | – | -1 | `xori x20, x2, -1` |
| `0xA0` | `0000006f` | `0000000 00000 00000 000 00000 1101111` | JAL | x0 | – | – | 0 | `jal x0, +0` |

## 7. Bản đồ bộ nhớ

| Vùng | Địa chỉ | Dung lượng | Module |
|---|---|---|---|
| IMEM (mã lệnh) | `0x0000_0000` – `0x0000_0FFF` | 4 KB | `Instruction_Mem` |
| DMEM (dữ liệu) | `0x0000_1000` – `0x0000_1FFF` | 4 KB | `Data_memory` |
| tohost (C) | `0x1000` kết quả, `0x1004` cờ xong | 16 byte | `sw/crt0.S` |
| Đỉnh stack (C) | `0x2000`, mọc xuống | – | `sw/link.ld` |
