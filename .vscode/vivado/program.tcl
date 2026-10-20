# Nap bitstream xuong board Arty A7-100T qua cap USB (JTAG)
set root [file normalize [file join [file dirname [info script]] .. ..]]
set bit  [file join $root RISC.runs impl_1 RISCV_ArtyA7.bit]

if {![file exists $bit]} {
    puts "\[LOI\] Chua co bitstream: $bit  -> chay task 'Vivado: Build bitstream' truoc"
    exit 1
}

open_hw
connect_hw_server
if {[catch {open_hw_target} err]} {
    puts "\[LOI\] Khong tim thay board. Kiem tra cap USB, nguon, va da tat Hardware Manager trong Vivado GUI chua."
    exit 1
}

set dev [lindex [get_hw_devices xc7a100t*] 0]
if {$dev eq ""} {
    puts "\[LOI\] Board ket noi khong phai xc7a100t: [get_hw_devices]"
    exit 1
}
current_hw_device $dev
refresh_hw_device -update_hw_probes false $dev
set_property PROGRAM.FILE $bit $dev
program_hw_devices $dev

puts "\n>>> DA NAP XONG: $bit"
close_hw_target
disconnect_hw_server
exit 0
