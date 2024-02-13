onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /nono_graphics_cursor_tb/DUT/clk
add wave -noupdate /nono_graphics_cursor_tb/DUT/reset_l
add wave -noupdate -divider IN
add wave -noupdate /nono_graphics_cursor_tb/DUT/UPDATE_CURSOR
add wave -noupdate /nono_graphics_cursor_tb/DUT/TOGGLE_CURSOR
add wave -noupdate /nono_graphics_cursor_tb/DUT/DONE_FIG
add wave -noupdate /nono_graphics_cursor_tb/DUT/sol_out
add wave -noupdate /nono_graphics_cursor_tb/DUT/cursorx
add wave -noupdate /nono_graphics_cursor_tb/DUT/cursory
add wave -noupdate -divider OUT
add wave -noupdate -radix unsigned /nono_graphics_cursor_tb/DUT/XCOOR_int
add wave -noupdate -radix unsigned /nono_graphics_cursor_tb/DUT/YCOOR_int
add wave -noupdate /nono_graphics_cursor_tb/DUT/DRAW_CUAD_int
add wave -noupdate /nono_graphics_cursor_tb/DUT/DRAW_TRIA_int
add wave -noupdate /nono_graphics_cursor_tb/DUT/DONE_UPDATE
add wave -noupdate /nono_graphics_cursor_tb/DUT/DONE_TOGGLE
add wave -noupdate -radix unsigned -childformat {{/nono_graphics_cursor_tb/DUT/addr_int(6) -radix unsigned} {/nono_graphics_cursor_tb/DUT/addr_int(5) -radix unsigned} {/nono_graphics_cursor_tb/DUT/addr_int(4) -radix unsigned} {/nono_graphics_cursor_tb/DUT/addr_int(3) -radix unsigned} {/nono_graphics_cursor_tb/DUT/addr_int(2) -radix unsigned} {/nono_graphics_cursor_tb/DUT/addr_int(1) -radix unsigned} {/nono_graphics_cursor_tb/DUT/addr_int(0) -radix unsigned}} -subitemconfig {/nono_graphics_cursor_tb/DUT/addr_int(6) {-height 15 -radix unsigned} /nono_graphics_cursor_tb/DUT/addr_int(5) {-height 15 -radix unsigned} /nono_graphics_cursor_tb/DUT/addr_int(4) {-height 15 -radix unsigned} /nono_graphics_cursor_tb/DUT/addr_int(3) {-height 15 -radix unsigned} /nono_graphics_cursor_tb/DUT/addr_int(2) {-height 15 -radix unsigned} /nono_graphics_cursor_tb/DUT/addr_int(1) {-height 15 -radix unsigned} /nono_graphics_cursor_tb/DUT/addr_int(0) {-height 15 -radix unsigned}} /nono_graphics_cursor_tb/DUT/addr_int
add wave -noupdate /nono_graphics_cursor_tb/DUT/rd_sol
add wave -noupdate -divider Internal
add wave -noupdate /nono_graphics_cursor_tb/DUT/epres
add wave -noupdate /nono_graphics_cursor_tb/DUT/esig
add wave -noupdate -radix unsigned /nono_graphics_cursor_tb/DUT/v
add wave -noupdate /nono_graphics_cursor_tb/DUT/action
add wave -noupdate /nono_graphics_cursor_tb/DUT/sel
add wave -noupdate /nono_graphics_cursor_tb/DUT/incr_if_same
add wave -noupdate -radix unsigned /nono_graphics_cursor_tb/DUT/mux_dir
add wave -noupdate /nono_graphics_cursor_tb/DUT/dir
add wave -noupdate -divider {Coord calc}
add wave -noupdate -radix unsigned /nono_graphics_cursor_tb/DUT/offset_x_int
add wave -noupdate -radix unsigned /nono_graphics_cursor_tb/DUT/offset_y_int
add wave -noupdate /nono_graphics_cursor_tb/DUT/rcursorx
add wave -noupdate /nono_graphics_cursor_tb/DUT/ld_cursor
add wave -noupdate /nono_graphics_cursor_tb/DUT/rcursory
add wave -noupdate /nono_graphics_cursor_tb/DUT/in_xcoor_int
add wave -noupdate /nono_graphics_cursor_tb/DUT/ld_coords_int
add wave -noupdate -radix unsigned /nono_graphics_cursor_tb/DUT/in_ycoor_int
add wave -noupdate -radix unsigned /nono_graphics_cursor_tb/DUT/cont_dir
add wave -noupdate /nono_graphics_cursor_tb/DUT/clr_cont
add wave -noupdate /nono_graphics_cursor_tb/DUT/incr_cont
add wave -noupdate /nono_graphics_cursor_tb/DUT/end_cont
add wave -noupdate -radix unsigned /nono_graphics_cursor_tb/DUT/same
add wave -noupdate /nono_graphics_cursor_tb/DUT/incr_same
add wave -noupdate /nono_graphics_cursor_tb/DUT/win
add wave -noupdate /nono_graphics_cursor_tb/DUT/wr
add wave -noupdate /nono_graphics_cursor_tb/DUT/rd
add wave -noupdate /nono_graphics_cursor_tb/DUT/data_out
add wave -noupdate -divider -height 37 RAM
add wave -noupdate /nono_graphics_cursor_tb/DUT/RAM/clk
add wave -noupdate /nono_graphics_cursor_tb/DUT/RAM/reset_l
add wave -noupdate -radix unsigned /nono_graphics_cursor_tb/DUT/RAM/addr
add wave -noupdate /nono_graphics_cursor_tb/DUT/RAM/data_in
add wave -noupdate /nono_graphics_cursor_tb/DUT/RAM/WR
add wave -noupdate /nono_graphics_cursor_tb/DUT/RAM/RD
add wave -noupdate /nono_graphics_cursor_tb/DUT/RAM/data_out
add wave -noupdate /nono_graphics_cursor_tb/DUT/RAM/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7518519 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {10025 ns} {20525 ns}
