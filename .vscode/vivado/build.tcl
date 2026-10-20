# Synthesis -> Implementation -> Bitstream cho project RISC (chay bang Vivado batch mode)
set root [file normalize [file join [file dirname [info script]] .. ..]]
open_project [file join $root RISC.xpr]

# Tu dong bo file da xoa tren o dia khoi project (tranh loi "file not found")
foreach f [get_files -quiet -of_objects [get_filesets {sources_1 sim_1}]] {
    if {![file exists $f]} {
        remove_files -quiet $f
        puts "=== Bo khoi project (da xoa tren o dia): [file tail $f]"
    }
}

# Tu dong them file .v moi (tao ngoai Vivado) vao project
foreach {fs dir} [list sources_1 RISC.srcs/sources_1/new sim_1 RISC.srcs/sim_1/new] {
    foreach f [glob -nocomplain [file join $root $dir *.v]] {
        if {[llength [get_files -quiet -of_objects [get_filesets $fs] [file normalize $f]]] == 0} {
            add_files -norecurse -fileset $fs [file normalize $f]
            puts "=== Them vao $fs: [file tail $f]"
        }
    }
}
update_compile_order -fileset sources_1

puts "=== Top: [get_property top [current_fileset]]  Part: [get_property part [current_project]] ==="

reset_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    puts "\[LOI\] Synthesis that bai - xem RISC.runs/synth_1/runme.log"
    exit 1
}
if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
    puts "\[LOI\] Implementation/Bitstream that bai - xem RISC.runs/impl_1/runme.log"
    exit 1
}

open_run impl_1
puts "\n=================== TAI NGUYEN ==================="
foreach l [split [report_utilization -return_string] "\n"] {
    if {[regexp {^\| (Slice LUTs|Slice Registers|Bonded IOB|BUFGCTRL) } $l]} { puts $l }
}
puts "\n===================== TIMING ====================="
puts "WNS (setup) = [get_property SLACK [get_timing_paths -delay_type max]] ns"
puts "WHS (hold)  = [get_property SLACK [get_timing_paths -delay_type min]] ns"

set bit [file join $root RISC.runs impl_1 [get_property top [current_fileset]].bit]
puts "\n>>> XONG. Bitstream: $bit"
exit 0
