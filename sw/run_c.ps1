# Bien dich 1 file C -> chay tren CPU RISC-V trong mo phong (tb_C_program)
# Cach dung: run_c.ps1 <file.c>
#   - Dong "// EXPECT: <so>" trong file C (neu co) -> testbench so sanh ket qua
#   - Ket qua bien dich: sw/build/prog.elf, prog.dis (ma may), imem.hex, dmem.hex
param([Parameter(Mandatory = $true)][string]$CFile)

$ErrorActionPreference = 'Stop'
$gccBin   = 'C:\riscv\xpack-riscv-none-elf-gcc-15.2.0-1\bin'
$iverilog = 'C:\iverilog\bin\iverilog.exe'
$vvp      = 'C:\iverilog\bin\vvp.exe'

$sw    = $PSScriptRoot
$root  = Split-Path -Parent $sw
$build = Join-Path $sw 'build'
$CFile = (Resolve-Path $CFile).Path
$elf   = Join-Path $build 'prog.elf'
New-Item -ItemType Directory -Force $build | Out-Null

# ---- 1. Bien dich (chi dung lenh RV32I, khong thu vien C chuan) ----
Write-Host "=== Bien dich $(Split-Path -Leaf $CFile) ===" -ForegroundColor Cyan
& "$gccBin\riscv-none-elf-gcc.exe" -march=rv32i -mabi=ilp32 -O1 -ffreestanding -nostdlib `
    -mno-relax -T (Join-Path $sw 'link.ld') (Join-Path $sw 'crt0.S') $CFile -lgcc -o $elf
if ($LASTEXITCODE -ne 0) { Write-Host "[LOI] Bien dich C that bai" -ForegroundColor Red; exit 1 }

& "$gccBin\riscv-none-elf-objdump.exe" -d $elf | Out-File -Encoding ascii (Join-Path $build 'prog.dis')
& "$gccBin\riscv-none-elf-size.exe" $elf

# ---- 2. ELF -> imem.hex / dmem.hex ----
& python -I (Join-Path $sw 'elf2hex.py') "$gccBin\riscv-none-elf-objcopy.exe" $elf $build
if ($LASTEXITCODE -ne 0) { Write-Host "[LOI] elf2hex that bai" -ForegroundColor Red; exit 1 }

# ---- 3. Mo phong ----
$src = Get-ChildItem (Join-Path $root 'RISC.srcs\sources_1\new\*.v') -Exclude 'RISCV_ArtyA7.v' |
       ForEach-Object { $_.FullName }
$tb  = Join-Path $root 'RISC.srcs\sim_1\new\tb_C_program.v'
$vvpOut = Join-Path $build 'tb_C_program.vvp'

Write-Host "=== Mo phong tb_C_program ===" -ForegroundColor Cyan
& $iverilog -g2012 -Wno-timescale -o $vvpOut -s tb_C_program $tb @src
if ($LASTEXITCODE -ne 0) { Write-Host "[LOI] Bien dich Verilog that bai" -ForegroundColor Red; exit 1 }

$plus = @("+IMEM=$($build -replace '\\','/')/imem.hex", "+DMEM=$($build -replace '\\','/')/dmem.hex")
$m = Select-String -Path $CFile -Pattern '//\s*EXPECT:\s*(-?\d+)' | Select-Object -First 1
if ($m) { $plus += "+EXPECT=$($m.Matches[0].Groups[1].Value)" }

Push-Location $build
try { & $vvp -n $vvpOut @plus } finally { Pop-Location }
exit $LASTEXITCODE
