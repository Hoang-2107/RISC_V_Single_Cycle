# Bien dich + chay 1 testbench bang Icarus Verilog
# Cach dung: run_tb.ps1 <duong dan file testbench .v>
# Ten module testbench phai trung ten file (vd tb_RISCV_TOP.v -> module tb_RISCV_TOP)
param([Parameter(Mandatory = $true)][string]$TbFile)

$ErrorActionPreference = 'Stop'
$iverilog = 'C:\iverilog\bin\iverilog.exe'
$vvp      = 'C:\iverilog\bin\vvp.exe'

$root  = Split-Path -Parent $PSScriptRoot

# File C -> bien dich bang GCC va chay tren CPU (tb_C_program)
if ([IO.Path]::GetExtension($TbFile) -eq '.c') {
    & (Join-Path $root 'sw\run_c.ps1') $TbFile
    exit $LASTEXITCODE
}

$build = Join-Path $root 'sim_build'
$top   = [IO.Path]::GetFileNameWithoutExtension($TbFile)

if ((Split-Path -Parent (Resolve-Path $TbFile)) -notlike '*sim_1*') {
    Write-Host "[LOI] '$top' khong phai testbench (khong nam trong sim_1). Hay mo file tb_*.v roi bam lai." -ForegroundColor Red
    exit 1
}

# Tat ca file RTL, tru RISCV_ArtyA7.v (dung primitive BUFGCE cua Xilinx, iverilog khong co)
$src = Get-ChildItem (Join-Path $root 'RISC.srcs\sources_1\new\*.v') -Exclude 'RISCV_ArtyA7.v' |
       ForEach-Object { $_.FullName }

New-Item -ItemType Directory -Force $build | Out-Null
$out = Join-Path $build "$top.vvp"

Write-Host "=== Bien dich $top ===" -ForegroundColor Cyan
& $iverilog -g2012 -Wall -Wno-timescale -o $out -s $top (Resolve-Path $TbFile).Path @src
if ($LASTEXITCODE -ne 0) { Write-Host "[LOI] Bien dich that bai" -ForegroundColor Red; exit 1 }

Write-Host "=== Chay mo phong ===" -ForegroundColor Cyan
Push-Location $build      # file .vcd duoc ghi vao sim_build
try { & $vvp -n $out } finally { Pop-Location }
exit $LASTEXITCODE
